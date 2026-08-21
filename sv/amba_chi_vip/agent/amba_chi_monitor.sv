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
        if (cfg.role == AMBA_CHI_ROLE_MASTER &&
          vif.REQFLITPEND && vif.REQFLITV && vif.REQLCRDV) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_REQ;
        item.role = AMBA_CHI_ROLE_MASTER;
        item.version = cfg.version;
        item.txn_id = vif.REQFLIT.txn_id;
        item.address = vif.REQFLIT.addr;
        item.opcode = vif.REQFLIT.opcode;
        item.src_id = vif.REQFLIT.src_id;
        item.tgt_id = vif.REQFLIT.tgt_id;
        item.qos = vif.REQFLIT.qos;
        item.txn_type = vif.REQFLIT.txn_type;
        item.order = vif.REQFLIT.order;
        item.size = vif.REQFLIT.size;
        item.mem_attr = vif.REQFLIT.mem_attr;
        item.endian = vif.REQFLIT.endian;
        item.allow_retry = vif.REQFLIT.allow_retry;
        item.exp_comp_dbid = vif.REQFLIT.exp_comp_dbid;
        item.pas = vif.REQFLIT.pas;
        item.mecid = vif.REQFLIT.mecid;
        item.trace_tag = vif.REQFLIT.trace_tag;
        if (amba_chi_req_has_payload(vif.REQFLIT.opcode)) begin
          item.data_words.push_back(vif.REQFLIT.data[31:0]);
        end
        analysis_port.write(item);
      end else if (cfg.role == AMBA_CHI_ROLE_SLAVE &&
           vif.RSPFLITPEND && vif.RSPFLITV && vif.RSPLCRDV) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_RESP;
        item.role = AMBA_CHI_ROLE_SLAVE;
        item.version = cfg.version;
        item.txn_id = vif.RSPFLIT.txn_id;
        item.resp_opcode = vif.RSPFLIT.opcode;
        item.resp_status = vif.RSPFLIT.status;
        item.resp_err = vif.RSPFLIT.err;
        item.dbid = vif.RSPFLIT.dbid;
        item.ccid = vif.RSPFLIT.ccid;
        item.trace_tag = vif.RSPFLIT.trace_tag;
        analysis_port.write(item);
      end else if (cfg.role == AMBA_CHI_ROLE_SLAVE &&
           vif.DATFLITPEND && vif.DATFLITV && vif.DATLCRDV) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_DATA;
        item.role = AMBA_CHI_ROLE_SLAVE;
        item.version = cfg.version;
        item.txn_id = vif.DATFLIT.txn_id;
        item.data_words.push_back(vif.DATFLIT.payload[31:0]);
        item.data_id = vif.DATFLIT.id;
        item.data_last = vif.DATFLIT.last;
        item.data_poison = vif.DATFLIT.poison;
        item.data_be = vif.DATFLIT.be;
        item.dbid = vif.DATFLIT.dbid;
        item.ccid = vif.DATFLIT.ccid;
        item.pas = vif.DATFLIT.pas;
        item.mecid = vif.DATFLIT.mecid;
        item.mismatched_mecid = vif.DATFLIT.mismatched_mecid;
        item.trace_tag = vif.DATFLIT.trace_tag;
        analysis_port.write(item);
      end else if (cfg.role == AMBA_CHI_ROLE_SLAVE &&
           vif.SNPFLITPEND && vif.SNPFLITV && vif.SNPLCRDV) begin
        item = amba_chi_item::type_id::create("item");
        item.channel = AMBA_CHI_CH_SNOOP;
        item.role = AMBA_CHI_ROLE_SLAVE;
        item.version = cfg.version;
        item.txn_id = vif.SNPFLIT.txn_id;
        item.snoop_type = vif.SNPFLIT.type_;
        item.snoop_attr = vif.SNPFLIT.attr;
        item.fwd_nid = vif.SNPFLIT.fwd_nid;
        item.trace_tag = vif.SNPFLIT.trace_tag;
        analysis_port.write(item);
      end
    end
  endtask
endclass