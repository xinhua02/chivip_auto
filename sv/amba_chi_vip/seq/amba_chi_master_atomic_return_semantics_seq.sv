class amba_chi_master_atomic_return_semantics_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_atomic_return_semantics_seq)

  function new(string name = "amba_chi_master_atomic_return_semantics_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req_atomic_add", 16'hA501, 64'hA500_0000, AMBA_CHI_REQ_ATOMIC_ADD, 11'h027, 11'h127,
             AMBA_CHI_VERSION_E, 32'hA501_0001, 1'b1);
    send_req("req_atomic_set", 16'hA502, 64'hA500_0040, AMBA_CHI_REQ_ATOMIC_SET, 11'h027, 11'h127,
             AMBA_CHI_VERSION_E, 32'hA502_0002, 1'b1);
  endtask
endclass
