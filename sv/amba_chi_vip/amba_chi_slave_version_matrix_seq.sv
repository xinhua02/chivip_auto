class amba_chi_slave_version_matrix_seq extends uvm_sequence#(amba_chi_item);
  `uvm_object_utils(amba_chi_slave_version_matrix_seq)

  amba_chi_version_e version = AMBA_CHI_VERSION_E;

  function new(string name = "amba_chi_slave_version_matrix_seq");
    super.new(name);
  endfunction

  protected task send_resp(bit [15:0] txn_id, bit [7:0] status);
    amba_chi_item rsp;
    rsp = amba_chi_item::type_id::create($sformatf("rsp_%0h", txn_id));
    rsp.version = version;
    rsp.role = AMBA_CHI_ROLE_SLAVE;
    rsp.channel = AMBA_CHI_CH_RESP;
    rsp.txn_id = txn_id;
    rsp.resp_status = status;
    if (status == AMBA_CHI_RESP_COMPDB) begin
      rsp.dbid = 6'h1;
      rsp.ccid = 4'h1;
    end
    start_item(rsp);
    finish_item(rsp);
  endtask

  protected task send_data(bit [15:0] txn_id, bit [31:0] payload);
    amba_chi_item data;
    data = amba_chi_item::type_id::create($sformatf("data_%0h", txn_id));
    data.version = version;
    data.role = AMBA_CHI_ROLE_SLAVE;
    data.channel = AMBA_CHI_CH_DATA;
    data.txn_id = txn_id;
    data.data_id = 4'd0;
    data.data_last = 1'b1;
    data.data_be = 16'hFFFF;
    data.dbid = 6'h1;
    data.ccid = 4'h1;
    data.data_words.push_back(payload);
    start_item(data);
    finish_item(data);
  endtask

  protected task send_snoop(bit [15:0] txn_id, bit [7:0] snoop_type);
    amba_chi_item snoop;
    snoop = amba_chi_item::type_id::create($sformatf("snp_%0h", txn_id));
    snoop.version = version;
    snoop.role = AMBA_CHI_ROLE_SLAVE;
    snoop.channel = AMBA_CHI_CH_SNOOP;
    snoop.txn_id = txn_id;
    snoop.snoop_type = snoop_type;
    start_item(snoop);
    finish_item(snoop);
  endtask

  task body();
    #30ns;

    case (version)
      AMBA_CHI_VERSION_A: begin
        send_resp(16'hA101, AMBA_CHI_RESP_COMP);
        send_data(16'hA101, 32'hA1A1_0001);
        send_resp(16'hA102, AMBA_CHI_RESP_COMP);
      end
      AMBA_CHI_VERSION_B: begin
        send_resp(16'hB101, AMBA_CHI_RESP_COMP);
        send_data(16'hB101, 32'hB1B1_0001);
        send_resp(16'hB102, AMBA_CHI_RESP_COMP);
      end
      AMBA_CHI_VERSION_C: begin
        send_resp(16'hC101, AMBA_CHI_RESP_COMPDB);
        send_data(16'hC101, 32'hC1C1_0001);
        send_resp(16'hC102, AMBA_CHI_RESP_COMP);
        send_data(16'hC102, 32'hC1C1_0002);
      end
      AMBA_CHI_VERSION_D: begin
        send_resp(16'hD101, AMBA_CHI_RESP_PCRD_GRANT);
        send_snoop(16'hD101, AMBA_CHI_SNOOP_DVM);
        send_resp(16'hD102, AMBA_CHI_RESP_COMP);
      end
      AMBA_CHI_VERSION_E: begin
        send_resp(16'hE101, AMBA_CHI_RESP_COMP);
        send_data(16'hE101, 32'hE1E1_0001);
        send_resp(16'hE102, AMBA_CHI_RESP_COMP);
        send_snoop(16'hE102, AMBA_CHI_SNOOP_STASH_ONCE_SHARED);
      end
      default: begin
        `uvm_fatal(get_type_name(), $sformatf("unsupported version %0d", version))
      end
    endcase
  endtask
endclass
