class amba_chi_slave_snoop_orphan_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_snoop_orphan_seq)

  function new(string name = "amba_chi_slave_snoop_orphan_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(30ns);
    send_resp("rsp", 16'h5201, AMBA_CHI_RESP_COMP);
    send_data_beat("data", 16'h5201, 32'h5201_0001, 4'd0, 1'b1);
    send_snoop("snoop_orphan", 16'h52ff, 8'h3f);
  endtask
endclass