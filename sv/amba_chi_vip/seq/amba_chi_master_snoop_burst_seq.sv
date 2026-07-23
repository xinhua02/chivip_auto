class amba_chi_master_snoop_burst_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_snoop_burst_seq)

  function new(string name = "amba_chi_master_snoop_burst_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req0", 16'h5101, 64'h5100_0000, AMBA_CHI_REQ_READ_SHARED, 11'h006, 11'h106);
    send_req("req1", 16'h5102, 64'h5100_0040, AMBA_CHI_REQ_READ_EXCL, 11'h006, 11'h106);
  endtask
endclass