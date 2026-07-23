class amba_chi_master_reorder_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_master_reorder_seq)

  function new(string name = "amba_chi_master_reorder_seq");
    super.new(name);
  endfunction

  task body();
    amba_chi_item req;

    req = amba_chi_item::type_id::create("req0");
    req.role = AMBA_CHI_ROLE_MASTER;
    req.channel = AMBA_CHI_CH_REQ;
    req.txn_id = 16'h3001;
    req.address = 64'h3000_0000;
    req.src_id = 11'h003;
    req.tgt_id = 11'h103;
    req.opcode = AMBA_CHI_REQ_READ_SHARED;
    start_item(req);
    finish_item(req);

    req = amba_chi_item::type_id::create("req1");
    req.role = AMBA_CHI_ROLE_MASTER;
    req.channel = AMBA_CHI_CH_REQ;
    req.txn_id = 16'h3002;
    req.address = 64'h3000_0010;
    req.src_id = 11'h003;
    req.tgt_id = 11'h103;
    req.opcode = AMBA_CHI_REQ_READ_SHARED;
    start_item(req);
    finish_item(req);
  endtask
endclass