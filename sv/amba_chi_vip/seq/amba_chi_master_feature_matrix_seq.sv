class amba_chi_master_feature_matrix_seq extends amba_chi_master_txn_lib_seq;
  `uvm_object_utils(amba_chi_master_feature_matrix_seq)

  function new(string name = "amba_chi_master_feature_matrix_seq");
    super.new(name);
  endfunction

  task body();
    bit [7:0] req_ops[$] = '{
      AMBA_CHI_REQ_READ_SHARED,
      AMBA_CHI_REQ_WRITE_UNIQUE,
      AMBA_CHI_REQ_ATOMIC_ADD,
      AMBA_CHI_REQ_DVM_OP,
      AMBA_CHI_REQ_READ_PERSIST,
      AMBA_CHI_REQ_STASH_ONCE_SHARED
    };

    foreach (req_ops[i]) begin
      send_req($sformatf("req_%0d", i), 16'h3100 + i, 64'h1000_0000 + (i * 'h40),
               req_ops[i], 11'h008, 11'h108, AMBA_CHI_VERSION_E,
               (32'hde00_0000 + i), 1'b0, 2'b00, 8'h00, (i == 3));
    end
  endtask
endclass
