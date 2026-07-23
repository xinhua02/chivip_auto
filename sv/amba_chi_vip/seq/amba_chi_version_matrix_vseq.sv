class amba_chi_version_matrix_vseq extends uvm_sequence;
  `uvm_object_utils(amba_chi_version_matrix_vseq)
  `uvm_declare_p_sequencer(amba_chi_virtual_sequencer)

  amba_chi_version_e version = AMBA_CHI_VERSION_E;

  function new(string name = "amba_chi_version_matrix_vseq");
    super.new(name);
  endfunction

  task body();
    amba_chi_master_version_matrix_seq master_seq;
    amba_chi_slave_version_matrix_seq slave_seq;

    if (p_sequencer == null) begin
      `uvm_fatal(get_type_name(), "amba_chi_version_matrix_vseq requires a virtual sequencer")
    end

    master_seq = amba_chi_master_version_matrix_seq::type_id::create("master_seq");
    slave_seq = amba_chi_slave_version_matrix_seq::type_id::create("slave_seq");
    master_seq.version = version;
    slave_seq.version = version;

    fork
      master_seq.start(p_sequencer.master_sequencer);
      slave_seq.start(p_sequencer.slave_sequencer);
    join
  endtask
endclass
