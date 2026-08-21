`uvm_analysis_imp_decl(_cov_master)
`uvm_analysis_imp_decl(_cov_slave)

class amba_chi_env_cov extends uvm_component;
  `uvm_component_utils(amba_chi_env_cov)

  uvm_analysis_imp_cov_master#(amba_chi_item, amba_chi_env_cov) master_imp;
  uvm_analysis_imp_cov_slave#(amba_chi_item, amba_chi_env_cov) slave_imp;
  amba_chi_env_cfg cfg;
  virtual amba_chi_if vif;
  bit [7:0] req_opcode_by_txn[bit [15:0]];
  bit [7:0] snoop_type_by_txn[bit [15:0]];

  localparam bit [7:0] NO_SNOOP_VALUE = 8'hFF;

  function automatic bit [2:0] req_class(bit [7:0] opcode);
    if (amba_chi_is_read_req_opcode(opcode)) begin
      return 3'd0;
    end
    if (amba_chi_is_write_req_opcode(opcode)) begin
      return 3'd1;
    end
    if (amba_chi_is_atomic_req_opcode(opcode)) begin
      return 3'd2;
    end
    if (opcode == AMBA_CHI_REQ_DVM_OP || opcode == AMBA_CHI_REQ_PREFETCH_TGT) begin
      return 3'd3;
    end
    if (opcode == AMBA_CHI_REQ_STASH_ONCE_SHARED) begin
      return 3'd4;
    end
    return 3'd5;
  endfunction

  function automatic bit [1:0] resp_class(bit [7:0] status);
    if (status == AMBA_CHI_RESP_RETRY || status == AMBA_CHI_RESP_FAIL) begin
      return 2'd1;
    end
    if (status == AMBA_CHI_RESP_COMPDB) begin
      return 2'd2;
    end
    return 2'd0;
  endfunction

  covergroup master_req_cg with function sample(amba_chi_item item);
    option.per_instance = 1;

    cp_version: coverpoint item.version {
      bins any = {[AMBA_CHI_VERSION_A:AMBA_CHI_VERSION_F]};
    }

    cp_req_class: coverpoint req_class(item.opcode) {
      bins reads = {3'd0};
      bins writes = {3'd1};
      bins atomic = {3'd2};
      bins dvm_prefetch = {3'd3};
      bins stash = {3'd4};
      bins maintenance = {3'd5};
    }

    cp_allow_retry: coverpoint item.allow_retry {
      bins disabled = {1'b0};
      bins enabled = {1'b1};
    }

    cp_exp_comp_dbid: coverpoint item.exp_comp_dbid {
      bins disabled = {1'b0};
      bins enabled = {1'b1};
    }

    cp_order: coverpoint item.order {
      bins relaxed = {[0:3]};
      bins strict = {[4:7]};
    }

    cp_req_has_payload: coverpoint amba_chi_req_has_payload(item.opcode) {
      bins no_payload = {1'b0};
      bins payload = {1'b1};
    }

    req_attr_cross: cross cp_allow_retry, cp_exp_comp_dbid;
  endgroup

  covergroup slave_resp_cg with function sample(amba_chi_item item);
    option.per_instance = 1;

    cp_version: coverpoint item.version {
      bins any = {[AMBA_CHI_VERSION_A:AMBA_CHI_VERSION_F]};
    }

    cp_status: coverpoint item.resp_status {
      bins comp = {AMBA_CHI_RESP_COMP};
      bins compdb = {AMBA_CHI_RESP_COMPDB};
      bins retry = {AMBA_CHI_RESP_RETRY};
      bins fail = {AMBA_CHI_RESP_FAIL};
      bins pcrd_grant = {AMBA_CHI_RESP_PCRD_GRANT};
    }

    cp_resp_err: coverpoint item.resp_err {
      bins no_error = {3'd0};
      bins has_error = {[1:7]};
    }

    cp_dbid_present: coverpoint (item.dbid != 6'h00) {
      bins absent = {1'b0};
      bins present = {1'b1};
    }

  endgroup

  covergroup slave_data_cg with function sample(amba_chi_item item);
    option.per_instance = 1;

    cp_data_id: coverpoint item.data_id {
      bins first = {4'd0};
      bins follow = {[1:15]};
    }

    cp_data_last: coverpoint item.data_last {
      bins middle = {1'b0};
      bins last = {1'b1};
    }

    cp_data_poison: coverpoint item.data_poison {
      bins clear = {1'b0};
      bins poison = {1'b1};
    }

    cp_mismatched_mecid: coverpoint item.mismatched_mecid {
      bins match = {1'b0};
      bins mismatch = {1'b1};
    }

    cp_data_be: coverpoint (item.data_be == 16'hFFFF) {
      bins partial = {1'b0};
      bins full = {1'b1};
    }

    cp_pas: coverpoint item.pas {
      bins secure = {2'b00};
      bins non_secure = {[1:3]};
    }

    mecid_poison_cross: cross cp_mismatched_mecid, cp_data_poison {
      ignore_bins mismatch_without_poison =
        binsof(cp_mismatched_mecid.mismatch) && binsof(cp_data_poison.clear);
    }
  endgroup

  covergroup slave_snoop_cg with function sample(amba_chi_item item);
    option.per_instance = 1;

    cp_snoop_class: coverpoint item.snoop_type {
      bins read = {
        AMBA_CHI_SNOOP_READ_ONCE,
        AMBA_CHI_SNOOP_READ_SHARED,
        AMBA_CHI_SNOOP_READ_CLEAN,
        AMBA_CHI_SNOOP_READ_NOT_SHARED_DIRTY,
        AMBA_CHI_SNOOP_READ_UNIQUE
      };
      bins clean_inval = {
        AMBA_CHI_SNOOP_MAKE_INVALID,
        AMBA_CHI_SNOOP_CLEAN_SHARED,
        AMBA_CHI_SNOOP_CLEAN_INVALID
      };
      bins dvm = {AMBA_CHI_SNOOP_DVM};
      bins stash = {AMBA_CHI_SNOOP_STASH_ONCE_SHARED};
    }

    cp_snoop_attr: coverpoint (item.snoop_attr != 3'd0) {
      bins zero = {1'b0};
      bins nonzero = {1'b1};
    }

    cp_fwd_nid_present: coverpoint (item.fwd_nid != 11'h000) {
      bins zero = {1'b0};
      bins nonzero = {1'b1};
    }

  endgroup

  covergroup req_resp_correlation_cg with function sample(bit [7:0] req_opcode,
                                                          bit [7:0] resp_status,
                                                          bit [7:0] snoop_type);
    option.per_instance = 1;

    cp_req_class: coverpoint req_class(req_opcode) {
      bins reads = {3'd0};
      bins writes = {3'd1};
      bins atomic = {3'd2};
      bins dvm_prefetch = {3'd3};
      bins stash = {3'd4};
      bins maintenance = {3'd5};
    }

    cp_resp_class: coverpoint resp_class(resp_status) {
      bins completion = {2'd0};
      bins error_or_retry = {2'd1};
      bins completion_dbid = {2'd2};
    }

    cp_has_snoop: coverpoint (snoop_type != NO_SNOOP_VALUE) {
      bins no = {1'b0};
      bins yes = {1'b1};
    }

  endgroup

  covergroup link_state_cg with function sample(bit tx_req,
                                                bit tx_ack,
                                                bit rx_req,
                                                bit rx_ack,
                                                bit tx_sactive,
                                                bit rx_sactive);
    option.per_instance = 1;

    cp_tx_link_active: coverpoint (tx_req && tx_ack) {
      bins inactive = {1'b0};
      bins active = {1'b1};
    }

    cp_rx_link_active: coverpoint (rx_req && rx_ack) {
      bins inactive = {1'b0};
      bins active = {1'b1};
    }

    cp_sactive_pair: coverpoint {tx_sactive, rx_sactive} {
      bins idle = {2'b00};
      bins active = {2'b11};
    }

    sactive_link_cross: cross cp_sactive_pair, cp_tx_link_active, cp_rx_link_active;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    master_imp = new("master_imp", this);
    slave_imp = new("slave_imp", this);
    master_req_cg = new();
    slave_resp_cg = new();
    slave_data_cg = new();
    slave_snoop_cg = new();
    req_resp_correlation_cg = new();
    link_state_cg = new();
  endfunction

  task run_phase(uvm_phase phase);
    if (vif != null) begin
      forever begin
        @(posedge vif.clk);
        if (vif.rst_n == 1'b1) begin
          link_state_cg.sample(vif.TXLINKACTIVEREQ,
                               vif.TXLINKACTIVEACK,
                               vif.RXLINKACTIVEREQ,
                               vif.RXLINKACTIVEACK,
                               vif.TXSACTIVE,
                               vif.RXSACTIVE);
        end
      end
    end
  endtask

  function void write_cov_master(amba_chi_item item);
    if (item.channel == AMBA_CHI_CH_REQ) begin
      master_req_cg.sample(item);
      req_opcode_by_txn[item.txn_id] = item.opcode;
      snoop_type_by_txn[item.txn_id] = NO_SNOOP_VALUE;
    end
  endfunction

  function void write_cov_slave(amba_chi_item item);
    bit [7:0] req_opcode;
    bit [7:0] snoop_type;

    if (item.channel == AMBA_CHI_CH_RESP) begin
      slave_resp_cg.sample(item);
      if (req_opcode_by_txn.exists(item.txn_id)) begin
        req_opcode = req_opcode_by_txn[item.txn_id];
        snoop_type = snoop_type_by_txn.exists(item.txn_id) ?
                     snoop_type_by_txn[item.txn_id] : NO_SNOOP_VALUE;
        req_resp_correlation_cg.sample(req_opcode, item.resp_status, snoop_type);
        req_opcode_by_txn.delete(item.txn_id);
        snoop_type_by_txn.delete(item.txn_id);
      end
    end else if (item.channel == AMBA_CHI_CH_DATA) begin
      slave_data_cg.sample(item);
    end else if (item.channel == AMBA_CHI_CH_SNOOP) begin
      slave_snoop_cg.sample(item);
      if (snoop_type_by_txn.exists(item.txn_id)) begin
        snoop_type_by_txn[item.txn_id] = item.snoop_type;
      end
    end
  endfunction

  function real transaction_cov_pct();
    return (master_req_cg.get_inst_coverage() +
            slave_resp_cg.get_inst_coverage() +
            slave_data_cg.get_inst_coverage() +
            slave_snoop_cg.get_inst_coverage() +
            req_resp_correlation_cg.get_inst_coverage()) / 5.0;
  endfunction

  function void report_phase(uvm_phase phase);
    real req_cov;
    real rsp_cov;
    real dat_cov;
    real snp_cov;
    real corr_cov;
    real link_cov;
    real txn_cov;

    req_cov = master_req_cg.get_inst_coverage();
    rsp_cov = slave_resp_cg.get_inst_coverage();
    dat_cov = slave_data_cg.get_inst_coverage();
    snp_cov = slave_snoop_cg.get_inst_coverage();
    corr_cov = req_resp_correlation_cg.get_inst_coverage();
    link_cov = link_state_cg.get_inst_coverage();
    txn_cov = transaction_cov_pct();

    `uvm_info(get_type_name(),
              $sformatf("FCOV req=%.2f resp=%.2f data=%.2f snoop=%.2f corr=%.2f link=%.2f txn_avg=%.2f",
                        req_cov, rsp_cov, dat_cov, snp_cov, corr_cov, link_cov, txn_cov),
              UVM_LOW)

    if (cfg != null && cfg.require_full_cov &&
        ((txn_cov < 99.99) || (link_cov < 99.99))) begin
      `uvm_error(get_type_name(),
                 $sformatf("functional coverage closure failed: txn_avg=%.2f link=%.2f",
                           txn_cov, link_cov))
    end
  endfunction
endclass
