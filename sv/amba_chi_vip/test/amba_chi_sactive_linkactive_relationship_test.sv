class amba_chi_sactive_linkactive_relationship_test extends amba_chi_base_test;
  `uvm_component_utils(amba_chi_sactive_linkactive_relationship_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    virtual amba_chi_if vif;

    phase.raise_objection(this);

    vif = cfg.master_cfg.vif;
    if (vif == null) begin
      `uvm_fatal(get_type_name(), "sactive relationship test requires master vif")
    end

    wait (vif.rst_n == 1'b1);

    @(posedge vif.clk);
    vif.TXLINKACTIVEREQ <= 1'b1;
    vif.RXLINKACTIVEREQ <= 1'b1;
    vif.TXLINKACTIVEACK <= 1'b1;
    vif.RXLINKACTIVEACK <= 1'b1;

    @(posedge vif.clk);
    vif.TXSACTIVE <= 1'b1;
    vif.RXSACTIVE <= 1'b1;

    @(posedge vif.clk);
    if ((vif.TXSACTIVE && !(vif.TXLINKACTIVEREQ && vif.TXLINKACTIVEACK)) ||
        (vif.RXSACTIVE && !(vif.RXLINKACTIVEREQ && vif.RXLINKACTIVEACK))) begin
      `uvm_error(get_type_name(), "SACTIVE asserted without LINKACTIVE handshake")
    end

    @(posedge vif.clk);
    vif.TXSACTIVE <= 1'b0;
    vif.RXSACTIVE <= 1'b0;
    vif.TXLINKACTIVEREQ <= 1'b0;
    vif.RXLINKACTIVEREQ <= 1'b0;
    vif.TXLINKACTIVEACK <= 1'b0;
    vif.RXLINKACTIVEACK <= 1'b0;

    #(response_drain_ns);
    phase.drop_objection(this);
  endtask
endclass
