class amba_chi_slave_snoop_type_matrix_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_snoop_type_matrix_seq)

  function new(string name = "amba_chi_slave_snoop_type_matrix_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(50ns);

    send_resp("rsp0", 16'h9300, AMBA_CHI_RESP_COMP);
    send_snoop("snp0", 16'h9300, AMBA_CHI_SNOOP_DVM);

    send_resp("rsp1", 16'h9301, AMBA_CHI_RESP_COMP);
    send_snoop("snp1", 16'h9301, AMBA_CHI_SNOOP_STASH_ONCE_SHARED);

    send_resp("rsp2", 16'h9302, AMBA_CHI_RESP_COMP);
    send_snoop("snp2", 16'h9302, AMBA_CHI_SNOOP_READ_SHARED);
    send_data_beat("dat2", 16'h9302, 32'h9302_1002, 4'd0, 1'b1);

    send_snoop("snp3", 16'h9303, AMBA_CHI_SNOOP_CLEAN_INVALID);
    send_resp("rsp3", 16'h9303, AMBA_CHI_RESP_COMP);
  endtask
endclass
