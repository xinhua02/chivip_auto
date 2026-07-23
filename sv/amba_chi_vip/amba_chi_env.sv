class amba_chi_env extends uvm_env;
  `uvm_component_utils(amba_chi_env)

  amba_chi_env_cfg cfg;
  amba_chi_master_agent master_agent;
  amba_chi_slave_agent slave_agent;
  amba_chi_virtual_sequencer virtual_sequencer;
  amba_chi_env_cov cov;
  amba_chi_scoreboard scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(amba_chi_env_cfg)::get(this, "", "cfg", cfg)) begin
      cfg = amba_chi_env_cfg::type_id::create("cfg");
    end

    uvm_config_db#(amba_chi_cfg)::set(this, "master_agent", "cfg", cfg.master_cfg);
    uvm_config_db#(amba_chi_cfg)::set(this, "slave_agent", "cfg", cfg.slave_cfg);

    master_agent = amba_chi_master_agent::type_id::create("master_agent", this);
    slave_agent = amba_chi_slave_agent::type_id::create("slave_agent", this);
    virtual_sequencer = amba_chi_virtual_sequencer::type_id::create("virtual_sequencer", this);

    if (cfg.en_cov) begin
      cov = amba_chi_env_cov::type_id::create("cov", this);
    end

    if (cfg.en_scoreboard) begin
      scoreboard = amba_chi_scoreboard::type_id::create("scoreboard", this);
      scoreboard.cfg = cfg;
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    virtual_sequencer.vif = cfg.master_cfg.vif;
    virtual_sequencer.master_sequencer = master_agent.sequencer;
    virtual_sequencer.slave_sequencer = slave_agent.sequencer;

    if (scoreboard != null) begin
      master_agent.monitor.analysis_port.connect(scoreboard.master_imp);
      slave_agent.monitor.analysis_port.connect(scoreboard.slave_imp);
    end

    if (cov != null) begin
      master_agent.monitor.analysis_port.connect(cov.master_imp);
      slave_agent.monitor.analysis_port.connect(cov.slave_imp);
    end
  endfunction
endclass