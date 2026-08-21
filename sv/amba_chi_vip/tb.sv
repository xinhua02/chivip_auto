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
    int unsigned req_delay_cycles;
    int unsigned rsp_delay_cycles;
    int unsigned dat_delay_cycles;
    int unsigned snp_delay_cycles;

    cfg = amba_chi_env_cfg::type_id::create("cfg");
    cfg.master_cfg.vif = chi_if;
    cfg.slave_cfg.vif = chi_if;

    if ($value$plusargs("REQ_DELAY=%d", req_delay_cycles)) begin
      cfg.master_cfg.req_channel_delay_cycles = req_delay_cycles;
    end
    if ($value$plusargs("RSP_DELAY=%d", rsp_delay_cycles)) begin
      cfg.slave_cfg.rsp_channel_delay_cycles = rsp_delay_cycles;
    end
    if ($value$plusargs("DAT_DELAY=%d", dat_delay_cycles)) begin
      cfg.slave_cfg.dat_channel_delay_cycles = dat_delay_cycles;
    end
    if ($value$plusargs("SNP_DELAY=%d", snp_delay_cycles)) begin
      cfg.slave_cfg.snp_channel_delay_cycles = snp_delay_cycles;
    end

    $display("[CHI_TB_CFG] delay_cycles req=%0d rsp=%0d dat=%0d snp=%0d",
             cfg.master_cfg.req_channel_delay_cycles,
             cfg.slave_cfg.rsp_channel_delay_cycles,
             cfg.slave_cfg.dat_channel_delay_cycles,
             cfg.slave_cfg.snp_channel_delay_cycles);

    uvm_config_db#(amba_chi_env_cfg)::set(null, "uvm_test_top", "cfg", cfg);
    run_test();
  end
endmodule