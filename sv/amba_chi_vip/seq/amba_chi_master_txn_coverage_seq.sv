class amba_chi_master_txn_coverage_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_txn_coverage_seq)

  function new(string name = "amba_chi_master_txn_coverage_seq");
    super.new(name);
  endfunction

  task body();
    send_req("req0", 16'h7000, 64'h7000_0000, AMBA_CHI_REQ_READ_UNIQUE, 11'h041, 11'h141,
             .allow_retry(1'b1), .order(3'd1), .pas(2'b01));
    send_req("req1", 16'h7001, 64'h7000_0040, AMBA_CHI_REQ_READ_NOT_SHARED_DIRTY, 11'h041, 11'h141,
             .pas(2'b10));
    send_req("req2", 16'h7002, 64'h7000_0080, AMBA_CHI_REQ_WRITE_BACK_FULL, 11'h041, 11'h141,
             AMBA_CHI_VERSION_E, 32'h7002_0002);
    send_req("req3", 16'h7003, 64'h7000_00C0, AMBA_CHI_REQ_WRITE_EVICT_FULL, 11'h041, 11'h141,
             AMBA_CHI_VERSION_E, 32'h7003_0003, 1'b0, 2'b00, 8'h00, 1'b0, 1'b0, 3'd2, 2'b10);
    send_req("req4", 16'h7004, 64'h7000_0100, AMBA_CHI_REQ_CLEAN_SHARED, 11'h041, 11'h141);
    send_req("req5", 16'h7005, 64'h7000_0140, AMBA_CHI_REQ_CLEAN_INVALID, 11'h041, 11'h141,
         AMBA_CHI_VERSION_E, '0, 1'b0, 2'b00, 8'h00, 1'b1);
    send_req("req6", 16'h7006, 64'h7000_0180, AMBA_CHI_REQ_MAKE_INVALID, 11'h041, 11'h141);
    send_req("req7", 16'h7007, 64'h7000_01C0, AMBA_CHI_REQ_EVICT, 11'h041, 11'h141);
    send_req("req8", 16'h7008, 64'h7000_0200, AMBA_CHI_REQ_ATOMIC_SWAP, 11'h041, 11'h141,
             AMBA_CHI_VERSION_E, 32'h7008_0008, 1'b1, 2'b00, 8'h00, 1'b0, 1'b1, 3'd4, 2'b01);
    send_req("req9", 16'h7009, 64'h7000_0240, AMBA_CHI_REQ_ATOMIC_CLR, 11'h041, 11'h141,
             AMBA_CHI_VERSION_E, 32'h7009_0009, 1'b0, 2'b11);
    send_req("reqA", 16'h700A, 64'h7000_0280, AMBA_CHI_REQ_ATOMIC_SET, 11'h041, 11'h141,
             AMBA_CHI_VERSION_E, 32'h700A_000A, 1'b1, 2'b01, 8'h17, 1'b1, 1'b1, 3'd7, 2'b11);
    send_req("reqB", 16'h700B, 64'h7000_02C0, AMBA_CHI_REQ_DVM_OP, 11'h041, 11'h141,
             AMBA_CHI_VERSION_E, '0, 1'b0, 2'b00, 8'h00, 1'b1, 1'b0, 3'd5);
    send_req("reqC", 16'h700C, 64'h7000_0300, AMBA_CHI_REQ_STASH_ONCE_SHARED, 11'h041, 11'h141,
             AMBA_CHI_VERSION_E, '0, 1'b0, 2'b00, 8'h00, 1'b0, 1'b0, 3'd6);
  endtask
endclass
