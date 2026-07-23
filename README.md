# chivip_auto

Top-level workspace for AMBA CHI verification IP development and regression automation.

## Scope

- Main target: `sv/amba_chi_vip`
- Shared DV utilities: `sv/verif_common_lib`
- Coding style reference: `doc/DVCodingStyle.md`

## Repository Layout

```text
doc/                      Coding standards and methodology notes
sv/amba_chi_vip/          AMBA CHI VIP sources, tests, scripts, and sim artifacts
sv/verif_common_lib/      Reusable DV base library and utilities
```

## Prerequisites

- Windows + PowerShell
- QuestaSim installed at `C:/questasim64_2021.1/win64`
- UVM libraries available for `vlog` / `vsim` (`uvm`, `mtiUvm`)

## Quick Start

Run from repository root.

### Run Full CHI Regression

```powershell
Set-Location sv/amba_chi_vip/script
./run_amba_chi_regression.ps1
```

Behavior of `run_amba_chi_regression.ps1`:

- Rebuilds the `work` library
- Compiles CHI package/top files in a fixed order
- Runs 5 directed tests
- Generates per-test logs and waves under `sv/amba_chi_vip/sim_output`
- Creates `sv/amba_chi_vip/sim_output/regression_summary.txt`

### Run Single Test via DO File

```powershell
Set-Location sv/amba_chi_vip/script
C:/questasim64_2021.1/win64/vsim.exe -do run_amba_chi.do
```

This flow compiles and runs `amba_chi_base_test` in batch mode.

## Regression Expectations

Current directed intent:

- Expected PASS: `amba_chi_base_test`, `amba_chi_write_test`, `amba_chi_snoop_test`
- Expected FAIL (negative tests): `amba_chi_reorder_test`, `amba_chi_overflow_test`

Negative-test failures are considered correct only when their expected signature is observed:

- Reorder: `response ordering violation`
- Overflow: `outstanding request limit exceeded`

## Generated Artifacts

- Simulation outputs are centralized in `sv/amba_chi_vip/sim_output`
- Questa `work` library under `sv/amba_chi_vip/work` is generated
- Keep generated logs/waves/transcripts out of commits

## Key Docs

- CHI VIP summary: `sv/amba_chi_vip/README.md`
- DV base library notes: `sv/verif_common_lib/dv_lib/README.md`
- Utility library notes: `sv/verif_common_lib/dv_utils/README.md`

## Development Notes

- Preserve package/include ordering in `sv/amba_chi_vip/amba_chi.core`
- Keep role-aware changes symmetric across master/slave paths
- Re-run relevant tests after protocol logic changes
- If adding tests, update regression expectations in the script and summary criteria
