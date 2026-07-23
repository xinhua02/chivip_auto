// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class amba_chi_slave_reorder_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_reorder_seq)

  function new(string name = "amba_chi_slave_reorder_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item rsp;
    amba_chi_item data;

    #80ns;

    rsp = amba_chi_item::type_id::create("rsp1");
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = 16'h3002;
    rsp.resp_status = AMBA_CHI_RESP_COMP;
    start_item(rsp);
    finish_item(rsp);

    data = amba_chi_item::type_id::create("data1");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h3002;
    data.data_words.push_back(32'h3002_3002);
    start_item(data);
    finish_item(data);

    rsp = amba_chi_item::type_id::create("rsp0");
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = 16'h3001;
    rsp.resp_status = AMBA_CHI_RESP_COMP;
    start_item(rsp);
    finish_item(rsp);

    data = amba_chi_item::type_id::create("data0");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h3001;
    data.data_words.push_back(32'h3001_3001);
    start_item(data);
    finish_item(data);
  endtask
endclass