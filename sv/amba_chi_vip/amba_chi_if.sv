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
    logic [1:0] pas;
    logic [7:0] mecid;
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
    logic [1:0] pas;
    logic [7:0] mecid;
    logic mismatched_mecid;
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

  // Link and low-power signals
  logic TXLINKACTIVEREQ;
  logic TXLINKACTIVEACK;
  logic RXLINKACTIVEREQ;
  logic RXLINKACTIVEACK;
  logic TXSACTIVE;
  logic RXSACTIVE;

  // Request channel
  logic REQFLITPEND;
  logic REQFLITV;
  req_flit_t REQFLIT;
  logic REQLCRDV;

  // Response channel
  logic RSPFLITPEND;
  logic RSPFLITV;
  resp_flit_t RSPFLIT;
  logic RSPLCRDV;

  // Data channel
  logic DATFLITPEND;
  logic DATFLITV;
  data_flit_t DATFLIT;
  logic DATLCRDV;

  // Snoop channel
  logic SNPFLITPEND;
  logic SNPFLITV;
  snoop_flit_t SNPFLIT;
  logic SNPLCRDV;

  modport master (
      input clk,
      input rst_n,
      output REQFLITPEND,
      output REQFLITV,
      output REQFLIT,
      input REQLCRDV,
      input RSPFLITPEND,
      input RSPFLITV,
      input RSPFLIT,
      output RSPLCRDV,
      input DATFLITPEND,
      input DATFLITV,
      input DATFLIT,
      output DATLCRDV,
      input SNPFLITPEND,
      input SNPFLITV,
      input SNPFLIT,
      output SNPLCRDV
  );

  modport slave (
      input clk,
      input rst_n,
      input REQFLITPEND,
      input REQFLITV,
      input REQFLIT,
      output REQLCRDV,
      output RSPFLITPEND,
      output RSPFLITV,
      output RSPFLIT,
      input RSPLCRDV,
      output DATFLITPEND,
      output DATFLITV,
      output DATFLIT,
      input DATLCRDV,
      output SNPFLITPEND,
      output SNPFLITV,
      output SNPFLIT,
      input SNPLCRDV
  );

  modport monitor (
      input clk,
      input rst_n,
      input REQFLITPEND,
      input REQFLITV,
      input REQFLIT,
      input REQLCRDV,
      input RSPFLITPEND,
      input RSPFLITV,
      input RSPFLIT,
      input RSPLCRDV,
      input DATFLITPEND,
      input DATFLITV,
      input DATFLIT,
      input DATLCRDV,
      input SNPFLITPEND,
      input SNPFLITV,
      input SNPFLIT,
      input SNPLCRDV
  );
endinterface