class amba_chi_master_version_matrix_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_master_version_matrix_seq)

  amba_chi_version_e version = AMBA_CHI_VERSION_E;

  function new(string name = "amba_chi_master_version_matrix_seq");
    super.new(name);
  endfunction

  protected task send_req(bit [15:0] txn_id, bit [63:0] addr, bit [7:0] opcode,
                          bit [10:0] src_id, bit [10:0] tgt_id);
    amba_chi_item req;
    req = amba_chi_item::type_id::create($sformatf("req_%0h", txn_id));
    req.version = version;
    req.role = AMBA_CHI_ROLE_MASTER;
    req.channel = AMBA_CHI_CH_REQ;
    req.txn_id = txn_id;
    req.address = addr;
    req.src_id = src_id;
    req.tgt_id = tgt_id;
    req.opcode = opcode;
    if (amba_chi_req_has_payload(opcode)) begin
      req.data_words.push_back(32'ha5a5_0000 | txn_id);
    end
    start_item(req);
    finish_item(req);
  endtask

  task body();
    case (version)
      AMBA_CHI_VERSION_A: begin
        send_req(16'hA101, 64'hA100_0000, AMBA_CHI_REQ_READ_SHARED, 11'h011, 11'h101);
        send_req(16'hA102, 64'hA100_0040, AMBA_CHI_REQ_WRITE_UNIQUE, 11'h011, 11'h101);
      end
      AMBA_CHI_VERSION_B: begin
        send_req(16'hB101, 64'hB100_0000, AMBA_CHI_REQ_READ_ONCE, 11'h012, 11'h102);
        send_req(16'hB102, 64'hB100_0040, AMBA_CHI_REQ_WRITE_CLEAN_FULL, 11'h012, 11'h102);
      end
      AMBA_CHI_VERSION_C: begin
        send_req(16'hC101, 64'hC100_0000, AMBA_CHI_REQ_ATOMIC_ADD, 11'h013, 11'h103);
        send_req(16'hC102, 64'hC100_0040, AMBA_CHI_REQ_READ_CLEAN, 11'h013, 11'h103);
      end
      AMBA_CHI_VERSION_D: begin
        send_req(16'hD101, 64'hD100_0000, AMBA_CHI_REQ_DVM_OP, 11'h014, 11'h104);
        send_req(16'hD102, 64'hD100_0040, AMBA_CHI_REQ_PREFETCH_TGT, 11'h014, 11'h104);
      end
      AMBA_CHI_VERSION_E: begin
        send_req(16'hE101, 64'hE100_0000, AMBA_CHI_REQ_READ_PERSIST, 11'h015, 11'h105);
        send_req(16'hE102, 64'hE100_0040, AMBA_CHI_REQ_STASH_ONCE_SHARED, 11'h015, 11'h105);
      end
      AMBA_CHI_VERSION_F: begin
        send_req(16'hF101, 64'hF100_0000, AMBA_CHI_REQ_PREFETCH_TGT, 11'h016, 11'h106);
        send_req(16'hF102, 64'hF100_0040, AMBA_CHI_REQ_READ_PERSIST, 11'h016, 11'h106);
      end
      default: begin
        `uvm_fatal(get_type_name(), $sformatf("unsupported version %0d", version))
      end
    endcase
  endtask
endclass
