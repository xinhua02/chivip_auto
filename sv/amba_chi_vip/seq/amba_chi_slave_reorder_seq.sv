class amba_chi_slave_reorder_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_reorder_seq)

  function new(string name = "amba_chi_slave_reorder_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(80ns);

    send_resp("rsp1", 16'h3002, AMBA_CHI_RESP_COMP);
    send_data_beat("data1", 16'h3002, 32'h3002_3002, 4'd0, 1'b1);

    send_resp("rsp0", 16'h3001, AMBA_CHI_RESP_COMP);
    send_data_beat("data0", 16'h3001, 32'h3001_3001, 4'd0, 1'b1);
  endtask
endclass