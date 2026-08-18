class amba_chi_slave_atomic_return_semantics_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_atomic_return_semantics_seq)

  function new(string name = "amba_chi_slave_atomic_return_semantics_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(40ns);

    send_resp("rsp_atomic_add", 16'hA501, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h2a, 4'h1);
    send_data_beat("dat_atomic_add", 16'hA501, 32'hA501_1001, 4'd0, 1'b1, 16'hFFFF,
                   AMBA_CHI_VERSION_E, 6'h2a, 4'h1);

    send_resp("rsp_atomic_set", 16'hA502, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h2b, 4'h2);
    send_data_beat("dat_atomic_set", 16'hA502, 32'hA502_1002, 4'd0, 1'b1, 16'hFFFF,
                   AMBA_CHI_VERSION_E, 6'h2b, 4'h2);
  endtask
endclass
