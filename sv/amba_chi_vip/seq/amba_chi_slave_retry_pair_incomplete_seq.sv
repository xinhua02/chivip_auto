class amba_chi_slave_retry_pair_incomplete_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_retry_pair_incomplete_seq)

  function new(string name = "amba_chi_slave_retry_pair_incomplete_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(30ns);
    send_resp("rsp_retry_only", 16'hB201, AMBA_CHI_RESP_RETRY);
  endtask
endclass
