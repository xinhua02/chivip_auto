// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

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

  logic resp_valid;
  logic resp_ready;
  logic [7:0] resp_status;
  logic [15:0] resp_txn_id;

  logic data_valid;
  logic data_ready;
  logic [DATA_WIDTH-1:0] data_payload;

  logic snoop_valid;
  logic snoop_ready;
  logic [7:0] snoop_type;
  logic [15:0] snoop_txn_id;

  modport master (
      input clk,
      input rst_n,
      output req_valid,
      input req_ready,
      output req_opcode,
      output req_txn_id,
      output req_addr,
      output req_data,
      input resp_valid,
      output resp_ready,
      input resp_status,
      input resp_txn_id,
      input data_valid,
      output data_ready,
      input data_payload,
      input snoop_valid,
      output snoop_ready,
      input snoop_type,
      input snoop_txn_id
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
      output resp_valid,
      input resp_ready,
      output resp_status,
      output resp_txn_id,
      output data_valid,
      input data_ready,
      output data_payload,
      output snoop_valid,
      input snoop_ready,
      output snoop_type,
      output snoop_txn_id
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
      input resp_valid,
      input resp_ready,
      input resp_status,
      input resp_txn_id,
      input data_valid,
      input data_ready,
      input data_payload,
      input snoop_valid,
      input snoop_ready,
      input snoop_type,
      input snoop_txn_id
  );
endinterface