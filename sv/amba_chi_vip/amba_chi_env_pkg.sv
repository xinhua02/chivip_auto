// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package amba_chi_env_pkg;
  import uvm_pkg::*;
  import amba_chi_pkg::*;
  import amba_chi_agent_pkg::*;
  import amba_chi_master_pkg::*;
  import amba_chi_slave_pkg::*;

  `include "uvm_macros.svh"

  `include "amba_chi_env_cfg.sv"
  `include "amba_chi_env_cov.sv"
  `include "amba_chi_virtual_sequencer.sv"
  `include "amba_chi_scoreboard.sv"
  `include "amba_chi_env.sv"
  `include "amba_chi_master_base_seq.sv"
  `include "amba_chi_slave_base_seq.sv"
  `include "amba_chi_master_write_seq.sv"
  `include "amba_chi_slave_write_seq.sv"
  `include "amba_chi_master_snoop_seq.sv"
  `include "amba_chi_slave_snoop_seq.sv"
  `include "amba_chi_master_reorder_seq.sv"
  `include "amba_chi_slave_reorder_seq.sv"
  `include "amba_chi_master_overflow_seq.sv"
  `include "amba_chi_slave_overflow_seq.sv"
  `include "amba_chi_base_vseq.sv"
  `include "amba_chi_write_vseq.sv"
  `include "amba_chi_snoop_vseq.sv"
  `include "amba_chi_reorder_vseq.sv"
  `include "amba_chi_overflow_vseq.sv"
  `include "amba_chi_base_test.sv"
  `include "amba_chi_write_test.sv"
  `include "amba_chi_snoop_test.sv"
  `include "amba_chi_reorder_test.sv"
  `include "amba_chi_overflow_test.sv"

endpackage