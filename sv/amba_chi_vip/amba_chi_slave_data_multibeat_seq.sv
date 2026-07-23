class amba_chi_slave_data_multibeat_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_data_multibeat_seq)

  function new(string name = "amba_chi_slave_data_multibeat_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item rsp;
    amba_chi_item data;

    #30ns;

    rsp = amba_chi_item::type_id::create("rsp");
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = 16'h6301;
    rsp.resp_status = AMBA_CHI_RESP_COMPDB;
    rsp.dbid = 6'h2A;
    rsp.ccid = 4'h3;
    start_item(rsp);
    finish_item(rsp);

    data = amba_chi_item::type_id::create("data0");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h6301;
    data.data_id = 4'd0;
    data.data_last = 1'b0;
    data.data_be = 16'hFFFF;
    data.dbid = 6'h2A;
    data.ccid = 4'h3;
    data.data_words.push_back(32'h1111_0000);
    start_item(data);
    finish_item(data);

    data = amba_chi_item::type_id::create("data1");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h6301;
    data.data_id = 4'd1;
    data.data_last = 1'b0;
    data.data_be = 16'hFFFF;
    data.dbid = 6'h2A;
    data.ccid = 4'h3;
    data.data_words.push_back(32'h2222_0000);
    start_item(data);
    finish_item(data);

    data = amba_chi_item::type_id::create("data2");
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h6301;
    data.data_id = 4'd2;
    data.data_last = 1'b1;
    data.data_be = 16'h00FF;
    data.dbid = 6'h2A;
    data.ccid = 4'h3;
    data.data_words.push_back(32'h3333_0000);
    start_item(data);
    finish_item(data);
  endtask
endclass
