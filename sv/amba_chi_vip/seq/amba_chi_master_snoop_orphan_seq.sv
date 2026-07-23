class amba_chi_master_snoop_orphan_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_snoop_orphan_seq)

  function new(string name = "amba_chi_master_snoop_orphan_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req", 16'h5201, 64'h5200_0000, AMBA_CHI_REQ_READ_SHARED, 11'h007, 11'h107);
  endtask
endclass