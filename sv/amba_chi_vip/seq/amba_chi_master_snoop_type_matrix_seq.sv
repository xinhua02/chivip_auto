class amba_chi_master_snoop_type_matrix_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_snoop_type_matrix_seq)

  function new(string name = "amba_chi_master_snoop_type_matrix_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req0", 16'h9300, 64'h9300_0000, AMBA_CHI_REQ_DVM_OP, 11'h022, 11'h122);
    send_req("req1", 16'h9301, 64'h9300_0040, AMBA_CHI_REQ_STASH_ONCE_SHARED, 11'h022, 11'h122);
    send_req("req2", 16'h9302, 64'h9300_0080, AMBA_CHI_REQ_READ_SHARED, 11'h022, 11'h122);
    send_req("req3", 16'h9303, 64'h9300_00C0, AMBA_CHI_REQ_CLEAN_INVALID, 11'h022, 11'h122);
  endtask
endclass
