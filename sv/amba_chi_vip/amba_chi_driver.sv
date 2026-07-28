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
      vif.req_flit <= '0;
      vif.resp_ready <= 1'b1;
      vif.data_ready <= 1'b1;
      vif.snoop_ready <= 1'b1;
    end else begin
      vif.req_ready <= 1'b1;
      vif.resp_valid <= 1'b0;
      vif.resp_flit <= '0;
      vif.data_valid <= 1'b0;
      vif.data_flit <= '0;
      vif.snoop_valid <= 1'b0;
      vif.snoop_flit <= '0;
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
          vif.req_flit.opcode <= item.opcode;
          vif.req_flit.txn_id <= item.txn_id;
          vif.req_flit.addr <= item.address;
          vif.req_flit.data <= item.data_words.size() > 0 ? item.data_words[0] : '0;
          vif.req_flit.src_id <= item.src_id;
          vif.req_flit.tgt_id <= item.tgt_id;
          vif.req_flit.qos <= item.qos;
          vif.req_flit.txn_type <= item.txn_type;
          vif.req_flit.order <= item.order;
          vif.req_flit.size <= item.size;
          vif.req_flit.mem_attr <= item.mem_attr;
          vif.req_flit.endian <= item.endian;
          vif.req_flit.allow_retry <= item.allow_retry;
          vif.req_flit.exp_comp_dbid <= item.exp_comp_dbid;
          vif.req_flit.trace_tag <= item.trace_tag;
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
          vif.resp_flit.txn_id <= item.txn_id;
          vif.resp_flit.opcode <= item.resp_opcode;
          vif.resp_flit.status <= item.resp_status;
          vif.resp_flit.err <= item.resp_err;
          vif.resp_flit.dbid <= item.dbid;
          vif.resp_flit.ccid <= item.ccid;
          vif.resp_flit.trace_tag <= item.trace_tag;
          vif.resp_valid <= 1'b1;
          wait (vif.resp_ready == 1'b1);
          @(posedge vif.clk);
          vif.resp_valid <= 1'b0;
        end
        AMBA_CHI_CH_DATA: begin
          vif.data_flit.txn_id <= item.txn_id;
          vif.data_flit.payload <= item.data_words.size() > 0 ? item.data_words[0] : '0;
          vif.data_flit.id <= item.data_id;
          vif.data_flit.last <= item.data_last;
          vif.data_flit.poison <= item.data_poison;
          vif.data_flit.be <= item.data_be;
          vif.data_flit.dbid <= item.dbid;
          vif.data_flit.ccid <= item.ccid;
          vif.data_flit.trace_tag <= item.trace_tag;
          vif.data_valid <= 1'b1;
          wait (vif.data_ready == 1'b1);
          @(posedge vif.clk);
          vif.data_valid <= 1'b0;
        end
        AMBA_CHI_CH_SNOOP: begin
          vif.snoop_flit.txn_id <= item.txn_id;
          vif.snoop_flit.type_ <= item.snoop_type;
          vif.snoop_flit.attr <= item.snoop_attr;
          vif.snoop_flit.fwd_nid <= item.fwd_nid;
          vif.snoop_flit.trace_tag <= item.trace_tag;
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