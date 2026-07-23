// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class amba_chi_sequencer extends uvm_sequencer#(amba_chi_item);
  `uvm_component_utils(amba_chi_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass