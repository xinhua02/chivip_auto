# CHI VIP Feature Coverage Matrix (vs IHI0050H)

This matrix checks currently implemented AMBA CHI VIP features against the top-level feature areas in IHI0050H Issue H, and maps them to tests and functional coverage points.

## Scope Note

- This VIP models a focused CHI subset for request/response/data/snoop flows plus selected semantic checks.
- "Implemented" below means represented by VIP types/logic/tests.
- "Coverage Added" refers to updates in `amba_chi_env_cov.sv` in this change.

## Matrix

| Spec Area (Issue H) | VIP Status | Evidence (tests/logic) | Coverage Added/Updated |
| --- | --- | --- | --- |
| B2 Transactions (REQ/RSP/DAT/SNP basic flow) | Implemented (subset) | `amba_chi_pkg.sv` opcodes/types, driver/monitor/scoreboard, `amba_chi_base_test.sv`, `amba_chi_txn_coverage_test.sv` | Request opcode bins, response status bins, data beat/id/last bins, snoop type bins, req-resp correlation cross |
| B3 Network Layer | Partial | credit/backpressure style scenarios in `amba_chi_credit_recover_test.sv`, retry/backpressure tests | No dedicated topology/routing-level coverage yet |
| B4 Coherence Protocol | Partial | snoop + ordering behaviors in `amba_chi_snoop_test.sv`, `amba_chi_ordering_positive_test.sv`, `amba_chi_snoop_burst_test.sv` | Snoop type/attr/fwd_nid coverpoints and crosses |
| B5 Interconnect Protocol Flows | Partial | scoreboard transaction matching and completion flow checks | req-resp-snoop correlation covergroup |
| B6 Exclusive Accesses | Partial | `READ_EXCL` exists in enums and sequence usage | Included in request opcode coverage bins |
| B7 Cache Stashing | Implemented (subset) | `STASH_ONCE_SHARED` req/snoop in version E and tests (`amba_chi_feature_matrix_test.sv`, `amba_chi_snoop_type_matrix_test.sv`) | Stash bins in request and snoop coverpoints + correlation cross |
| B8 DVM Operations | Implemented (subset) | `DVM_OP` req and `SNOOP_DVM` tests (`amba_chi_dvm_sync_nonsync_test.sv`) | DVM bins in request/snoop + correlation cross |
| B9 Error Handling | Partial | retry/fail/poison/mecid mismatch tests (`amba_chi_retry_reissue_test.sv`, `amba_chi_poison_semantics_test.sv`, `amba_chi_mecid_mismatch_resolution_test.sv`) | response error bins, retry/COMPDB expectation bins, mecid-mismatch x poison cross |
| B10 Realm Management Extension | Not implemented | no realm-specific fields/opcodes/checkers found | none |
| B11 System Control/Debug/Trace/Monitoring | Partial | trace_tag field exists in flits/items; no dedicated protocol checker | no dedicated trace coverage |
| B12 Memory Tagging | Not implemented | no memory-tag related fields/protocol elements found | none |
| B13 Link Layer | Partial | interface defines link signals; link behavior tests exist (`amba_chi_linkactive_state_machine_test.sv`) | New link-state covergroup over TX/RX link request/ack states |
| B14 Link Handshake | Partial | handshake tests (`amba_chi_sactive_linkactive_relationship_test.sv`) | New sactive-link cross coverage |
| B15 System Coherency Interface | Not implemented | no SCI message model found | none |
| B16 Properties/Parameters/Broadcast | Partial | config limits and strict checking in `amba_chi_cfg` + scoreboard | indirect through request/response/data attribute coverage |
| Version progression to CHI-F | Implemented (subset parity with E) | `AMBA_CHI_VERSION_F` in `amba_chi_pkg.sv`, rules in `rules/amba_chi_rules_vF.svh`, `amba_chi_version_f_test.sv` in regression | version-aware bins include F; CHI-F test observed PASS |

## New Functional Coverage Added in This Change

- Request feature points:
  - version, opcode class, allow_retry, exp_comp_dbid, order, payload-presence
  - crosses: version x opcode, allow_retry x opcode, exp_comp_dbid x opcode
- Response feature points:
  - status, resp_err, DBID-presence
  - crosses: version x status, status x err, COMPDB x DBID-presence
- Data feature points:
  - data_id, data_last, poison, mismatched_mecid, byte-enable patterns, PAS
  - crosses: mecid-mismatch x poison, data_id x last, PAS x poison
- Snoop feature points:
  - snoop type, snoop attr, forward-node presence
  - crosses: snoop type x attr, snoop type x fwd_nid-presence
- Link feature points:
  - TX/RX link req-ack pair states and TX/RX SACTIVE state combinations
  - crosses for linkactive combinations and sactive-to-linkactive relationship
- Request/response correlation points:
  - req opcode x resp status
  - req opcode x snoop type (including no-snoop bucket)

## Remaining High-Priority Gaps

1. Add explicit feature modeling/coverage for Issue H extensions not yet represented in VIP data model:
   - Realm Management Extension (B10)
   - Memory Tagging (B12)
   - SCI (B15)
2. Add network-layer oriented coverage (credit/deadlock/retry windows) tied to B3 semantics.
3. Add trace/debug semantic coverage if trace_tag behavior is required by your signoff plan.
