class amba_chi_slave_write_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_write_seq)

  function new(string name = "amba_chi_slave_write_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(30ns);
    send_resp("rsp", 16'h2001, AMBA_CHI_RESP_COMP);
  endtask
endclass