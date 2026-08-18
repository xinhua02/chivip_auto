class amba_chi_master_poison_semantics_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_poison_semantics_seq)

  function new(string name = "amba_chi_master_poison_semantics_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req", 16'h9401, 64'h9400_0000, AMBA_CHI_REQ_READ_SHARED, 11'h023, 11'h123);
  endtask
endclass
