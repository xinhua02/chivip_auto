class amba_chi_slave_feature_matrix_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_feature_matrix_seq)

  function new(string name = "amba_chi_slave_feature_matrix_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item rsp;
    amba_chi_item data;
    amba_chi_item snoop;
    bit [15:0] txn_ids[$] = '{16'h3100, 16'h3101, 16'h3102, 16'h3103, 16'h3104, 16'h3105};

    #30ns;

    foreach (txn_ids[i]) begin
      rsp = amba_chi_item::type_id::create($sformatf("rsp_%0d", i));
      rsp.role = AMBA_CHI_ROLE_SLAVE;
      rsp.channel = AMBA_CHI_CH_RESP;
      rsp.txn_id = txn_ids[i];
      rsp.resp_status = (i == 3) ? AMBA_CHI_RESP_PCRD_GRANT : AMBA_CHI_RESP_COMP;
      start_item(rsp);
      finish_item(rsp);

      if (i == 0 || i == 2 || i == 4) begin
        data = amba_chi_item::type_id::create($sformatf("data_%0d", i));
        data.role = AMBA_CHI_ROLE_SLAVE;
        data.channel = AMBA_CHI_CH_DATA;
        data.txn_id = txn_ids[i];
        data.data_words.push_back(32'hde00_0000 + i);
        start_item(data);
        finish_item(data);
      end

      if (i == 3 || i == 5) begin
        snoop = amba_chi_item::type_id::create($sformatf("snoop_%0d", i));
        snoop.role = AMBA_CHI_ROLE_SLAVE;
        snoop.channel = AMBA_CHI_CH_SNOOP;
        snoop.txn_id = txn_ids[i];
        snoop.snoop_type = (i == 3) ? AMBA_CHI_SNOOP_DVM : AMBA_CHI_SNOOP_STASH_ONCE_SHARED;
        start_item(snoop);
        finish_item(snoop);
      end
    end
  endtask
endclass
