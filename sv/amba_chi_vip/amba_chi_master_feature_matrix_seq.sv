class amba_chi_master_feature_matrix_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_master_feature_matrix_seq)

  function new(string name = "amba_chi_master_feature_matrix_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item req;
    bit [7:0] req_ops[$] = '{
      AMBA_CHI_REQ_READ_SHARED,
      AMBA_CHI_REQ_WRITE_UNIQUE,
      AMBA_CHI_REQ_ATOMIC_ADD,
      AMBA_CHI_REQ_DVM_OP,
      AMBA_CHI_REQ_READ_PERSIST,
      AMBA_CHI_REQ_STASH_ONCE_SHARED
    };

    foreach (req_ops[i]) begin
      req = amba_chi_item::type_id::create($sformatf("req_%0d", i));
      req.role = AMBA_CHI_ROLE_MASTER;
      req.channel = AMBA_CHI_CH_REQ;
      req.txn_id = 16'h3100 + i;
      req.address = 64'h1000_0000 + (i * 'h40);
      req.src_id = 11'h008;
      req.tgt_id = 11'h108;
      req.opcode = req_ops[i];
      start_item(req);
      finish_item(req);
    end
  endtask
endclass
