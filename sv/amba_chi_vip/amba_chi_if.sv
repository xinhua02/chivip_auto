interface amba_chi_if #(int unsigned ADDR_WIDTH = 64,
                        int unsigned DATA_WIDTH = 128) (
    input logic clk,
    input logic rst_n
);
  logic req_valid;
  logic req_ready;
  logic [7:0] req_opcode;
  logic [15:0] req_txn_id;
  logic [ADDR_WIDTH-1:0] req_addr;
  logic [DATA_WIDTH-1:0] req_data;
  logic [10:0] req_src_id;
  logic [10:0] req_tgt_id;
  logic [3:0] req_qos;
  logic [3:0] req_txn_type;
  logic [2:0] req_order;
  logic [2:0] req_size;
  logic [2:0] req_mem_attr;
  logic [1:0] req_endian;
  logic req_allow_retry;
  logic req_exp_comp_dbid;
  logic [7:0] req_trace_tag;

  logic resp_valid;
  logic resp_ready;
  logic [7:0] resp_opcode;
  logic [7:0] resp_status;
  logic [2:0] resp_err;
  logic [15:0] resp_txn_id;
  logic [5:0] resp_dbid;
  logic [3:0] resp_ccid;
  logic [7:0] resp_trace_tag;

  logic data_valid;
  logic data_ready;
    logic [DATA_WIDTH-1:0] data_payload;
    logic [15:0] data_txn_id;
  logic data_id;
  logic data_last;
  logic data_poison;
  logic [(DATA_WIDTH/8)-1:0] data_be;
  logic [5:0] data_dbid;
  logic [3:0] data_ccid;
  logic [7:0] data_trace_tag;

  logic snoop_valid;
  logic snoop_ready;
  logic [7:0] snoop_type;
  logic [15:0] snoop_txn_id;
  logic [2:0] snoop_attr;
  logic [10:0] snoop_fwd_nid;
  logic [7:0] snoop_trace_tag;

  modport master (
      input clk,
      input rst_n,
      output req_valid,
      input req_ready,
      output req_opcode,
      output req_txn_id,
      output req_addr,
      output req_data,
        output req_src_id,
        output req_tgt_id,
        output req_qos,
        output req_txn_type,
        output req_order,
        output req_size,
        output req_mem_attr,
        output req_endian,
        output req_allow_retry,
        output req_exp_comp_dbid,
        output req_trace_tag,
      input resp_valid,
      output resp_ready,
        input resp_opcode,
      input resp_status,
        input resp_err,
      input resp_txn_id,
        input resp_dbid,
        input resp_ccid,
        input resp_trace_tag,
      input data_valid,
      output data_ready,
      input data_payload,
            input data_txn_id,
        input data_id,
        input data_last,
        input data_poison,
        input data_be,
        input data_dbid,
        input data_ccid,
        input data_trace_tag,
      input snoop_valid,
      output snoop_ready,
      input snoop_type,
        input snoop_txn_id,
        input snoop_attr,
        input snoop_fwd_nid,
        input snoop_trace_tag
  );

  modport slave (
      input clk,
      input rst_n,
      input req_valid,
      output req_ready,
      input req_opcode,
      input req_txn_id,
      input req_addr,
      input req_data,
        input req_src_id,
        input req_tgt_id,
        input req_qos,
        input req_txn_type,
        input req_order,
        input req_size,
        input req_mem_attr,
        input req_endian,
        input req_allow_retry,
        input req_exp_comp_dbid,
        input req_trace_tag,
      output resp_valid,
      input resp_ready,
        output resp_opcode,
      output resp_status,
        output resp_err,
      output resp_txn_id,
        output resp_dbid,
        output resp_ccid,
        output resp_trace_tag,
      output data_valid,
      input data_ready,
      output data_payload,
            output data_txn_id,
        output data_id,
        output data_last,
        output data_poison,
        output data_be,
        output data_dbid,
        output data_ccid,
        output data_trace_tag,
      output snoop_valid,
      input snoop_ready,
      output snoop_type,
        output snoop_txn_id,
        output snoop_attr,
        output snoop_fwd_nid,
        output snoop_trace_tag
  );

  modport monitor (
      input clk,
      input rst_n,
      input req_valid,
      input req_ready,
      input req_opcode,
      input req_txn_id,
      input req_addr,
      input req_data,
      input req_src_id,
      input req_tgt_id,
      input req_qos,
      input req_txn_type,
      input req_order,
      input req_size,
      input req_mem_attr,
      input req_endian,
      input req_allow_retry,
      input req_exp_comp_dbid,
      input req_trace_tag,
      input resp_valid,
      input resp_ready,
      input resp_opcode,
      input resp_status,
      input resp_err,
      input resp_txn_id,
      input resp_dbid,
      input resp_ccid,
      input resp_trace_tag,
      input data_valid,
      input data_ready,
      input data_payload,
            input data_txn_id,
      input data_id,
      input data_last,
      input data_poison,
      input data_be,
      input data_dbid,
      input data_ccid,
      input data_trace_tag,
      input snoop_valid,
      input snoop_ready,
      input snoop_type,
      input snoop_txn_id,
      input snoop_attr,
      input snoop_fwd_nid,
      input snoop_trace_tag
  );
endinterface