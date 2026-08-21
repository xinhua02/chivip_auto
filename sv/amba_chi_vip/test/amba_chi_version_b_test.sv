class amba_chi_version_b_test extends amba_chi_base_test;
  `uvm_component_utils(amba_chi_version_b_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.master_cfg.version = AMBA_CHI_VERSION_B;
    cfg.slave_cfg.version = AMBA_CHI_VERSION_B;
  endfunction

  task run_phase(uvm_phase phase);
    amba_chi_version_matrix_vseq vseq;

    phase.raise_objection(this);
    vseq = amba_chi_version_matrix_vseq::type_id::create("vseq");
    vseq.version = AMBA_CHI_VERSION_B;
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
