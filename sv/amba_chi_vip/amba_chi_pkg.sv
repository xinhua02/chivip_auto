// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package amba_chi_pkg;
  import uvm_pkg::*;

  `include "uvm_macros.svh"

  typedef enum bit [2:0] {
    AMBA_CHI_VERSION_A = 3'd0,
    AMBA_CHI_VERSION_B = 3'd1,
    AMBA_CHI_VERSION_C = 3'd2,
    AMBA_CHI_VERSION_D = 3'd3,
    AMBA_CHI_VERSION_E = 3'd4
  } amba_chi_version_e;

  typedef enum bit {
    AMBA_CHI_ROLE_MASTER = 1'b0,
    AMBA_CHI_ROLE_SLAVE  = 1'b1
  } amba_chi_role_e;

  typedef enum bit [1:0] {
    AMBA_CHI_CH_REQ   = 2'd0,
    AMBA_CHI_CH_RESP  = 2'd1,
    AMBA_CHI_CH_DATA  = 2'd2,
    AMBA_CHI_CH_SNOOP = 2'd3
  } amba_chi_channel_e;

  typedef enum bit [7:0] {
    AMBA_CHI_REQ_READ_SHARED  = 8'h00,
    AMBA_CHI_REQ_READ_EXCL    = 8'h01,
    AMBA_CHI_REQ_WRITE_NO_SNP = 8'h10,
    AMBA_CHI_REQ_WRITE_UNIQUE = 8'h11
  } amba_chi_req_opcode_e;

  typedef enum bit [7:0] {
    AMBA_CHI_RESP_COMP   = 8'h00,
    AMBA_CHI_RESP_COMPDB = 8'h01,
    AMBA_CHI_RESP_RETRY  = 8'h02,
    AMBA_CHI_RESP_FAIL   = 8'h03
  } amba_chi_resp_status_e;

  function automatic bit [15:0] amba_chi_version_feature_mask(amba_chi_version_e version);
    case (version)
      AMBA_CHI_VERSION_A: return 16'h0001;
      AMBA_CHI_VERSION_B: return 16'h0003;
      AMBA_CHI_VERSION_C: return 16'h0007;
      AMBA_CHI_VERSION_D: return 16'h000F;
      AMBA_CHI_VERSION_E: return 16'h001F;
      default:            return 16'h0000;
    endcase
  endfunction

  class amba_chi_item extends uvm_sequence_item;
    rand amba_chi_version_e version;
    rand amba_chi_role_e role;
    rand amba_chi_channel_e channel;
    rand bit [15:0] txn_id;
    rand bit [63:0] address;
    rand bit [7:0] opcode;
    rand bit [7:0] resp_status;
    rand bit [7:0] snoop_type;
    rand bit [31:0] data_words[$];
    rand bit [15:0] feature_mask;

    constraint feature_mask_c {
      feature_mask == amba_chi_version_feature_mask(version);
    }

    constraint data_words_c {
      if (channel == AMBA_CHI_CH_DATA) {
        data_words.size() inside {[1:16]};
      } else {
        data_words.size() == 0;
      }
    }

    `uvm_object_utils_begin(amba_chi_item)
      `uvm_field_enum(amba_chi_version_e, version, UVM_DEFAULT)
      `uvm_field_enum(amba_chi_role_e, role, UVM_DEFAULT)
      `uvm_field_enum(amba_chi_channel_e, channel, UVM_DEFAULT)
      `uvm_field_int(txn_id, UVM_DEFAULT)
      `uvm_field_int(address, UVM_DEFAULT)
      `uvm_field_int(opcode, UVM_DEFAULT)
      `uvm_field_int(resp_status, UVM_DEFAULT)
      `uvm_field_int(snoop_type, UVM_DEFAULT)
      `uvm_field_queue_int(data_words, UVM_DEFAULT)
      `uvm_field_int(feature_mask, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "amba_chi_item");
      super.new(name);
    endfunction

    function string convert2string();
      return $sformatf("version=%0d role=%0d channel=%0d txn_id=0x%0h addr=0x%0h opcode=0x%0h resp=0x%0h snoop=0x%0h words=%0d mask=0x%0h",
                       version, role, channel, txn_id, address, opcode, resp_status, snoop_type,
                       data_words.size(), feature_mask);
    endfunction
  endclass

  class amba_chi_cfg extends uvm_object;
    rand amba_chi_version_e version;
    amba_chi_role_e role;
    rand bit [15:0] feature_mask;
    rand bit is_active_master;
    rand bit is_active_slave;
    rand int unsigned max_outstanding;
    rand int unsigned data_width_bytes;
    virtual amba_chi_if vif;

    constraint feature_mask_c {
      feature_mask == amba_chi_version_feature_mask(version);
    }

    constraint capacity_c {
      max_outstanding inside {[1:256]};
      data_width_bytes inside {4, 8, 16, 32, 64};
    }

    `uvm_object_utils_begin(amba_chi_cfg)
      `uvm_field_enum(amba_chi_version_e, version, UVM_DEFAULT)
      `uvm_field_int(feature_mask, UVM_DEFAULT)
      `uvm_field_int(is_active_master, UVM_DEFAULT)
      `uvm_field_int(is_active_slave, UVM_DEFAULT)
      `uvm_field_int(max_outstanding, UVM_DEFAULT)
      `uvm_field_int(data_width_bytes, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "amba_chi_cfg");
      super.new(name);
      version = AMBA_CHI_VERSION_E;
      role = AMBA_CHI_ROLE_MASTER;
      feature_mask = amba_chi_version_feature_mask(version);
      is_active_master = 1'b1;
      is_active_slave = 1'b1;
      max_outstanding = 16;
      data_width_bytes = 16;
    endfunction
  endclass

endpackage