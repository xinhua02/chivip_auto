class amba_chi_slave_txn_coverage_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_txn_coverage_seq)

  function new(string name = "amba_chi_slave_txn_coverage_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(40ns);

    send_resp("rsp0", 16'h7000, AMBA_CHI_RESP_COMP);
    send_snoop("snp0", 16'h7000, AMBA_CHI_SNOOP_READ_ONCE);
    send_data_beat("dat0", 16'h7000, 32'h7000_1000, 4'd0, 1'b1);

    send_resp("rsp1", 16'h7001, AMBA_CHI_RESP_COMP);
    send_snoop("snp1", 16'h7001, AMBA_CHI_SNOOP_READ_CLEAN);
    send_data_beat("dat1", 16'h7001, 32'h7001_1001, 4'd0, 1'b1);

    send_resp("rsp2", 16'h7002, AMBA_CHI_RESP_COMP);
    send_resp("rsp3", 16'h7003, AMBA_CHI_RESP_COMP);
    send_resp("rsp4", 16'h7004, AMBA_CHI_RESP_COMP);
    send_resp("rsp5", 16'h7005, AMBA_CHI_RESP_RETRY);
    send_resp("rsp6", 16'h7006, AMBA_CHI_RESP_COMP);
    send_resp("rsp7", 16'h7007, AMBA_CHI_RESP_FAIL);

    send_resp("rsp8", 16'h7008, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h21, 4'h3);
    send_snoop("snp8", 16'h7008, AMBA_CHI_SNOOP_READ_NOT_SHARED_DIRTY);
    send_data_beat("dat8", 16'h7008, 32'h7008_1008, 4'd0, 1'b1, 16'hFFFF,
                   AMBA_CHI_VERSION_E, 6'h21, 4'h3);

    send_resp("rsp9", 16'h7009, AMBA_CHI_RESP_COMP);
    send_snoop("snp9", 16'h7009, AMBA_CHI_SNOOP_READ_UNIQUE);
    send_data_beat("dat9", 16'h7009, 32'h7009_1009, 4'd0, 1'b1);

    send_resp("rspA", 16'h700A, AMBA_CHI_RESP_COMP);
    send_snoop("snpA", 16'h700A, AMBA_CHI_SNOOP_CLEAN_INVALID);
    send_data_beat("datA", 16'h700A, 32'h700A_100A, 4'd0, 1'b1);
  endtask
endclass
