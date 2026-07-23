class amba_chi_slave_snoop_burst_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_snoop_burst_seq)

  function new(string name = "amba_chi_slave_snoop_burst_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(30ns);

    send_snoop("snoop0", 16'h5101, 8'h11);
    send_resp("rsp0", 16'h5101, AMBA_CHI_RESP_COMP);
    send_data_beat("data0", 16'h5101, 32'h5101_0001, 4'd0, 1'b1);

    send_resp("rsp1", 16'h5102, AMBA_CHI_RESP_COMP);
    send_snoop("snoop1", 16'h5102, 8'h22);
    send_data_beat("data1", 16'h5102, 32'h5102_0002, 4'd0, 1'b1);
  endtask
endclass