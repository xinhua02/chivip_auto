class amba_chi_slave_base_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_base_seq)

  function new(string name = "amba_chi_slave_base_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(30ns);
    send_resp("rsp", 16'h1001, AMBA_CHI_RESP_COMP);
    send_data_beat("data", 16'h1001, 32'hcafe_f00d);
  endtask
endclass