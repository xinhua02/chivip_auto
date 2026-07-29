# AMBA CHI VIP

Shared CHI verification IP with separate master and slave role packages built on the UVM methodology.

## Interface Architecture

The DUT interface [amba_chi_if.sv](amba_chi_if.sv) is **flit-based**. Each of the four CHI channels
carries a single packed-struct flit alongside a `valid`/`ready` handshake pair, rather than exposing
dozens of individual signals.

### Parameters

| Parameter    | Default | Description             |
| ------------ | ------- | ----------------------- |
| `ADDR_WIDTH` | 64      | Request address width   |
| `DATA_WIDTH` | 128     | Data payload bit width  |

### Channels and Flit Types

| Channel  | Handshake                   | Flit signal   | Flit type      |
| -------- | --------------------------- | ------------- | -------------- |
| Request  | `req_valid` / `req_ready`   | `req_flit`    | `req_flit_t`   |
| Response | `resp_valid` / `resp_ready` | `resp_flit`   | `resp_flit_t`  |
| Data     | `data_valid` / `data_ready` | `data_flit`   | `data_flit_t`  |
| Snoop    | `snoop_valid`/`snoop_ready` | `snoop_flit`  | `snoop_flit_t` |

### Flit Field Summary

- `req_flit_t`: `opcode`, `txn_id`, `addr`, `data`, `src_id`, `tgt_id`, `qos`, `txn_type`, `order`,
  `size`, `mem_attr`, `endian`, `allow_retry`, `exp_comp_dbid`, `trace_tag`
- `resp_flit_t`: `opcode`, `status`, `err`, `txn_id`, `dbid`, `ccid`, `trace_tag`
- `data_flit_t`: `payload`, `txn_id`, `id`, `last`, `poison`, `be`, `dbid`, `ccid`, `trace_tag`
- `snoop_flit_t`: `type_`, `txn_id`, `attr`, `fwd_nid`, `trace_tag`

### Modports

- `master`: drives request, accepts response/data/snoop
- `slave`: accepts request, drives response/data/snoop
- `monitor`: observes all channels (all inputs)

Access flit fields with dotted notation, e.g. `vif.req_flit.opcode`, `vif.data_flit.payload`.
The [amba_chi_driver.sv](amba_chi_driver.sv) and [amba_chi_monitor.sv](amba_chi_monitor.sv)
translate between flit fields and the `amba_chi_item` transaction object, so sequences,
scoreboard, and coverage remain decoupled from the wire-level flit layout.

## Component Layout

| File                                                 | Role                                    |
| ---------------------------------------------------- | --------------------------------------- |
| [amba_chi_if.sv](amba_chi_if.sv)                     | Flit-based DUT interface + modports     |
| [amba_chi_pkg.sv](amba_chi_pkg.sv)                   | Shared types, enums, protocol helpers   |
| [amba_chi_driver.sv](amba_chi_driver.sv)             | Role-aware flit driver                  |
| [amba_chi_monitor.sv](amba_chi_monitor.sv)           | Flit sampler to `amba_chi_item`         |
| [amba_chi_scoreboard.sv](amba_chi_scoreboard.sv)     | Protocol + ordering checks              |
| [amba_chi_env.sv](amba_chi_env.sv)                   | Paired master/slave environment         |
| [tb.sv](tb.sv)                                       | Top testbench wiring clock/reset/config |

## Build and Run

Run from the repository root.

### Full Regression

```powershell
Set-Location sv/amba_chi_vip/script
./run_amba_chi_regression.ps1
```

### Single Test via DO File

```powershell
Set-Location sv/amba_chi_vip/script
C:/questasim64_2021.1/win64/vsim.exe -do run_amba_chi.do
```

## Regression Expectations

- Expected PASS: `amba_chi_base_test`, `amba_chi_write_test`, `amba_chi_snoop_test`,
  `amba_chi_feature_matrix_test`, `amba_chi_txn_coverage_test`,
  `amba_chi_version_a_test` ... `amba_chi_version_e_test`,
  `amba_chi_data_multibeat_test`, `amba_chi_snoop_burst_test`
- Expected FAIL (negative tests, correct only with matching signature):
  - `amba_chi_snoop_orphan_test` -> `snoop txn_id=0x52ff has no matching request`
  - `amba_chi_reorder_test` -> `response ordering violation`
  - `amba_chi_overflow_test` -> `outstanding request limit exceeded`

Per-test logs, waves, and `regression_summary.txt` are written under
[sim_output](sim_output).

## Development Notes

- Preserve package/include ordering in [amba_chi.core](amba_chi.core).
- Keep changes role-symmetric across master/slave paths.
- Extend a flit by adding a struct member in [amba_chi_if.sv](amba_chi_if.sv); the modports need
  no change since they reference the whole flit.
- Re-run the relevant CHI tests after protocol logic changes.