// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class amba_chi_master_snoop_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_master_snoop_seq)

  function new(string name = "amba_chi_master_snoop_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item req;

    req = amba_chi_item::type_id::create("req");
    req.role = AMBA_CHI_ROLE_MASTER;
    req.channel = AMBA_CHI_CH_REQ;
    req.txn_id = 16'h5001;
    req.address = 64'h5000_0000;
    req.opcode = AMBA_CHI_REQ_READ_EXCL;
    start_item(req);
    finish_item(req);
  endtask
endclass