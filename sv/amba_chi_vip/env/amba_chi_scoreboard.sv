`uvm_analysis_imp_decl(_master)
`uvm_analysis_imp_decl(_slave)

class amba_chi_scoreboard extends uvm_component;
  `uvm_component_utils(amba_chi_scoreboard)

  amba_chi_env_cfg cfg;
  uvm_analysis_imp_master#(amba_chi_item, amba_chi_scoreboard) master_imp;
  uvm_analysis_imp_slave#(amba_chi_item, amba_chi_scoreboard) slave_imp;

  amba_chi_item pending_reqs[bit [15:0]];
  amba_chi_item completed_reqs[bit [15:0]];
  bit [15:0] req_order_q[$];
  longint unsigned req_issue_cycle[bit [15:0]];
  bit exp_data[bit [15:0]];
  bit exp_snoop[bit [15:0]];
  bit resp_seen[bit [15:0]];
  bit [7:0] resp_status_seen[bit [15:0]];
  bit [5:0] resp_dbid_seen[bit [15:0]];
  bit data_seen[bit [15:0]];
  bit data_complete[bit [15:0]];
  bit data_last_seen[bit [15:0]];
  bit [3:0] next_data_id[bit [15:0]];
  bit [15:0] first_data_be[bit [15:0]];
  bit [5:0] data_dbid_ref[bit [15:0]];
  bit [3:0] data_ccid_ref[bit [15:0]];
  bit data_ref_valid[bit [15:0]];
  bit snoop_seen[bit [15:0]];
  amba_chi_item retry_req_snapshot[bit [15:0]];
  bit retry_ack_seen[bit [15:0]];
  bit pcrd_grant_seen[bit [15:0]];
  bit retry_window_open[bit [15:0]];
  bit retry_window_used[bit [15:0]];
  int unsigned data_beats_seen[bit [15:0]];
  int unsigned req_count;
  int unsigned resp_count;
  int unsigned data_count;
  int unsigned snoop_count;
  int unsigned max_outstanding_seen;
  longint unsigned cycle_count;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    master_imp = new("master_imp", this);
    slave_imp = new("slave_imp", this);
  endfunction

  task run_phase(uvm_phase phase);
    virtual amba_chi_if vif;

    if (cfg == null || cfg.master_cfg == null) begin
      return;
    end
    vif = cfg.master_cfg.vif;
    if (vif == null) begin
      return;
    end

    wait (vif.rst_n == 1'b1);
    forever begin
      @(posedge vif.clk);
      cycle_count++;
      check_pending_latency();
    end
  endtask

  protected function void check_pending_latency();
    if (cfg == null || cfg.master_cfg == null || !cfg.master_cfg.en_strict_timing) begin
      return;
    end

    foreach (req_issue_cycle[txn_id]) begin
      longint unsigned age;
      age = cycle_count - req_issue_cycle[txn_id];

      if (!resp_seen.exists(txn_id) && age > cfg.master_cfg.max_resp_latency_cycles) begin
        `uvm_error(get_type_name(),
                   $sformatf("response latency timeout txn_id=0x%0h age=%0d limit=%0d",
                             txn_id, age, cfg.master_cfg.max_resp_latency_cycles))
      end
      if (exp_data.exists(txn_id) && exp_data[txn_id] &&
          (!data_seen.exists(txn_id) || !data_seen[txn_id]) &&
          age > cfg.master_cfg.max_data_latency_cycles) begin
        `uvm_error(get_type_name(),
                   $sformatf("data latency timeout txn_id=0x%0h age=%0d limit=%0d",
                             txn_id, age, cfg.master_cfg.max_data_latency_cycles))
      end
      if (exp_snoop.exists(txn_id) && exp_snoop[txn_id] &&
          (!snoop_seen.exists(txn_id) || !snoop_seen[txn_id]) &&
          age > cfg.master_cfg.max_snoop_latency_cycles) begin
        `uvm_error(get_type_name(),
                   $sformatf("snoop latency timeout txn_id=0x%0h age=%0d limit=%0d",
                             txn_id, age, cfg.master_cfg.max_snoop_latency_cycles))
      end
    end
  endfunction

  protected function bit resp_terminates_without_data(bit [7:0] resp_status);
    return (resp_status == AMBA_CHI_RESP_RETRY) ||
           (resp_status == AMBA_CHI_RESP_FAIL) ||
           (resp_status == AMBA_CHI_RESP_PCRD_GRANT);
  endfunction

  protected function bit is_retry_response(bit [7:0] resp_status);
    return (resp_status == AMBA_CHI_RESP_RETRY) ||
           (resp_status == AMBA_CHI_RESP_PCRD_GRANT);
  endfunction

  protected function void finalize_txn_if_done(bit [15:0] txn_id);
    bit needs_data;
    bit needs_snoop;
    bit got_resp;
    bit got_data;
    bit got_snoop;

    needs_data = exp_data.exists(txn_id) ? exp_data[txn_id] : 1'b0;
    needs_snoop = exp_snoop.exists(txn_id) ? exp_snoop[txn_id] : 1'b0;
    got_resp = resp_seen.exists(txn_id) ? resp_seen[txn_id] : 1'b0;
    got_data = data_complete.exists(txn_id) ? data_complete[txn_id] : 1'b0;
    got_snoop = snoop_seen.exists(txn_id) ? snoop_seen[txn_id] : 1'b0;

    if (got_resp && (!needs_data || got_data) && (!needs_snoop || got_snoop)) begin
      completed_reqs.delete(txn_id);
      req_issue_cycle.delete(txn_id);
      exp_data.delete(txn_id);
      exp_snoop.delete(txn_id);
      resp_status_seen.delete(txn_id);
      resp_dbid_seen.delete(txn_id);
      data_beats_seen.delete(txn_id);
      data_complete.delete(txn_id);
      data_last_seen.delete(txn_id);
      next_data_id.delete(txn_id);
      first_data_be.delete(txn_id);
      data_dbid_ref.delete(txn_id);
      data_ccid_ref.delete(txn_id);
      data_ref_valid.delete(txn_id);
    end
  endfunction

  function void write_master(amba_chi_item item);
    bit need_resp;
    bit need_data;
    bit need_snoop;
    bit has_req_payload;

    if (item.channel != AMBA_CHI_CH_REQ) begin
      `uvm_error(get_type_name(),
                 $sformatf("master monitor sent unexpected channel %0d for txn_id=0x%0h",
                           item.channel, item.txn_id))
      return;
    end

    if (!amba_chi_is_valid_req_opcode(item.opcode)) begin
      `uvm_error(get_type_name(),
                 $sformatf("request txn_id=0x%0h has unsupported opcode 0x%0h",
                           item.txn_id, item.opcode))
    end
    if (!amba_chi_supports_req_opcode(item.version, item.opcode)) begin
      `uvm_error(get_type_name(),
                 $sformatf("request txn_id=0x%0h opcode 0x%0h not supported in version %0d",
                           item.txn_id, item.opcode, item.version))
    end

    amba_chi_get_req_expectation(item.opcode, need_resp, need_data, need_snoop, has_req_payload);

    if (retry_ack_seen.exists(item.txn_id) || pcrd_grant_seen.exists(item.txn_id)) begin
      bit ack_seen;
      bit grant_seen;

      ack_seen = retry_ack_seen.exists(item.txn_id) ? retry_ack_seen[item.txn_id] : 1'b0;
      grant_seen = pcrd_grant_seen.exists(item.txn_id) ? pcrd_grant_seen[item.txn_id] : 1'b0;

      if (!(ack_seen && grant_seen)) begin
        `uvm_error(get_type_name(),
                   $sformatf("retry resend window closed for txn_id=0x%0h: RetryAck=%0d PCrdGrant=%0d",
                             item.txn_id, ack_seen, grant_seen))
      end
      if (!item.allow_retry) begin
        `uvm_error(get_type_name(),
                   $sformatf("retry resend txn_id=0x%0h must set AllowRetry=1", item.txn_id))
      end
      retry_window_open[item.txn_id] = ack_seen && grant_seen;
      retry_window_used[item.txn_id] = 1'b1;
      retry_ack_seen.delete(item.txn_id);
      pcrd_grant_seen.delete(item.txn_id);
      retry_window_open.delete(item.txn_id);
      retry_window_used.delete(item.txn_id);
      retry_req_snapshot.delete(item.txn_id);
    end

    req_count++;
    if (pending_reqs.exists(item.txn_id)) begin
      `uvm_error(get_type_name(),
                 $sformatf("duplicate request txn_id=0x%0h detected", item.txn_id))
      return;
    end
    pending_reqs[item.txn_id] = item;
    req_order_q.push_back(item.txn_id);
    req_issue_cycle[item.txn_id] = cycle_count;
    exp_data[item.txn_id] = need_data;
    exp_snoop[item.txn_id] = need_snoop;
    resp_status_seen[item.txn_id] = 8'h00;
    resp_dbid_seen[item.txn_id] = 6'h00;
    data_beats_seen[item.txn_id] = 0;
    data_complete[item.txn_id] = 1'b0;
    data_last_seen[item.txn_id] = 1'b0;
    next_data_id[item.txn_id] = 4'd0;
    first_data_be[item.txn_id] = 16'h0000;
    data_dbid_ref[item.txn_id] = 6'h00;
    data_ccid_ref[item.txn_id] = 4'h0;
    data_ref_valid[item.txn_id] = 1'b0;

    if (pending_reqs.num() > max_outstanding_seen) begin
      max_outstanding_seen = pending_reqs.num();
    end

    if (cfg != null && pending_reqs.num() > cfg.master_cfg.max_outstanding) begin
      `uvm_error(get_type_name(),
                 $sformatf("outstanding request limit exceeded: %0d > %0d",
                           pending_reqs.num(), cfg.master_cfg.max_outstanding))
    end

    if (cfg != null && cfg.master_cfg.en_strict_semantics) begin
      if (item.size > 3'd6) begin
        `uvm_error(get_type_name(),
                   $sformatf("request txn_id=0x%0h has illegal size=%0d", item.txn_id, item.size))
      end
      if (item.src_id == item.tgt_id) begin
        `uvm_warning(get_type_name(),
                     $sformatf("request txn_id=0x%0h has identical src/tgt id=%0d",
                               item.txn_id, item.src_id))
      end
      if (has_req_payload && item.data_words.size() == 0) begin
        `uvm_error(get_type_name(),
                   $sformatf("payload request txn_id=0x%0h has no request data", item.txn_id))
      end
    end
  endfunction

  function void write_slave(amba_chi_item item);
    amba_chi_item req;
    bit from_retry_snapshot;

    from_retry_snapshot = 1'b0;

    if (item.channel != AMBA_CHI_CH_RESP &&
        item.channel != AMBA_CHI_CH_DATA &&
        item.channel != AMBA_CHI_CH_SNOOP) begin
      `uvm_error(get_type_name(),
                 $sformatf("slave monitor sent unexpected channel %0d for txn_id=0x%0h",
                           item.channel, item.txn_id))
      return;
    end

    if (item.channel == AMBA_CHI_CH_RESP) begin
      if (pending_reqs.exists(item.txn_id)) begin
        req = pending_reqs[item.txn_id];
      end else if (is_retry_response(item.resp_status) && retry_req_snapshot.exists(item.txn_id)) begin
        req = retry_req_snapshot[item.txn_id];
        from_retry_snapshot = 1'b1;
      end else begin
        `uvm_error(get_type_name(),
                   $sformatf("response txn_id=0x%0h has no matching request", item.txn_id))
        return;
      end

      if (!from_retry_snapshot && cfg != null && cfg.en_in_order_resp && req_order_q.size() > 0 &&
          req_order_q[0] != item.txn_id) begin
        `uvm_error(get_type_name(),
                   $sformatf("response ordering violation: expected txn_id=0x%0h got 0x%0h",
                             req_order_q[0], item.txn_id))
      end
      if (req.version != item.version) begin
        `uvm_error(get_type_name(),
                   $sformatf("version mismatch for txn_id=0x%0h: req=%0d resp=%0d",
                             item.txn_id, req.version, item.version))
      end

      if (req.role != AMBA_CHI_ROLE_MASTER || item.role != AMBA_CHI_ROLE_SLAVE) begin
        `uvm_error(get_type_name(),
                   $sformatf("role mismatch for txn_id=0x%0h", item.txn_id))
      end

      if (!amba_chi_is_resp_status_allowed_for_req(req.opcode, item.resp_status)) begin
        `uvm_error(get_type_name(),
                   $sformatf("response txn_id=0x%0h has illegal status 0x%0h for req opcode 0x%0h",
                             item.txn_id, item.resp_status, req.opcode))
      end

      if (exp_snoop.exists(item.txn_id) && exp_snoop[item.txn_id] &&
          !resp_terminates_without_data(item.resp_status) &&
          (!snoop_seen.exists(item.txn_id) || !snoop_seen[item.txn_id])) begin
        `uvm_error(get_type_name(),
                   $sformatf("response txn_id=0x%0h arrived before required snoop", item.txn_id))
      end

      if ((item.resp_status == AMBA_CHI_RESP_RETRY ||
           item.resp_status == AMBA_CHI_RESP_PCRD_GRANT) &&
          !req.allow_retry) begin
        `uvm_error(get_type_name(),
                   $sformatf("response txn_id=0x%0h got retry/credit-grant status 0x%0h but AllowRetry=0",
                             item.txn_id, item.resp_status))
      end

      if (item.resp_status == AMBA_CHI_RESP_RETRY) begin
        if (retry_ack_seen.exists(item.txn_id) && retry_ack_seen[item.txn_id] &&
            (!retry_window_used.exists(item.txn_id) || !retry_window_used[item.txn_id])) begin
          `uvm_error(get_type_name(),
                     $sformatf("duplicate RetryAck before resend for txn_id=0x%0h", item.txn_id))
        end
        retry_ack_seen[item.txn_id] = 1'b1;
      end
      if (item.resp_status == AMBA_CHI_RESP_PCRD_GRANT) begin
        if (pcrd_grant_seen.exists(item.txn_id) && pcrd_grant_seen[item.txn_id] &&
            (!retry_window_used.exists(item.txn_id) || !retry_window_used[item.txn_id])) begin
          `uvm_error(get_type_name(),
                     $sformatf("duplicate PCrdGrant before resend for txn_id=0x%0h", item.txn_id))
        end
        pcrd_grant_seen[item.txn_id] = 1'b1;
      end
      if (retry_ack_seen.exists(item.txn_id) && pcrd_grant_seen.exists(item.txn_id) &&
          retry_ack_seen[item.txn_id] && pcrd_grant_seen[item.txn_id]) begin
        retry_window_open[item.txn_id] = 1'b1;
        retry_window_used[item.txn_id] = 1'b0;
      end

      if (!from_retry_snapshot && is_retry_response(item.resp_status) &&
          !retry_req_snapshot.exists(item.txn_id)) begin
        retry_req_snapshot[item.txn_id] = req;
      end

      if (cfg != null && cfg.master_cfg.en_strict_semantics) begin
        if (item.resp_status == AMBA_CHI_RESP_COMPDB && item.dbid == '0) begin
          `uvm_error(get_type_name(),
                     $sformatf("response txn_id=0x%0h COMPDB without DBID", item.txn_id))
        end
        if (req.exp_comp_dbid && item.resp_status != AMBA_CHI_RESP_COMPDB) begin
          `uvm_error(get_type_name(),
                     $sformatf("response txn_id=0x%0h expected COMPDB but saw status 0x%0h",
                               item.txn_id, item.resp_status))
        end
      end

      resp_count++;
      resp_seen[item.txn_id] = 1'b1;
      resp_status_seen[item.txn_id] = item.resp_status;
      resp_dbid_seen[item.txn_id] = item.dbid;

      // Retry/Fail/PCrdGrant are terminal responses that do not carry data/snoop completion.
      if (resp_terminates_without_data(item.resp_status)) begin
        exp_data[item.txn_id] = 1'b0;
        exp_snoop[item.txn_id] = 1'b0;
      end

      if (!from_retry_snapshot) begin
        completed_reqs[item.txn_id] = req;
        pending_reqs.delete(item.txn_id);
      end

      if (!from_retry_snapshot) begin
        if (req_order_q.size() > 0) begin
          if (req_order_q[0] == item.txn_id) begin
            req_order_q.pop_front();
          end else begin
            foreach (req_order_q[i]) begin
              if (req_order_q[i] == item.txn_id) begin
                req_order_q.delete(i);
                break;
              end
            end
          end
        end
        finalize_txn_if_done(item.txn_id);
      end
    end else if (item.channel == AMBA_CHI_CH_DATA) begin
      if (pending_reqs.exists(item.txn_id)) begin
        req = pending_reqs[item.txn_id];
      end else if (completed_reqs.exists(item.txn_id)) begin
        req = completed_reqs[item.txn_id];
      end else begin
        `uvm_error(get_type_name(),
                   $sformatf("data txn_id=0x%0h has no matching request", item.txn_id))
        return;
      end

      if (req.version != item.version) begin
        `uvm_error(get_type_name(),
                   $sformatf("version mismatch for data txn_id=0x%0h: req=%0d data=%0d",
                             item.txn_id, req.version, item.version))
      end

      if (resp_seen.exists(item.txn_id) && resp_seen[item.txn_id] &&
          resp_terminates_without_data(resp_status_seen[item.txn_id])) begin
        `uvm_error(get_type_name(),
                   $sformatf("data txn_id=0x%0h observed after terminal non-data response 0x%0h",
                             item.txn_id, resp_status_seen[item.txn_id]))
      end

      if (item.pas != req.pas) begin
        `uvm_error(get_type_name(),
                   $sformatf("data txn_id=0x%0h PAS mismatch: req=%0d data=%0d",
                             item.txn_id, req.pas, item.pas))
      end

      if (item.mismatched_mecid && !item.data_poison) begin
        `uvm_error(get_type_name(),
                   $sformatf("data txn_id=0x%0h MECID mismatch must assert poison", item.txn_id))
      end

      if (exp_data.exists(item.txn_id) && !exp_data[item.txn_id]) begin
        `uvm_error(get_type_name(),
                   $sformatf("data txn_id=0x%0h observed for request opcode 0x%0h that does not expect data",
                             item.txn_id, req.opcode))
      end

      if (data_last_seen.exists(item.txn_id) && data_last_seen[item.txn_id]) begin
        `uvm_error(get_type_name(),
                   $sformatf("data txn_id=0x%0h observed after last beat", item.txn_id))
      end

      data_seen[item.txn_id] = 1'b1;
      data_count++;
      data_beats_seen[item.txn_id]++;
      if (item.data_words.size() == 0) begin
        `uvm_error(get_type_name(),
                   $sformatf("data channel txn_id=0x%0h carried no payload", item.txn_id))
      end
      if (item.data_be == '0) begin
        `uvm_error(get_type_name(),
                   $sformatf("data channel txn_id=0x%0h has empty byte-enable", item.txn_id))
      end
      if (!amba_chi_is_contiguous_be(item.data_be)) begin
        `uvm_error(get_type_name(),
                   $sformatf("data channel txn_id=0x%0h has non-contiguous byte-enable 0x%0h",
                             item.txn_id, item.data_be))
      end

      if (data_beats_seen[item.txn_id] == 1) begin
        if (item.data_id != 4'd0) begin
          `uvm_error(get_type_name(),
                     $sformatf("data txn_id=0x%0h first beat id must be 0, got %0d",
                               item.txn_id, item.data_id))
        end
        first_data_be[item.txn_id] = item.data_be;
        data_dbid_ref[item.txn_id] = item.dbid;
        data_ccid_ref[item.txn_id] = item.ccid;
        data_ref_valid[item.txn_id] = 1'b1;
      end else begin
        if (item.data_id != next_data_id[item.txn_id]) begin
          `uvm_error(get_type_name(),
                     $sformatf("data txn_id=0x%0h beat id discontinuity: expected %0d got %0d",
                               item.txn_id, next_data_id[item.txn_id], item.data_id))
        end
        if (data_ref_valid[item.txn_id]) begin
          if (item.dbid != data_dbid_ref[item.txn_id]) begin
            `uvm_error(get_type_name(),
                       $sformatf("data txn_id=0x%0h DBID mismatch across beats: %0d vs %0d",
                                 item.txn_id, data_dbid_ref[item.txn_id], item.dbid))
          end
          if (item.ccid != data_ccid_ref[item.txn_id]) begin
            `uvm_error(get_type_name(),
                       $sformatf("data txn_id=0x%0h CCID mismatch across beats: %0d vs %0d",
                                 item.txn_id, data_ccid_ref[item.txn_id], item.ccid))
          end
        end
      end

      if (!item.data_last) begin
        if (item.data_be != first_data_be[item.txn_id]) begin
          `uvm_error(get_type_name(),
                     $sformatf("data txn_id=0x%0h middle beat BE mismatch: first=0x%0h beat=0x%0h",
                               item.txn_id, first_data_be[item.txn_id], item.data_be))
        end
      end else begin
        if ((item.data_be & ~first_data_be[item.txn_id]) != 16'h0000) begin
          `uvm_error(get_type_name(),
                     $sformatf("data txn_id=0x%0h last beat BE not subset of first beat: first=0x%0h beat=0x%0h",
                               item.txn_id, first_data_be[item.txn_id], item.data_be))
        end
      end

      if (resp_seen.exists(item.txn_id) && resp_seen[item.txn_id] &&
          resp_status_seen[item.txn_id] == AMBA_CHI_RESP_COMPDB &&
          item.dbid != resp_dbid_seen[item.txn_id]) begin
        `uvm_error(get_type_name(),
                   $sformatf("data txn_id=0x%0h DBID mismatch with response: resp=%0d data=%0d",
                             item.txn_id, resp_dbid_seen[item.txn_id], item.dbid))
      end

      next_data_id[item.txn_id] = item.data_id + 4'd1;
      if (item.data_last) begin
        data_last_seen[item.txn_id] = 1'b1;
        data_complete[item.txn_id] = 1'b1;
      end
      if (cfg != null && data_beats_seen[item.txn_id] > cfg.master_cfg.max_data_beats) begin
        `uvm_error(get_type_name(),
                   $sformatf("data channel txn_id=0x%0h beat overflow %0d > %0d",
                             item.txn_id, data_beats_seen[item.txn_id], cfg.master_cfg.max_data_beats))
      end
      if (cfg != null && cfg.master_cfg.en_strict_semantics && item.data_poison) begin
        `uvm_warning(get_type_name(),
                     $sformatf("data channel txn_id=0x%0h carries poison bit", item.txn_id))
      end
      finalize_txn_if_done(item.txn_id);
    end else if (item.channel == AMBA_CHI_CH_SNOOP) begin
      if (pending_reqs.exists(item.txn_id)) begin
        req = pending_reqs[item.txn_id];
      end else if (completed_reqs.exists(item.txn_id)) begin
        req = completed_reqs[item.txn_id];
      end else begin
        `uvm_error(get_type_name(),
                   $sformatf("snoop txn_id=0x%0h has no matching request", item.txn_id))
        return;
      end

      if (req.version != item.version) begin
        `uvm_error(get_type_name(),
                   $sformatf("version mismatch for snoop txn_id=0x%0h: req=%0d snoop=%0d",
                             item.txn_id, req.version, item.version))
      end

      if (exp_snoop.exists(item.txn_id) && !exp_snoop[item.txn_id] &&
          cfg != null && cfg.master_cfg.en_strict_semantics) begin
        `uvm_warning(get_type_name(),
                     $sformatf("snoop txn_id=0x%0h observed for opcode 0x%0h (optional snoop path)",
                               item.txn_id, req.opcode))
      end

      snoop_seen[item.txn_id] = 1'b1;
      snoop_count++;
      if (!amba_chi_is_valid_snoop_type(item.snoop_type)) begin
        `uvm_error(get_type_name(),
                   $sformatf("snoop channel txn_id=0x%0h carried unsupported snoop type 0x%0h",
                             item.txn_id, item.snoop_type))
      end
      if (!amba_chi_supports_snoop_type(item.version, item.snoop_type)) begin
        `uvm_error(get_type_name(),
                   $sformatf("snoop channel txn_id=0x%0h type 0x%0h not valid in version %0d",
                             item.txn_id, item.snoop_type, item.version))
      end
      finalize_txn_if_done(item.txn_id);
    end
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (pending_reqs.num() != 0) begin
      `uvm_error(get_type_name(),
                 $sformatf("%0d request(s) left unmatched", pending_reqs.num()))
    end

    if (req_order_q.size() != 0) begin
      `uvm_error(get_type_name(),
                 $sformatf("%0d request(s) left in ordering queue", req_order_q.size()))
    end

    if (resp_count < req_count) begin
      `uvm_error(get_type_name(), $sformatf("request/response count mismatch: req=%0d resp=%0d",
                                            req_count, resp_count))
    end

    foreach (exp_data[txn_id]) begin
      if (exp_data[txn_id] && (!data_complete.exists(txn_id) || !data_complete[txn_id])) begin
        `uvm_error(get_type_name(),
                   $sformatf("request txn_id=0x%0h requires complete data but last beat was not seen", txn_id))
      end
    end

    foreach (exp_snoop[txn_id]) begin
      if (exp_snoop[txn_id] && (!snoop_seen.exists(txn_id) || !snoop_seen[txn_id])) begin
        `uvm_error(get_type_name(),
                   $sformatf("request txn_id=0x%0h requires snoop but snoop was not seen", txn_id))
      end
    end

    foreach (retry_ack_seen[txn_id]) begin
      bit ack_seen;
      bit grant_seen;

      ack_seen = retry_ack_seen[txn_id];
      grant_seen = pcrd_grant_seen.exists(txn_id) ? pcrd_grant_seen[txn_id] : 1'b0;
      if (ack_seen != grant_seen) begin
        `uvm_error(get_type_name(),
                   $sformatf("retry pair incomplete for txn_id=0x%0h: RetryAck=%0d PCrdGrant=%0d",
                             txn_id, ack_seen, grant_seen))
      end
    end

    foreach (pcrd_grant_seen[txn_id]) begin
      bit ack_seen;
      bit grant_seen;

      ack_seen = retry_ack_seen.exists(txn_id) ? retry_ack_seen[txn_id] : 1'b0;
      grant_seen = pcrd_grant_seen[txn_id];
      if (ack_seen != grant_seen) begin
        `uvm_error(get_type_name(),
                   $sformatf("retry pair incomplete for txn_id=0x%0h: RetryAck=%0d PCrdGrant=%0d",
                             txn_id, ack_seen, grant_seen))
      end
    end
  endfunction
endclass