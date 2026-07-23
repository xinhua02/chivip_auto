// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class amba_chi_snoop_vseq extends uvm_sequence;
  `uvm_object_utils(amba_chi_snoop_vseq)
  `uvm_declare_p_sequencer(amba_chi_virtual_sequencer)

  function new(string name = "amba_chi_snoop_vseq");
    super.new(name);
  endfunction

  task body();
    amba_chi_master_snoop_seq master_seq;
    amba_chi_slave_snoop_seq slave_seq;

    if (p_sequencer == null) begin
      `uvm_fatal(get_type_name(), "amba_chi_snoop_vseq requires a virtual sequencer")
    end

    master_seq = amba_chi_master_snoop_seq::type_id::create("master_seq");
    slave_seq = amba_chi_slave_snoop_seq::type_id::create("slave_seq");

    fork
      master_seq.start(p_sequencer.master_sequencer);
      slave_seq.start(p_sequencer.slave_sequencer);
    join
  endtask
endclass