class amba_chi_monitor extends uvm_component;
  `uvm_component_utils(amba_chi_monitor)

  amba_chi_cfg cfg;
  virtual amba_chi_if.monitor vif;
  uvm_analysis_port#(amba_chi_item) analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  task run_phase(uvm_phase phase);
    amba_chi_item item;

    if (vif == null) begin
      `uvm_fatal(get_type_name(), "amba_chi_monitor requires a virtual interface")
    end
    if (cfg == null) begin
      `uvm_fatal(get_type_name(), "amba_chi_monitor requires cfg")
    end

    forever begin
      @(posedge vif.clk);
      if (cfg.role == AMBA_CHI_ROLE_MASTER && vif.req_valid && vif.req_ready) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_REQ;
        item.role = AMBA_CHI_ROLE_MASTER;
        item.version = cfg.version;
        item.txn_id = vif.req_txn_id;
        item.address = vif.req_addr;
        item.opcode = vif.req_opcode;
        item.src_id = vif.req_src_id;
        item.tgt_id = vif.req_tgt_id;
        item.qos = vif.req_qos;
        item.txn_type = vif.req_txn_type;
        item.order = vif.req_order;
        item.size = vif.req_size;
        item.mem_attr = vif.req_mem_attr;
        item.endian = vif.req_endian;
        item.allow_retry = vif.req_allow_retry;
        item.exp_comp_dbid = vif.req_exp_comp_dbid;
        item.trace_tag = vif.req_trace_tag;
        if (amba_chi_req_has_payload(vif.req_opcode)) begin
          item.data_words.push_back(vif.req_data[31:0]);
        end
        analysis_port.write(item);
      end else if (cfg.role == AMBA_CHI_ROLE_SLAVE && vif.resp_valid && vif.resp_ready) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_RESP;
        item.role = AMBA_CHI_ROLE_SLAVE;
        item.version = cfg.version;
        item.txn_id = vif.resp_txn_id;
        item.resp_opcode = vif.resp_opcode;
        item.resp_status = vif.resp_status;
        item.resp_err = vif.resp_err;
        item.dbid = vif.resp_dbid;
        item.ccid = vif.resp_ccid;
        item.trace_tag = vif.resp_trace_tag;
        analysis_port.write(item);
      end else if (cfg.role == AMBA_CHI_ROLE_SLAVE && vif.data_valid && vif.data_ready) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_DATA;
        item.role = AMBA_CHI_ROLE_SLAVE;
        item.version = cfg.version;
        item.txn_id = vif.data_txn_id;
        item.data_words.push_back(vif.data_payload[31:0]);
        item.data_id = vif.data_id;
        item.data_last = vif.data_last;
        item.data_poison = vif.data_poison;
        item.data_be = vif.data_be;
        item.dbid = vif.data_dbid;
        item.ccid = vif.data_ccid;
        item.trace_tag = vif.data_trace_tag;
        analysis_port.write(item);
      end else if (cfg.role == AMBA_CHI_ROLE_SLAVE && vif.snoop_valid && vif.snoop_ready) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_SNOOP;
        item.role = AMBA_CHI_ROLE_SLAVE;
        item.version = cfg.version;
        item.txn_id = vif.snoop_txn_id;
        item.snoop_type = vif.snoop_type;
        item.snoop_attr = vif.snoop_attr;
        item.fwd_nid = vif.snoop_fwd_nid;
        item.trace_tag = vif.snoop_trace_tag;
        analysis_port.write(item);
      end
    end
  endtask
endclass