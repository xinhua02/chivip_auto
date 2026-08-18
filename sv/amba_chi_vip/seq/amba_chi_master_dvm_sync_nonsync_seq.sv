class amba_chi_master_dvm_sync_nonsync_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_dvm_sync_nonsync_seq)

  function new(string name = "amba_chi_master_dvm_sync_nonsync_seq");
    super.new(name);
  endfunction

  task body();
    // Non-sync style DVM request.
    send_req("req_dvm_nonsync", 16'hA401, 64'hA400_0000, AMBA_CHI_REQ_DVM_OP, 11'h026, 11'h126);
    // Sync style DVM request.
    send_req("req_dvm_sync", 16'hA402, 64'hA400_0040, AMBA_CHI_REQ_DVM_OP, 11'h026, 11'h126);
  endtask
endclass
