class amba_chi_master_retry_pair_incomplete_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_retry_pair_incomplete_seq)

  function new(string name = "amba_chi_master_retry_pair_incomplete_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req_incomplete", 16'hB201, 64'hB200_0000, AMBA_CHI_REQ_WRITE_NO_SNP, 11'h028, 11'h128,
             AMBA_CHI_VERSION_E, 32'hB201_0001, 1'b1, 2'b00, 8'h00, 1'b1);
  endtask
endclass
