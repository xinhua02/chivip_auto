class amba_chi_slave_data_multibeat_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_data_multibeat_seq)

  function new(string name = "amba_chi_slave_data_multibeat_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(40ns);

    send_resp("rsp", 16'h6301, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h0d, 4'h2);
    send_data_beat("data_beat0", 16'h6301, 32'h6301_0000, 4'd0, 1'b0, 16'h00FF,
                   AMBA_CHI_VERSION_E, 6'h0d, 4'h2);
    send_data_beat("data_beat1", 16'h6301, 32'h6301_0001, 4'd1, 1'b0, 16'h00FF,
                   AMBA_CHI_VERSION_E, 6'h0d, 4'h2);
    send_data_beat("data_beat2", 16'h6301, 32'h6301_0002, 4'd2, 1'b1, 16'h00FF,
                   AMBA_CHI_VERSION_E, 6'h0d, 4'h2);
  endtask
endclass
