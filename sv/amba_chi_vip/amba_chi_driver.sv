// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class amba_chi_driver extends uvm_driver#(amba_chi_item);
  `uvm_component_utils(amba_chi_driver)

  amba_chi_cfg cfg;
  virtual amba_chi_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    amba_chi_item req;

    if (vif == null) begin
      `uvm_fatal(get_type_name(), "amba_chi_driver requires a virtual interface")
    end
    if (cfg == null) begin
      `uvm_fatal(get_type_name(), "amba_chi_driver requires cfg")
    end

    wait (vif.rst_n == 1'b1);

    if (cfg.role == AMBA_CHI_ROLE_MASTER) begin
      vif.req_valid <= 1'b0;
      vif.resp_ready <= 1'b1;
      vif.data_ready <= 1'b1;
      vif.snoop_ready <= 1'b1;
    end else begin
      vif.req_ready <= 1'b1;
      vif.resp_valid <= 1'b0;
      vif.data_valid <= 1'b0;
      vif.snoop_valid <= 1'b0;
    end

    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask

  protected virtual task drive_item(amba_chi_item item);
    @(posedge vif.clk);
    if (cfg.role == AMBA_CHI_ROLE_MASTER) begin
      case (item.channel)
        AMBA_CHI_CH_REQ: begin
          vif.req_opcode <= item.opcode;
          vif.req_txn_id <= item.txn_id;
          vif.req_addr <= item.address;
          vif.req_data <= '0;
          vif.req_valid <= 1'b1;
          wait (vif.req_ready == 1'b1);
          @(posedge vif.clk);
          vif.req_valid <= 1'b0;
        end
        default: begin
          `uvm_error(get_type_name(), $sformatf("master driver got unexpected channel %0d", item.channel))
        end
      endcase
    end else begin
      case (item.channel)
        AMBA_CHI_CH_RESP: begin
          vif.resp_txn_id <= item.txn_id;
          vif.resp_status <= item.resp_status;
          vif.resp_valid <= 1'b1;
          wait (vif.resp_ready == 1'b1);
          @(posedge vif.clk);
          vif.resp_valid <= 1'b0;
        end
        AMBA_CHI_CH_DATA: begin
          vif.data_payload <= item.data_words.size() > 0 ? item.data_words[0] : '0;
          vif.data_valid <= 1'b1;
          wait (vif.data_ready == 1'b1);
          @(posedge vif.clk);
          vif.data_valid <= 1'b0;
        end
        AMBA_CHI_CH_SNOOP: begin
          vif.snoop_txn_id <= item.txn_id;
          vif.snoop_type <= item.snoop_type;
          vif.snoop_valid <= 1'b1;
          wait (vif.snoop_ready == 1'b1);
          @(posedge vif.clk);
          vif.snoop_valid <= 1'b0;
        end
        default: begin
          `uvm_error(get_type_name(), $sformatf("slave driver got unexpected channel %0d", item.channel))
        end
      endcase
    end
  endtask
endclass