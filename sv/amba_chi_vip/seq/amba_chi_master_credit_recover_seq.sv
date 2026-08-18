class amba_chi_master_credit_recover_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_credit_recover_seq)

  function new(string name = "amba_chi_master_credit_recover_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req0", 16'hA301, 64'hA300_0000, AMBA_CHI_REQ_READ_SHARED, 11'h025, 11'h125);
    send_req("req1", 16'hA302, 64'hA300_0040, AMBA_CHI_REQ_READ_SHARED, 11'h025, 11'h125);
    #90ns;
    send_req("req2", 16'hA303, 64'hA300_0080, AMBA_CHI_REQ_READ_SHARED, 11'h025, 11'h125);
  endtask
endclass
