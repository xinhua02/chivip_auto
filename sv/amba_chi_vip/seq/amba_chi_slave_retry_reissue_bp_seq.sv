class amba_chi_slave_retry_reissue_bp_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_retry_reissue_bp_seq)

  function new(string name = "amba_chi_slave_retry_reissue_bp_seq");
    super.new(name);
  endfunction

  task body();
    // Emulate backpressure by delaying completion after an initial RETRY.
    delay_ns(40ns);
    send_resp("rsp_retry", 16'hA201, AMBA_CHI_RESP_RETRY);
    delay_ns(120ns);
    send_resp("rsp_comp", 16'hA201, AMBA_CHI_RESP_COMP);
  endtask
endclass
