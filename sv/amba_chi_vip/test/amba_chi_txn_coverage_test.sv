class amba_chi_txn_coverage_test extends amba_chi_base_test;
  `uvm_component_utils(amba_chi_txn_coverage_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.master_cfg.version = AMBA_CHI_VERSION_E;
    cfg.slave_cfg.version = AMBA_CHI_VERSION_E;
    cfg.require_full_cov = 1'b1;
  endfunction

  protected task drive_link_cov_sweep();
    virtual amba_chi_if vif;

    vif = cfg.master_cfg.vif;
    if (vif == null) begin
      `uvm_fatal(get_type_name(), "txn coverage test requires master vif for link sweep")
    end

    for (int sactive = 0; sactive < 2; sactive++) begin
      for (int tx_active = 0; tx_active < 2; tx_active++) begin
        for (int rx_active = 0; rx_active < 2; rx_active++) begin
          @(posedge vif.clk);
          vif.TXLINKACTIVEREQ <= tx_active;
          vif.TXLINKACTIVEACK <= tx_active;
          vif.RXLINKACTIVEREQ <= rx_active;
          vif.RXLINKACTIVEACK <= rx_active;
          vif.TXSACTIVE <= sactive;
          vif.RXSACTIVE <= sactive;
        end
      end
    end

    @(posedge vif.clk);
    vif.TXLINKACTIVEREQ <= 1'b0;
    vif.TXLINKACTIVEACK <= 1'b0;
    vif.RXLINKACTIVEREQ <= 1'b0;
    vif.RXLINKACTIVEACK <= 1'b0;
    vif.TXSACTIVE <= 1'b0;
    vif.RXSACTIVE <= 1'b0;
  endtask

  task run_phase(uvm_phase phase);
    amba_chi_txn_coverage_vseq vseq;

    phase.raise_objection(this);
    vseq = amba_chi_txn_coverage_vseq::type_id::create("vseq");
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
    drive_link_cov_sweep();
    #(response_drain_ns);
    phase.drop_objection(this);
  endtask
endclass
