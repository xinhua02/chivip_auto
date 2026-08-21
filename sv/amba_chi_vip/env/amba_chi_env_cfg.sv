class amba_chi_env_cfg extends uvm_object;
  `uvm_object_utils(amba_chi_env_cfg)

  amba_chi_cfg master_cfg;
  amba_chi_cfg slave_cfg;
  bit en_cov = 1'b1;
  bit en_scoreboard = 1'b1;
  bit en_in_order_resp = 1'b0;
  bit require_full_cov = 1'b0;

  function new(string name = "amba_chi_env_cfg");
    super.new(name);
    master_cfg = amba_chi_cfg::type_id::create("master_cfg");
    slave_cfg = amba_chi_cfg::type_id::create("slave_cfg");
    master_cfg.role = AMBA_CHI_ROLE_MASTER;
    slave_cfg.role = AMBA_CHI_ROLE_SLAVE;
    master_cfg.is_active_master = 1'b1;
    master_cfg.is_active_slave = 1'b0;
    slave_cfg.is_active_master = 1'b0;
    slave_cfg.is_active_slave = 1'b1;
  endfunction
endclass