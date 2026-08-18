class amba_chi_slave_credit_recover_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_credit_recover_seq)

  function new(string name = "amba_chi_slave_credit_recover_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(60ns);
    send_resp("rsp0", 16'hA301, AMBA_CHI_RESP_COMP);
    send_data_beat("dat0", 16'hA301, 32'hA301_1001, 4'd0, 1'b1);

    send_resp("rsp1", 16'hA302, AMBA_CHI_RESP_COMP);
    send_data_beat("dat1", 16'hA302, 32'hA302_1002, 4'd0, 1'b1);

    delay_ns(60ns);
    send_resp("rsp2", 16'hA303, AMBA_CHI_RESP_COMP);
    send_data_beat("dat2", 16'hA303, 32'hA303_1003, 4'd0, 1'b1);
  endtask
endclass
