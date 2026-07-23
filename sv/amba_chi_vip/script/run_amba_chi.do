set script_dir [file dirname [info script]]
set root_dir [file normalize [file join $script_dir ..]]
set out_dir [file normalize [file join $root_dir sim_output]]
cd $root_dir

file mkdir $out_dir

if {[file exists transcript]} {
  file delete -force transcript
}

if {[file exists work]} {
  vdel -lib work -all
}

vlib work

vlog -sv -L uvm -work work \
  amba_chi_if.sv \
  amba_chi_pkg.sv \
  amba_chi_agent_pkg.sv \
  amba_chi_master_pkg.sv \
  amba_chi_slave_pkg.sv \
  amba_chi_env_pkg.sv \
  amba_chi_test_pkg.sv \
  tb.sv

transcript file [file join $out_dir amba_chi_base_test.transcript]

vsim -c -L mtiUvm -sv_seed random -wlf [file join $out_dir amba_chi_base_test.wlf] work.tb +UVM_TESTNAME=amba_chi_base_test -do {
  log -r /*
  add wave -r /*
  run -all
  quit -f
}