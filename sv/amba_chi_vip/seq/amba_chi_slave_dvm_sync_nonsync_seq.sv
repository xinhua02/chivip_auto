class amba_chi_slave_dvm_sync_nonsync_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_dvm_sync_nonsync_seq)

  function new(string name = "amba_chi_slave_dvm_sync_nonsync_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(40ns);

    send_snoop("snp_dvm_nonsync", 16'hA401, AMBA_CHI_SNOOP_DVM);
    send_resp("rsp_dvm_nonsync", 16'hA401, AMBA_CHI_RESP_COMP);

    delay_ns(40ns);
    send_snoop("snp_dvm_sync", 16'hA402, AMBA_CHI_SNOOP_DVM);
    send_resp("rsp_dvm_sync", 16'hA402, AMBA_CHI_RESP_COMP);
  endtask
endclass
