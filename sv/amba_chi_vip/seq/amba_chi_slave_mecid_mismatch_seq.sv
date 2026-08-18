class amba_chi_slave_mecid_mismatch_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_mecid_mismatch_seq)

  function new(string name = "amba_chi_slave_mecid_mismatch_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(40ns);
    send_resp("rsp", 16'hB101, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h19, 4'h3);
    send_data_beat("dat", 16'hB101, 32'hB101_1001, 4'd0, 1'b1, 16'hFFFF,
                   AMBA_CHI_VERSION_E, 6'h19, 4'h3, 2'b10, 8'h7E, 1'b1, 1'b1);
  endtask
endclass
