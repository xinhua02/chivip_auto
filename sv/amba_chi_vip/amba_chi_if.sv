interface amba_chi_if #(int unsigned ADDR_WIDTH = 64,
                        int unsigned DATA_WIDTH = 128) (
    input logic clk,
    input logic rst_n
);

  // ============================================================================
  // Request Flit Structure
  // ============================================================================
  typedef struct packed {
    logic [7:0] opcode;
    logic [15:0] txn_id;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data;
    logic [10:0] src_id;
    logic [10:0] tgt_id;
    logic [3:0] qos;
    logic [3:0] txn_type;
    logic [2:0] order;
    logic [2:0] size;
    logic [2:0] mem_attr;
    logic [1:0] endian;
    logic allow_retry;
    logic exp_comp_dbid;
    logic [7:0] trace_tag;
  } req_flit_t;

  // ============================================================================
  // Response Flit Structure
  // ============================================================================
  typedef struct packed {
    logic [7:0] opcode;
    logic [7:0] status;
    logic [2:0] err;
    logic [15:0] txn_id;
    logic [5:0] dbid;
    logic [3:0] ccid;
    logic [7:0] trace_tag;
  } resp_flit_t;

  // ============================================================================
  // Data Flit Structure
  // ============================================================================
  typedef struct packed {
    logic [DATA_WIDTH-1:0] payload;
    logic [15:0] txn_id;
    logic [3:0] id;
    logic last;
    logic poison;
    logic [(DATA_WIDTH/8)-1:0] be;
    logic [5:0] dbid;
    logic [3:0] ccid;
    logic [7:0] trace_tag;
  } data_flit_t;

  // ============================================================================
  // Snoop Flit Structure
  // ============================================================================
  typedef struct packed {
    logic [7:0] type_;
    logic [15:0] txn_id;
    logic [2:0] attr;
    logic [10:0] fwd_nid;
    logic [7:0] trace_tag;
  } snoop_flit_t;

  // Request channel
  logic req_valid;
  logic req_ready;
  req_flit_t req_flit;

  // Response channel
  logic resp_valid;
  logic resp_ready;
  resp_flit_t resp_flit;

  // Data channel
  logic data_valid;
  logic data_ready;
  data_flit_t data_flit;

  // Snoop channel
  logic snoop_valid;
  logic snoop_ready;
  snoop_flit_t snoop_flit;

  modport master (
      input clk,
      input rst_n,
      output req_valid,
      input req_ready,
      output req_flit,
      input resp_valid,
      output resp_ready,
      input resp_flit,
      input data_valid,
      output data_ready,
      input data_flit,
      input snoop_valid,
      output snoop_ready,
      input snoop_flit
  );

  modport slave (
      input clk,
      input rst_n,
      input req_valid,
      output req_ready,
      input req_flit,
      output resp_valid,
      input resp_ready,
      output resp_flit,
      output data_valid,
      input data_ready,
      output data_flit,
      output snoop_valid,
      input snoop_ready,
      output snoop_flit
  );

  modport monitor (
      input clk,
      input rst_n,
      input req_valid,
      input req_ready,
      input req_flit,
      input resp_valid,
      input resp_ready,
      input resp_flit,
      input data_valid,
      input data_ready,
      input data_flit,
      input snoop_valid,
      input snoop_ready,
      input snoop_flit
  );
endinterface