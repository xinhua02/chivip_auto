# AGENTS

This file helps coding agents work productively in this repository.

## Project Scope

- Main active verification target is AMBA CHI VIP under [sv/amba_chi_vip](sv/amba_chi_vip).
- Shared verification utilities are under [sv/verif_common_lib](sv/verif_common_lib).
- Coding style source of truth is [doc/DVCodingStyle.md](doc/DVCodingStyle.md).

## Authoritative Docs

- Repository overview: [README.md](README.md)
- CHI VIP overview: [sv/amba_chi_vip/README.md](sv/amba_chi_vip/README.md)
- DV base library notes: [sv/verif_common_lib/dv_lib/README.md](sv/verif_common_lib/dv_lib/README.md)

Use links above instead of duplicating long style or methodology text here.

## Build And Run Commands

Run from repository root unless noted.

- CHI regression (compile once + multi-test run):
  - powershell: Set-Location sv/amba_chi_vip/script; ./run_amba_chi_regression.ps1
- Single test do-file flow:
  - powershell: Set-Location sv/amba_chi_vip/script; C:/questasim64_2021.1/win64/vsim.exe -do run_amba_chi.do

Toolchain assumptions used by existing scripts:
- Questa installed at C:/questasim64_2021.1/win64
- UVM library available as mtiUvm/uvm for vlog and vsim

## Expected Regression Behavior

Current directed intent in [sv/amba_chi_vip/script/run_amba_chi_regression.ps1](sv/amba_chi_vip/script/run_amba_chi_regression.ps1):

- Expected PASS: amba_chi_base_test, amba_chi_write_test, amba_chi_snoop_test
- Expected FAIL (negative tests): amba_chi_reorder_test, amba_chi_overflow_test

Do not treat negative-test FAIL as regression failure if match signatures are present.

## Artifact And Git Hygiene

- Simulation outputs are intentionally centralized under [sv/amba_chi_vip/sim_output](sv/amba_chi_vip/sim_output).
- Questa work library directory [sv/amba_chi_vip/work](sv/amba_chi_vip/work) is generated and ignored.
- Ignore policy lives in [.gitignore](.gitignore). Keep generated logs/waves/transcripts out of commits.

## SystemVerilog/UVM Conventions For This Repo

- Preserve one-class-per-file and package include ordering used by the CHI VIP fileset in [sv/amba_chi_vip/amba_chi.core](sv/amba_chi_vip/amba_chi.core).
- Keep top testbench naming consistent with style guide expectations: tb module in [sv/amba_chi_vip/tb.sv](sv/amba_chi_vip/tb.sv).
- Prefer role-aware changes (master/slave symmetry) across:
  - driver: [sv/amba_chi_vip/amba_chi_driver.sv](sv/amba_chi_vip/amba_chi_driver.sv)
  - monitor: [sv/amba_chi_vip/amba_chi_monitor.sv](sv/amba_chi_vip/amba_chi_monitor.sv)
  - scoreboard: [sv/amba_chi_vip/amba_chi_scoreboard.sv](sv/amba_chi_vip/amba_chi_scoreboard.sv)

## Common Pitfalls

- Do not compile include files as standalone compilation units; compile package top files in the scripted order.
- If simulation hangs, inspect role ownership and handshake progression before widening timeouts.
- Keep output redirection behavior in scripts intact so root directory stays clean.

## When Editing

- Make the smallest focused patch and preserve existing naming/style patterns.
- Re-run at least the relevant CHI tests after protocol logic changes.
- If adding new tests, update regression script expectations and summary logic accordingly.
