$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$workDir = Split-Path -Parent $scriptDir
$simRoot = 'C:\questasim64_2021.1\win64'
$outputDir = Join-Path $workDir 'sim_output'
Set-Location $workDir

if (!(Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

if (Test-Path 'transcript') {
  Remove-Item -Force 'transcript'
}

$tests = @(
  @{
    Name = 'amba_chi_base_test'
    ExpectPass = $true
    Match = 'UVM_ERROR\s*:\s*0'
  },
  @{
    Name = 'amba_chi_write_test'
    ExpectPass = $true
    Match = 'UVM_ERROR\s*:\s*0'
  },
  @{
    Name = 'amba_chi_snoop_test'
    ExpectPass = $true
    Match = 'UVM_ERROR\s*:\s*0'
  },
  @{
    Name = 'amba_chi_snoop_burst_test'
    ExpectPass = $true
    Match = 'UVM_ERROR\s*:\s*0'
  },
  @{
    Name = 'amba_chi_snoop_orphan_test'
    ExpectPass = $false
    Match = 'snoop txn_id=0x52ff has no matching request'
  },
  @{
    Name = 'amba_chi_reorder_test'
    ExpectPass = $false
    Match = 'response ordering violation'
  },
  @{
    Name = 'amba_chi_overflow_test'
    ExpectPass = $false
    Match = 'outstanding request limit exceeded'
  }
)

$sources = @(
  'amba_chi_if.sv',
  'amba_chi_pkg.sv',
  'amba_chi_agent_pkg.sv',
  'amba_chi_master_pkg.sv',
  'amba_chi_slave_pkg.sv',
  'amba_chi_env_pkg.sv',
  'amba_chi_test_pkg.sv',
  'tb.sv'
)

if (Test-Path work) {
  & "$simRoot\vdel.exe" -lib work -all | Out-Host
}

& "$simRoot\vlib.exe" work | Out-Host

$compileOutput = & "$simRoot\vlog.exe" -sv -L uvm -work work @sources 2>&1
$compileLog = Join-Path $outputDir 'compile_regression.log'
$compileOutput | Tee-Object -FilePath $compileLog | Out-Host
if (Test-Path 'transcript') {
  Move-Item -Force 'transcript' (Join-Path $outputDir 'compile_regression.transcript')
}
if ($LASTEXITCODE -ne 0) {
  throw "Compilation failed. See $compileLog."
}

$summary = @()

foreach ($test in $tests) {
  $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
  $wlfName = "{0}_{1}.wlf" -f $test.Name, $stamp
  $logName = "{0}_{1}.log" -f $test.Name, $stamp
  $wlf = Join-Path $outputDir $wlfName
  $log = Join-Path $outputDir $logName

  $simOutput = & "$simRoot\vsim.exe" -c -L mtiUvm -sv_seed random -wlf $wlf work.tb "+UVM_TESTNAME=$($test.Name)" -do "log -r /*; add wave -r /*; run -all; quit -f" 2>&1
  $simOutput | Tee-Object -FilePath $log | Out-Host
  if (Test-Path 'transcript') {
    Move-Item -Force 'transcript' (Join-Path $outputDir ("{0}_{1}.transcript" -f $test.Name, $stamp))
  }

  $matched = Select-String -Path $log -Pattern $test.Match -Quiet
  $isCleanPass = Select-String -Path $log -Pattern 'UVM_ERROR\s*:\s*0' -Quiet
  $observed = if ($isCleanPass) { 'PASS' } else { 'FAIL' }
  $asExpected = if ($test.ExpectPass) {
    $observed -eq 'PASS'
  } else {
    ($observed -eq 'FAIL') -and $matched
  }

  $summary += [pscustomobject]@{
    Test = $test.Name
    Expected = if ($test.ExpectPass) { 'PASS' } else { 'FAIL' }
    Observed = $observed
    AsExpected = if ($asExpected) { 'PASS' } else { 'FAIL' }
    Wave = $wlfName
    Log = $logName
  }
}

$summaryPath = Join-Path $outputDir 'regression_summary.txt'
$summary | Format-Table -AutoSize | Tee-Object -FilePath $summaryPath | Out-Host

$unexpected = $summary | Where-Object { $_.AsExpected -ne 'PASS' }
if ($unexpected) {
  throw "Regression had unexpected outcomes. See $summaryPath."
}