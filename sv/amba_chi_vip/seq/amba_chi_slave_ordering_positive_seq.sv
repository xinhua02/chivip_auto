class amba_chi_slave_ordering_positive_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_ordering_positive_seq)

  function new(string name = "amba_chi_slave_ordering_positive_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(40ns);

    send_resp("rsp0", 16'h9100, AMBA_CHI_RESP_COMP);
    send_data_beat("dat0", 16'h9100, 32'h9100_1000, 4'd0, 1'b1);

    send_resp("rsp1", 16'h9101, AMBA_CHI_RESP_COMP);

    send_resp("rsp2", 16'h9102, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h1f, 4'h1);
    send_data_beat("dat2", 16'h9102, 32'h9102_1002, 4'd0, 1'b1, 16'hFFFF,
                   AMBA_CHI_VERSION_E, 6'h1f, 4'h1);
  endtask
endclass
