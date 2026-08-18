class amba_chi_linkactive_state_machine_test extends amba_chi_base_test;
  `uvm_component_utils(amba_chi_linkactive_state_machine_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    virtual amba_chi_if vif;

    phase.raise_objection(this);

    vif = cfg.master_cfg.vif;
    if (vif == null) begin
      `uvm_fatal(get_type_name(), "linkactive test requires master vif")
    end

    wait (vif.rst_n == 1'b1);

    // Activate outbound/inbound link directions.
    @(posedge vif.clk);
    vif.TXLINKACTIVEREQ <= 1'b1;
    vif.RXLINKACTIVEREQ <= 1'b1;
    @(posedge vif.clk);
    vif.TXLINKACTIVEACK <= 1'b1;
    vif.RXLINKACTIVEACK <= 1'b1;

    @(posedge vif.clk);
    if (!(vif.TXLINKACTIVEREQ && vif.TXLINKACTIVEACK &&
          vif.RXLINKACTIVEREQ && vif.RXLINKACTIVEACK)) begin
      `uvm_error(get_type_name(), "link activation handshake did not converge")
    end

    // Deactivate link again and confirm clear.
    @(posedge vif.clk);
    vif.TXLINKACTIVEREQ <= 1'b0;
    vif.RXLINKACTIVEREQ <= 1'b0;
    vif.TXLINKACTIVEACK <= 1'b0;
    vif.RXLINKACTIVEACK <= 1'b0;

    @(posedge vif.clk);
    if (vif.TXLINKACTIVEREQ || vif.TXLINKACTIVEACK ||
        vif.RXLINKACTIVEREQ || vif.RXLINKACTIVEACK) begin
      `uvm_error(get_type_name(), "link deactivation handshake did not clear")
    end

    #(response_drain_ns);
    phase.drop_objection(this);
  endtask
endclass
