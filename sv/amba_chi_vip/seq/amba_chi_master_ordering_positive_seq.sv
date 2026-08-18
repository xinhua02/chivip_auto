class amba_chi_master_ordering_positive_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_ordering_positive_seq)

  function new(string name = "amba_chi_master_ordering_positive_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req0", 16'h9100, 64'h9100_0000, AMBA_CHI_REQ_READ_SHARED, 11'h020, 11'h120);
    send_req("req1", 16'h9101, 64'h9100_0040, AMBA_CHI_REQ_WRITE_NO_SNP, 11'h020, 11'h120,
             AMBA_CHI_VERSION_E, 32'h9101_0001, 1'b1);
    send_req("req2", 16'h9102, 64'h9100_0080, AMBA_CHI_REQ_ATOMIC_ADD, 11'h020, 11'h120,
             AMBA_CHI_VERSION_E, 32'h9102_0002, 1'b1);
  endtask
endclass
