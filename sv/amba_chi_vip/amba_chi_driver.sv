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
      vif.req_opcode <= '0;
      vif.req_txn_id <= '0;
      vif.req_addr <= '0;
      vif.req_data <= '0;
      vif.req_src_id <= '0;
      vif.req_tgt_id <= '0;
      vif.req_qos <= '0;
      vif.req_txn_type <= '0;
      vif.req_order <= '0;
      vif.req_size <= '0;
      vif.req_mem_attr <= '0;
      vif.req_endian <= '0;
      vif.req_allow_retry <= 1'b0;
      vif.req_exp_comp_dbid <= 1'b0;
      vif.req_trace_tag <= '0;
      vif.resp_ready <= 1'b1;
      vif.data_ready <= 1'b1;
      vif.snoop_ready <= 1'b1;
    end else begin
      vif.req_ready <= 1'b1;
      vif.resp_valid <= 1'b0;
      vif.resp_txn_id <= '0;
      vif.resp_opcode <= '0;
      vif.resp_status <= '0;
      vif.resp_err <= '0;
      vif.resp_dbid <= '0;
      vif.resp_ccid <= '0;
      vif.resp_trace_tag <= '0;
      vif.data_valid <= 1'b0;
      vif.data_txn_id <= '0;
      vif.data_id <= 1'b0;
      vif.data_last <= 1'b1;
      vif.data_poison <= 1'b0;
      vif.data_be <= '1;
      vif.data_dbid <= '0;
      vif.data_ccid <= '0;
      vif.data_trace_tag <= '0;
      vif.snoop_valid <= 1'b0;
      vif.snoop_txn_id <= '0;
      vif.snoop_type <= '0;
      vif.snoop_attr <= '0;
      vif.snoop_fwd_nid <= '0;
      vif.snoop_trace_tag <= '0;
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
          vif.req_data <= item.data_words.size() > 0 ? item.data_words[0] : '0;
          vif.req_src_id <= item.src_id;
          vif.req_tgt_id <= item.tgt_id;
          vif.req_qos <= item.qos;
          vif.req_txn_type <= item.txn_type;
          vif.req_order <= item.order;
          vif.req_size <= item.size;
          vif.req_mem_attr <= item.mem_attr;
          vif.req_endian <= item.endian;
          vif.req_allow_retry <= item.allow_retry;
          vif.req_exp_comp_dbid <= item.exp_comp_dbid;
          vif.req_trace_tag <= item.trace_tag;
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
          vif.resp_opcode <= item.resp_opcode;
          vif.resp_status <= item.resp_status;
          vif.resp_err <= item.resp_err;
          vif.resp_dbid <= item.dbid;
          vif.resp_ccid <= item.ccid;
          vif.resp_trace_tag <= item.trace_tag;
          vif.resp_valid <= 1'b1;
          wait (vif.resp_ready == 1'b1);
          @(posedge vif.clk);
          vif.resp_valid <= 1'b0;
        end
        AMBA_CHI_CH_DATA: begin
          vif.data_txn_id <= item.txn_id;
          vif.data_payload <= item.data_words.size() > 0 ? item.data_words[0] : '0;
          vif.data_id <= item.data_id;
          vif.data_last <= item.data_last;
          vif.data_poison <= item.data_poison;
          vif.data_be <= item.data_be;
          vif.data_dbid <= item.dbid;
          vif.data_ccid <= item.ccid;
          vif.data_trace_tag <= item.trace_tag;
          vif.data_valid <= 1'b1;
          wait (vif.data_ready == 1'b1);
          @(posedge vif.clk);
          vif.data_valid <= 1'b0;
        end
        AMBA_CHI_CH_SNOOP: begin
          vif.snoop_txn_id <= item.txn_id;
          vif.snoop_type <= item.snoop_type;
          vif.snoop_attr <= item.snoop_attr;
          vif.snoop_fwd_nid <= item.fwd_nid;
          vif.snoop_trace_tag <= item.trace_tag;
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