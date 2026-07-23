class amba_chi_master_write_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_write_seq)

  function new(string name = "amba_chi_master_write_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req", 16'h2001, 64'h2000_0000, AMBA_CHI_REQ_WRITE_NO_SNP, 11'h002, 11'h102,
             AMBA_CHI_VERSION_E, 32'h2001_0001, 1'b1);
  endtask
endclass