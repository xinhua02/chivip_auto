// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module tb;
  import uvm_pkg::*;
  import amba_chi_env_pkg::*;
  import amba_chi_test_pkg::*;

  `include "uvm_macros.svh"

  logic clk;
  logic rst_n;
  amba_chi_env_cfg cfg;
  amba_chi_if chi_if(.clk(clk), .rst_n(rst_n));

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n = 1'b0;
    #25 rst_n = 1'b1;
  end

  initial begin
    cfg = amba_chi_env_cfg::type_id::create("cfg");
    cfg.master_cfg.vif = chi_if;
    cfg.slave_cfg.vif = chi_if;
    uvm_config_db#(amba_chi_env_cfg)::set(null, "uvm_test_top", "cfg", cfg);
    run_test();
  end
endmodule