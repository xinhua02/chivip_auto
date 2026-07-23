class amba_chi_slave_feature_matrix_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_feature_matrix_seq)

  function new(string name = "amba_chi_slave_feature_matrix_seq");
    super.new(name);
  endfunction

  task body();
    bit [15:0] txn_ids[$] = '{16'h3100, 16'h3101, 16'h3102, 16'h3103, 16'h3104, 16'h3105};

    delay_ns(30ns);

    foreach (txn_ids[i]) begin
      send_resp($sformatf("rsp_%0d", i), txn_ids[i],
                (i == 3) ? AMBA_CHI_RESP_PCRD_GRANT : AMBA_CHI_RESP_COMP);

      if (i == 0 || i == 2 || i == 4) begin
        send_data_beat($sformatf("data_%0d", i), txn_ids[i], 32'hde00_0000 + i, 4'd0, 1'b1);
      end

      if (i == 3 || i == 5) begin
        send_snoop($sformatf("snoop_%0d", i), txn_ids[i],
                   (i == 3) ? AMBA_CHI_SNOOP_DVM : AMBA_CHI_SNOOP_STASH_ONCE_SHARED);
      end
    end
  endtask
endclass
