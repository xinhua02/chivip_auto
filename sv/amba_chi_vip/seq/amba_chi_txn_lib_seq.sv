class amba_chi_master_txn_lib_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_master_txn_lib_seq)

  function new(string name = "amba_chi_master_txn_lib_seq");
    super.new(name);
  endfunction

  protected task send_req(
      string item_name,
      bit [15:0] txn_id,
      bit [63:0] address,
      bit [7:0] opcode,
      bit [10:0] src_id,
      bit [10:0] tgt_id,
      amba_chi_version_e version = AMBA_CHI_VERSION_E,
      bit [31:0] payload = '0,
      bit has_payload_override = 1'b0,
      bit [1:0] pas = 2'b00,
      bit [7:0] mecid = 8'h00
  );
    amba_chi_item req;
    bit has_payload;

    req = amba_chi_item::type_id::create(item_name);
    has_payload = amba_chi_req_has_payload(opcode) || has_payload_override;

    req.version = version;
    req.role = AMBA_CHI_ROLE_MASTER;
    req.channel = AMBA_CHI_CH_REQ;
    req.txn_id = txn_id;
    req.address = address;
    req.src_id = src_id;
    req.tgt_id = tgt_id;
    req.opcode = opcode;
    req.pas = pas;
    req.mecid = mecid;
    if (has_payload) begin
      req.data_words.push_back(payload);
    end

    start_item(req);
    finish_item(req);
  endtask
endclass

class amba_chi_slave_txn_lib_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_txn_lib_seq)

  function new(string name = "amba_chi_slave_txn_lib_seq");
    super.new(name);
  endfunction

  protected task delay_ns(time t);
    #t;
  endtask

  protected task send_resp(
      string item_name,
      bit [15:0] txn_id,
      bit [7:0] resp_status = AMBA_CHI_RESP_COMP,
      amba_chi_version_e version = AMBA_CHI_VERSION_E,
      bit [5:0] dbid = '0,
      bit [3:0] ccid = '0
  );
    amba_chi_item rsp;

    rsp = amba_chi_item::type_id::create(item_name);
    rsp.version = version;
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = txn_id;
    rsp.resp_status = resp_status;
    rsp.dbid = dbid;
    rsp.ccid = ccid;
    start_item(rsp);
    finish_item(rsp);
  endtask

  protected task send_data_beat(
      string item_name,
      bit [15:0] txn_id,
      bit [31:0] payload,
      bit [3:0] data_id = 4'd0,
      bit data_last = 1'b1,
      bit [15:0] data_be = 16'hFFFF,
      amba_chi_version_e version = AMBA_CHI_VERSION_E,
      bit [5:0] dbid = '0,
      bit [3:0] ccid = '0,
      bit [1:0] pas = 2'b00,
      bit [7:0] mecid = 8'h00,
      bit mismatched_mecid = 1'b0,
      bit data_poison = 1'b0
  );
    amba_chi_item data;

    data = amba_chi_item::type_id::create(item_name);
    data.version = version;
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = txn_id;
    data.data_id = data_id;
    data.data_last = data_last;
    data.data_be = data_be;
    data.dbid = dbid;
    data.ccid = ccid;
    data.pas = pas;
    data.mecid = mecid;
    data.mismatched_mecid = mismatched_mecid;
    data.data_poison = data_poison;
    data.data_words.push_back(payload);
    start_item(data);
    finish_item(data);
  endtask

  protected task send_snoop(
      string item_name,
      bit [15:0] txn_id,
      bit [7:0] snoop_type,
      amba_chi_version_e version = AMBA_CHI_VERSION_E
  );
    amba_chi_item snoop;

    snoop = amba_chi_item::type_id::create(item_name);
    snoop.version = version;
    snoop.role = AMBA_CHI_ROLE_SLAVE;
    snoop.channel = AMBA_CHI_CH_SNOOP;
    snoop.txn_id = txn_id;
    snoop.snoop_type = snoop_type;
    start_item(snoop);
    finish_item(snoop);
  endtask
endclass
