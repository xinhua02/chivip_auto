class amba_chi_master_data_multibeat_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_data_multibeat_seq)

  function new(string name = "amba_chi_master_data_multibeat_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req", 16'h6301, 64'h6300_0000, AMBA_CHI_REQ_READ_SHARED, 11'h031, 11'h131);
  endtask
endclass
