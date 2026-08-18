class amba_chi_slave_txn_coverage_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_txn_coverage_seq)

  function new(string name = "amba_chi_slave_txn_coverage_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(40ns);

    send_resp("rsp0", 16'h7000, AMBA_CHI_RESP_COMP);
    send_snoop("snp0", 16'h7000, AMBA_CHI_SNOOP_READ_ONCE);
    send_data_beat("dat0", 16'h7000, 32'h7000_1000, 4'd0, 1'b0, 16'h00FF,
             AMBA_CHI_VERSION_E, 6'h10, 4'h1, 2'b01);
    send_data_beat("dat0_last", 16'h7000, 32'h7000_1001, 4'd1, 1'b1, 16'h000F,
             AMBA_CHI_VERSION_E, 6'h10, 4'h1, 2'b01);

    send_resp("rsp1", 16'h7001, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h11, 4'h2);
    send_snoop("snp1", 16'h7001, AMBA_CHI_SNOOP_READ_CLEAN);
    send_data_beat("dat1", 16'h7001, 32'h7001_1001, 4'd0, 1'b1, 16'hFFFF,
             AMBA_CHI_VERSION_E, 6'h11, 4'h2, 2'b10, 8'h09, 1'b0, 1'b0);

    send_resp("rsp2", 16'h7002, AMBA_CHI_RESP_COMP);
    send_resp("rsp3", 16'h7003, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_E, '0, '0, 3'd3);
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
    send_data_beat("dat9", 16'h7009, 32'h7009_1009, 4'd0, 1'b1, 16'hFF00,
             AMBA_CHI_VERSION_E, 6'h09, 4'h5, 2'b11, 8'h00, 1'b0, 1'b1);

    send_resp("rspA", 16'h700A, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h0A, 4'h6);
    send_snoop("snpA", 16'h700A, AMBA_CHI_SNOOP_CLEAN_INVALID);
    send_data_beat("datA", 16'h700A, 32'h700A_100A, 4'd0, 1'b1, 16'h0FF0,
                   AMBA_CHI_VERSION_E, 6'h0A, 4'h6, 2'b01, 8'h17, 1'b1, 1'b1);

    send_resp("rspB", 16'h700B, AMBA_CHI_RESP_PCRD_GRANT);
    send_snoop("snpB", 16'h700B, AMBA_CHI_SNOOP_DVM, AMBA_CHI_VERSION_E, 3'd1, 11'h010);

    send_snoop("snpC", 16'h700C, AMBA_CHI_SNOOP_STASH_ONCE_SHARED, AMBA_CHI_VERSION_E, 3'd0, 11'h000);
    send_resp("rspC", 16'h700C, AMBA_CHI_RESP_COMP);
  endtask
endclass
