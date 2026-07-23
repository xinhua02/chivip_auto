// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class amba_chi_slave_overflow_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_overflow_seq)

  function new(string name = "amba_chi_slave_overflow_seq");
    super.new(name);
  endfunction

  task body();
    #200ns;
  endtask
endclass