class amba_chi_driver extends uvm_driver#(amba_chi_item);
  `uvm_component_utils(amba_chi_driver)

  amba_chi_cfg cfg;
  virtual amba_chi_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  protected function int unsigned get_channel_delay_cycles(amba_chi_channel_e channel);
    case (channel)
      AMBA_CHI_CH_REQ: return cfg.req_channel_delay_cycles;
      AMBA_CHI_CH_RESP: return cfg.rsp_channel_delay_cycles;
      AMBA_CHI_CH_DATA: return cfg.dat_channel_delay_cycles;
      AMBA_CHI_CH_SNOOP: return cfg.snp_channel_delay_cycles;
      default: return 0;
    endcase
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
      vif.REQFLITPEND <= 1'b0;
      vif.REQFLITV <= 1'b0;
      vif.REQFLIT <= '0;
      vif.RSPLCRDV <= 1'b1;
      vif.DATLCRDV <= 1'b1;
      vif.SNPLCRDV <= 1'b1;
    end else begin
      vif.REQLCRDV <= 1'b1;
      vif.RSPFLITPEND <= 1'b0;
      vif.RSPFLITV <= 1'b0;
      vif.RSPFLIT <= '0;
      vif.DATFLITPEND <= 1'b0;
      vif.DATFLITV <= 1'b0;
      vif.DATFLIT <= '0;
      vif.SNPFLITPEND <= 1'b0;
      vif.SNPFLITV <= 1'b0;
      vif.SNPFLIT <= '0;
    end

    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask

  protected virtual task drive_item(amba_chi_item item);
    int unsigned delay_cycles;

    @(posedge vif.clk);
    delay_cycles = get_channel_delay_cycles(item.channel);
    repeat (delay_cycles) begin
      @(posedge vif.clk);
    end

    if (cfg.role == AMBA_CHI_ROLE_MASTER) begin
      case (item.channel)
        AMBA_CHI_CH_REQ: begin
          vif.REQFLIT.opcode <= item.opcode;
          vif.REQFLIT.txn_id <= item.txn_id;
          vif.REQFLIT.addr <= item.address;
          vif.REQFLIT.data <= item.data_words.size() > 0 ? item.data_words[0] : '0;
          vif.REQFLIT.src_id <= item.src_id;
          vif.REQFLIT.tgt_id <= item.tgt_id;
          vif.REQFLIT.qos <= item.qos;
          vif.REQFLIT.txn_type <= item.txn_type;
          vif.REQFLIT.order <= item.order;
          vif.REQFLIT.size <= item.size;
          vif.REQFLIT.mem_attr <= item.mem_attr;
          vif.REQFLIT.endian <= item.endian;
          vif.REQFLIT.allow_retry <= item.allow_retry;
          vif.REQFLIT.exp_comp_dbid <= item.exp_comp_dbid;
          vif.REQFLIT.pas <= item.pas;
          vif.REQFLIT.mecid <= item.mecid;
          vif.REQFLIT.trace_tag <= item.trace_tag;
          vif.REQFLITPEND <= 1'b1;
          vif.REQFLITV <= 1'b1;
          wait (vif.REQLCRDV == 1'b1);
          @(posedge vif.clk);
          vif.REQFLITPEND <= 1'b0;
          vif.REQFLITV <= 1'b0;
        end
        default: begin
          `uvm_error(get_type_name(), $sformatf("master driver got unexpected channel %0d", item.channel))
        end
      endcase
    end else begin
      case (item.channel)
        AMBA_CHI_CH_RESP: begin
          vif.RSPFLIT.txn_id <= item.txn_id;
          vif.RSPFLIT.opcode <= item.resp_opcode;
          vif.RSPFLIT.status <= item.resp_status;
          vif.RSPFLIT.err <= item.resp_err;
          vif.RSPFLIT.dbid <= item.dbid;
          vif.RSPFLIT.ccid <= item.ccid;
          vif.RSPFLIT.trace_tag <= item.trace_tag;
          vif.RSPFLITPEND <= 1'b1;
          vif.RSPFLITV <= 1'b1;
          wait (vif.RSPLCRDV == 1'b1);
          @(posedge vif.clk);
          vif.RSPFLITPEND <= 1'b0;
          vif.RSPFLITV <= 1'b0;
        end
        AMBA_CHI_CH_DATA: begin
          vif.DATFLIT.txn_id <= item.txn_id;
          vif.DATFLIT.payload <= item.data_words.size() > 0 ? item.data_words[0] : '0;
          vif.DATFLIT.id <= item.data_id;
          vif.DATFLIT.last <= item.data_last;
          vif.DATFLIT.poison <= item.data_poison;
          vif.DATFLIT.be <= item.data_be;
          vif.DATFLIT.dbid <= item.dbid;
          vif.DATFLIT.ccid <= item.ccid;
          vif.DATFLIT.pas <= item.pas;
          vif.DATFLIT.mecid <= item.mecid;
          vif.DATFLIT.mismatched_mecid <= item.mismatched_mecid;
          vif.DATFLIT.trace_tag <= item.trace_tag;
          vif.DATFLITPEND <= 1'b1;
          vif.DATFLITV <= 1'b1;
          wait (vif.DATLCRDV == 1'b1);
          @(posedge vif.clk);
          vif.DATFLITPEND <= 1'b0;
          vif.DATFLITV <= 1'b0;
        end
        AMBA_CHI_CH_SNOOP: begin
          vif.SNPFLIT.txn_id <= item.txn_id;
          vif.SNPFLIT.type_ <= item.snoop_type;
          vif.SNPFLIT.attr <= item.snoop_attr;
          vif.SNPFLIT.fwd_nid <= item.fwd_nid;
          vif.SNPFLIT.trace_tag <= item.trace_tag;
          vif.SNPFLITPEND <= 1'b1;
          vif.SNPFLITV <= 1'b1;
          wait (vif.SNPLCRDV == 1'b1);
          @(posedge vif.clk);
          vif.SNPFLITPEND <= 1'b0;
          vif.SNPFLITV <= 1'b0;
        end
        default: begin
          `uvm_error(get_type_name(), $sformatf("slave driver got unexpected channel %0d", item.channel))
        end
      endcase
    end
  endtask
endclass