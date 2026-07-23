class amba_chi_master_base_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_base_seq)

  function new(string name = "amba_chi_master_base_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req", 16'h1001, 64'h1000_0000, AMBA_CHI_REQ_READ_SHARED, 11'h001, 11'h101);
  endtask
endclass