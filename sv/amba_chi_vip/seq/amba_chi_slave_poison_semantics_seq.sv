class amba_chi_slave_poison_semantics_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_poison_semantics_seq)

  function new(string name = "amba_chi_slave_poison_semantics_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item data;

    delay_ns(40ns);
    send_resp("rsp", 16'h9401, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h1a, 4'h2);

    data = amba_chi_item::type_id::create("dat_poison");
    data.version = AMBA_CHI_VERSION_E;
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = 16'h9401;
    data.data_id = 4'd0;
    data.data_last = 1'b1;
    data.data_be = 16'hFFFF;
    data.dbid = 6'h1a;
    data.ccid = 4'h2;
    data.data_poison = 1'b1;
    data.data_words.push_back(32'h9401_1001);

    start_item(data);
    finish_item(data);
  endtask
endclass
