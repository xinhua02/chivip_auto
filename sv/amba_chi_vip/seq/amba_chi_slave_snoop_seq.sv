class amba_chi_slave_snoop_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_snoop_seq)

  function new(string name = "amba_chi_slave_snoop_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(30ns);
    send_resp("rsp", 16'h5001, AMBA_CHI_RESP_COMP);
    send_snoop("snoop", 16'h5001, 8'h21);
    send_data_beat("data", 16'h5001, 32'h5001_5001, 4'd0, 1'b1);
  endtask
endclass