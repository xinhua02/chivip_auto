class amba_chi_slave_snoop_orphan_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_snoop_orphan_seq)

  function new(string name = "amba_chi_slave_snoop_orphan_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item rsp;
    amba_chi_item data;
    amba_chi_item snoop;

    #30ns;

    rsp = amba_chi_item::type_id::create("rsp");
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = 16'h5201;
    rsp.resp_status = AMBA_CHI_RESP_COMP;
    start_item(rsp);
    finish_item(rsp);

    data = amba_chi_item::type_id::create("data");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h5201;
    data.data_words.push_back(32'h5201_0001);
    start_item(data);
    finish_item(data);

    snoop = amba_chi_item::type_id::create("snoop_orphan");
    snoop.role = AMBA_CHI_ROLE_SLAVE;
    snoop.channel = AMBA_CHI_CH_SNOOP;
    snoop.txn_id = 16'h52ff;
    snoop.snoop_type = 8'h3f;
    start_item(snoop);
    finish_item(snoop);
  endtask
endclass