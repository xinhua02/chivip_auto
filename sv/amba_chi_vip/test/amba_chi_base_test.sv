class amba_chi_base_test extends uvm_test;
  `uvm_component_utils(amba_chi_base_test)

  amba_chi_env env;
  amba_chi_env_cfg cfg;
  time smoke_timeout_ns = 1000ns;
  time response_drain_ns = 100ns;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(amba_chi_env_cfg)::get(this, "", "cfg", cfg)) begin
      cfg = amba_chi_env_cfg::type_id::create("cfg");
    end

    uvm_config_db#(amba_chi_env_cfg)::set(this, "env", "cfg", cfg);
    env = amba_chi_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    amba_chi_base_vseq vseq;

    phase.raise_objection(this);
    vseq = amba_chi_base_vseq::type_id::create("vseq");
    fork
      begin
        vseq.start(env.virtual_sequencer);
      end
      begin
        #(smoke_timeout_ns);
        `uvm_error(get_type_name(), $sformatf("Smoke testcase timeout after %0t", smoke_timeout_ns))
      end
    join_any
    disable fork;
    #(response_drain_ns);
    phase.drop_objection(this);
  endtask
endclass