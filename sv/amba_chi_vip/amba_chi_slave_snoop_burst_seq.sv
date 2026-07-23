class amba_chi_slave_snoop_burst_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_snoop_burst_seq)

  function new(string name = "amba_chi_slave_snoop_burst_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item snoop;
    amba_chi_item rsp;
    amba_chi_item data;

    #30ns;

    snoop = amba_chi_item::type_id::create("snoop0");
    snoop.role = AMBA_CHI_ROLE_SLAVE;
    snoop.channel = AMBA_CHI_CH_SNOOP;
    snoop.txn_id = 16'h5101;
    snoop.snoop_type = 8'h11;
    start_item(snoop);
    finish_item(snoop);

    rsp = amba_chi_item::type_id::create("rsp0");
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = 16'h5101;
    rsp.resp_status = AMBA_CHI_RESP_COMP;
    start_item(rsp);
    finish_item(rsp);

    data = amba_chi_item::type_id::create("data0");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h5101;
    data.data_words.push_back(32'h5101_0001);
    start_item(data);
    finish_item(data);

    rsp = amba_chi_item::type_id::create("rsp1");
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = 16'h5102;
    rsp.resp_status = AMBA_CHI_RESP_COMP;
    start_item(rsp);
    finish_item(rsp);

    snoop = amba_chi_item::type_id::create("snoop1");
    snoop.role = AMBA_CHI_ROLE_SLAVE;
    snoop.channel = AMBA_CHI_CH_SNOOP;
    snoop.txn_id = 16'h5102;
    snoop.snoop_type = 8'h22;
    start_item(snoop);
    finish_item(snoop);

    data = amba_chi_item::type_id::create("data1");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h5102;
    data.data_words.push_back(32'h5102_0002);
    start_item(data);
    finish_item(data);
  endtask
endclass