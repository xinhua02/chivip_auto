// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

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
  bit resp_seen[bit [15:0]];
  bit aux_seen[bit [15:0]];
  int unsigned req_count;
  int unsigned resp_count;
  int unsigned aux_count;
  int unsigned max_outstanding_seen;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    master_imp = new("master_imp", this);
    slave_imp = new("slave_imp", this);
  endfunction

  function void write_master(amba_chi_item item);
    if (item.channel != AMBA_CHI_CH_REQ) begin
      `uvm_error(get_type_name(),
                 $sformatf("master monitor sent unexpected channel %0d for txn_id=0x%0h",
                           item.channel, item.txn_id))
      return;
    end

    req_count++;
    if (pending_reqs.exists(item.txn_id)) begin
      `uvm_error(get_type_name(),
                 $sformatf("duplicate request txn_id=0x%0h detected", item.txn_id))
      return;
    end
    pending_reqs[item.txn_id] = item;
    req_order_q.push_back(item.txn_id);

    if (pending_reqs.num() > max_outstanding_seen) begin
      max_outstanding_seen = pending_reqs.num();
    end

    if (cfg != null && pending_reqs.num() > cfg.master_cfg.max_outstanding) begin
      `uvm_error(get_type_name(),
                 $sformatf("outstanding request limit exceeded: %0d > %0d",
                           pending_reqs.num(), cfg.master_cfg.max_outstanding))
    end
  endfunction

  function void write_slave(amba_chi_item item);
    amba_chi_item req;

    if (item.channel != AMBA_CHI_CH_RESP &&
        item.channel != AMBA_CHI_CH_DATA &&
        item.channel != AMBA_CHI_CH_SNOOP) begin
      `uvm_error(get_type_name(),
                 $sformatf("slave monitor sent unexpected channel %0d for txn_id=0x%0h",
                           item.channel, item.txn_id))
      return;
    end

    if (item.channel == AMBA_CHI_CH_RESP) begin
      if (!pending_reqs.exists(item.txn_id)) begin
        `uvm_error(get_type_name(),
                   $sformatf("response txn_id=0x%0h has no matching request", item.txn_id))
        return;
      end

      if (cfg != null && cfg.en_in_order_resp && req_order_q.size() > 0 &&
          req_order_q[0] != item.txn_id) begin
        `uvm_error(get_type_name(),
                   $sformatf("response ordering violation: expected txn_id=0x%0h got 0x%0h",
                             req_order_q[0], item.txn_id))
      end

      req = pending_reqs[item.txn_id];
      if (req.version != item.version) begin
        `uvm_error(get_type_name(),
                   $sformatf("version mismatch for txn_id=0x%0h: req=%0d resp=%0d",
                             item.txn_id, req.version, item.version))
      end

      if (req.role != AMBA_CHI_ROLE_MASTER || item.role != AMBA_CHI_ROLE_SLAVE) begin
        `uvm_error(get_type_name(),
                   $sformatf("role mismatch for txn_id=0x%0h", item.txn_id))
      end

      resp_count++;
      resp_seen[item.txn_id] = 1'b1;
      completed_reqs[item.txn_id] = req;
      pending_reqs.delete(item.txn_id);

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

      aux_seen[item.txn_id] = 1'b1;
      aux_count++;
      if (item.data_words.size() == 0) begin
        `uvm_error(get_type_name(),
                   $sformatf("data channel txn_id=0x%0h carried no payload", item.txn_id))
      end
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

      aux_seen[item.txn_id] = 1'b1;
      aux_count++;
      if (item.snoop_type === 'x) begin
        `uvm_error(get_type_name(),
                   $sformatf("snoop channel txn_id=0x%0h carried unknown snoop type", item.txn_id))
      end
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

    if (req_count != resp_count) begin
      `uvm_error(get_type_name(), $sformatf("request/response count mismatch: %0d vs %0d",
                                            req_count, resp_count))
    end

    foreach (completed_reqs[txn_id]) begin
      amba_chi_item req = completed_reqs[txn_id];
      bit is_read_req = (req.opcode == AMBA_CHI_REQ_READ_SHARED ||
                         req.opcode == AMBA_CHI_REQ_READ_EXCL);
      if (is_read_req && !aux_seen.exists(txn_id)) begin
        `uvm_error(get_type_name(),
                   $sformatf("read request txn_id=0x%0h completed without data", txn_id))
      end
    end
  endfunction
endclass