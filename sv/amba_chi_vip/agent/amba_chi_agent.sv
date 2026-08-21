class amba_chi_agent extends uvm_agent;
  `uvm_component_utils(amba_chi_agent)

  amba_chi_cfg cfg;
  amba_chi_sequencer sequencer;
  amba_chi_driver driver;
  amba_chi_monitor monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(amba_chi_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal(get_type_name(), "amba_chi_agent requires cfg in uvm_config_db")
    end

    monitor = amba_chi_monitor::type_id::create("monitor", this);
    monitor.cfg = cfg;
    monitor.vif = cfg.vif;

    if (cfg.is_active_master || cfg.is_active_slave) begin
      sequencer = amba_chi_sequencer::type_id::create("sequencer", this);
      driver = amba_chi_driver::type_id::create("driver", this);
      driver.cfg = cfg;
      driver.vif = cfg.vif;
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (driver != null && sequencer != null) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
endclass