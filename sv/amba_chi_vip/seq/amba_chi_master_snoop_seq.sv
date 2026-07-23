class amba_chi_master_snoop_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_snoop_seq)

  function new(string name = "amba_chi_master_snoop_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req", 16'h5001, 64'h5000_0000, AMBA_CHI_REQ_READ_EXCL, 11'h005, 11'h105);
  endtask
endclass