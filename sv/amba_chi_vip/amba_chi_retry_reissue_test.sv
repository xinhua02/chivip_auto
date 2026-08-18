class amba_chi_retry_reissue_test extends amba_chi_base_test;
  `uvm_component_utils(amba_chi_retry_reissue_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    amba_chi_retry_reissue_vseq vseq;

    phase.raise_objection(this);
    vseq = amba_chi_retry_reissue_vseq::type_id::create("vseq");
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
