class amba_chi_master_mecid_mismatch_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_mecid_mismatch_seq)

  function new(string name = "amba_chi_master_mecid_mismatch_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req", 16'hB101, 64'hB100_0000, AMBA_CHI_REQ_READ_PERSIST, 11'h028, 11'h128,
             AMBA_CHI_VERSION_E, '0, 1'b0, 2'b10, 8'h21);
  endtask
endclass
