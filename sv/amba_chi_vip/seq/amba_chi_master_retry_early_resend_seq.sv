class amba_chi_master_retry_early_resend_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_retry_early_resend_seq)

  function new(string name = "amba_chi_master_retry_early_resend_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req_first", 16'hB202, 64'hB200_0040, AMBA_CHI_REQ_WRITE_NO_SNP, 11'h029, 11'h129,
             AMBA_CHI_VERSION_E, 32'hB202_0001, 1'b1, 2'b00, 8'h00, 1'b1);
    #40ns;
    send_req("req_early_resend", 16'hB202, 64'hB200_0040, AMBA_CHI_REQ_WRITE_NO_SNP, 11'h029, 11'h129,
             AMBA_CHI_VERSION_E, 32'hB202_0002, 1'b1, 2'b00, 8'h00, 1'b1);
  endtask
endclass
