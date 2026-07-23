class amba_chi_master_overflow_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_overflow_seq)

  function new(string name = "amba_chi_master_overflow_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req0", 16'h4001, 64'h4000_0000, AMBA_CHI_REQ_READ_SHARED, 11'h004, 11'h104);
    send_req("req1", 16'h4002, 64'h4000_0010, AMBA_CHI_REQ_READ_SHARED, 11'h004, 11'h104);
  endtask
endclass