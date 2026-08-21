class amba_chi_slave_retry_early_resend_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_retry_early_resend_seq)

  function new(string name = "amba_chi_slave_retry_early_resend_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(30ns);
    send_resp("rsp_retry", 16'hB202, AMBA_CHI_RESP_RETRY);
    delay_ns(90ns);
    send_resp("rsp_comp_after_early_resend", 16'hB202, AMBA_CHI_RESP_COMP);
  endtask
endclass
