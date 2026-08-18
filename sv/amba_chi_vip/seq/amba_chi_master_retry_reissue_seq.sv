class amba_chi_master_retry_reissue_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_retry_reissue_seq)

  function new(string name = "amba_chi_master_retry_reissue_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req_first", 16'h9201, 64'h9200_0000, AMBA_CHI_REQ_WRITE_NO_SNP, 11'h021, 11'h121,
             AMBA_CHI_VERSION_E, 32'h9201_0001, 1'b1);
    #80ns;
    send_req("req_retry", 16'h9201, 64'h9200_0000, AMBA_CHI_REQ_WRITE_NO_SNP, 11'h021, 11'h121,
             AMBA_CHI_VERSION_E, 32'h9201_0002, 1'b1);
  endtask
endclass
