// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class amba_chi_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(amba_chi_virtual_sequencer)

  virtual amba_chi_if vif;
  amba_chi_sequencer master_sequencer;
  amba_chi_sequencer slave_sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass