class amba_chi_master_reorder_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_reorder_seq)

  function new(string name = "amba_chi_master_reorder_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req0", 16'h3001, 64'h3000_0000, AMBA_CHI_REQ_READ_SHARED, 11'h003, 11'h103);
    send_req("req1", 16'h3002, 64'h3000_0010, AMBA_CHI_REQ_READ_SHARED, 11'h003, 11'h103);
  endtask
endclass