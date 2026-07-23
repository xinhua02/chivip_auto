class amba_chi_slave_write_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_write_seq)

  function new(string name = "amba_chi_slave_write_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item rsp;

    #30ns;

    rsp = amba_chi_item::type_id::create("rsp");
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = 16'h2001;
    rsp.resp_status = AMBA_CHI_RESP_COMP;
    start_item(rsp);
    finish_item(rsp);
  endtask
endclass