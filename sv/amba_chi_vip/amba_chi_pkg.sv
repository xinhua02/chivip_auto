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
    AMBA_CHI_REQ_READ_ONCE    = 8'h02,
    AMBA_CHI_REQ_READ_UNIQUE  = 8'h03,
    AMBA_CHI_REQ_READ_CLEAN   = 8'h04,
    AMBA_CHI_REQ_READ_NOT_SHARED_DIRTY = 8'h05,
    AMBA_CHI_REQ_WRITE_NO_SNP = 8'h10,
    AMBA_CHI_REQ_WRITE_UNIQUE = 8'h11,
    AMBA_CHI_REQ_WRITE_BACK_FULL = 8'h12,
    AMBA_CHI_REQ_WRITE_CLEAN_FULL = 8'h13,
    AMBA_CHI_REQ_WRITE_EVICT_FULL = 8'h14,
    AMBA_CHI_REQ_CLEAN_SHARED = 8'h20,
    AMBA_CHI_REQ_CLEAN_INVALID = 8'h21,
    AMBA_CHI_REQ_MAKE_INVALID = 8'h22,
    AMBA_CHI_REQ_EVICT = 8'h23,
    AMBA_CHI_REQ_ATOMIC_SWAP = 8'h30,
    AMBA_CHI_REQ_ATOMIC_ADD = 8'h31,
    AMBA_CHI_REQ_ATOMIC_CLR = 8'h32,
    AMBA_CHI_REQ_ATOMIC_SET = 8'h33,
    AMBA_CHI_REQ_DVM_OP = 8'h40,
    AMBA_CHI_REQ_PREFETCH_TGT = 8'h41,
    AMBA_CHI_REQ_READ_PERSIST = 8'h50,
    AMBA_CHI_REQ_STASH_ONCE_SHARED = 8'h51
  } amba_chi_req_opcode_e;

  typedef enum bit [7:0] {
    AMBA_CHI_RESP_COMP   = 8'h00,
    AMBA_CHI_RESP_COMPDB = 8'h01,
    AMBA_CHI_RESP_RETRY  = 8'h02,
    AMBA_CHI_RESP_FAIL   = 8'h03,
    AMBA_CHI_RESP_PCRD_GRANT = 8'h04
  } amba_chi_resp_status_e;

  typedef enum bit [7:0] {
    AMBA_CHI_SNOOP_READ_ONCE = 8'h10,
    AMBA_CHI_SNOOP_READ_SHARED = 8'h11,
    AMBA_CHI_SNOOP_READ_CLEAN = 8'h12,
    AMBA_CHI_SNOOP_READ_NOT_SHARED_DIRTY = 8'h13,
    AMBA_CHI_SNOOP_READ_UNIQUE = 8'h14,
    AMBA_CHI_SNOOP_MAKE_INVALID = 8'h21,
    AMBA_CHI_SNOOP_CLEAN_SHARED = 8'h22,
    AMBA_CHI_SNOOP_CLEAN_INVALID = 8'h23,
    AMBA_CHI_SNOOP_DVM = 8'h30,
    AMBA_CHI_SNOOP_STASH_ONCE_SHARED = 8'h31
  } amba_chi_snoop_type_e;

  `include "rules/amba_chi_rules_vA.svh"
  `include "rules/amba_chi_rules_vB.svh"
  `include "rules/amba_chi_rules_vC.svh"
  `include "rules/amba_chi_rules_vD.svh"
  `include "rules/amba_chi_rules_vE.svh"

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

  function automatic bit amba_chi_is_valid_req_opcode(bit [7:0] opcode);
    case (opcode)
      AMBA_CHI_REQ_READ_SHARED,
      AMBA_CHI_REQ_READ_EXCL,
      AMBA_CHI_REQ_READ_ONCE,
      AMBA_CHI_REQ_READ_UNIQUE,
      AMBA_CHI_REQ_READ_CLEAN,
      AMBA_CHI_REQ_READ_NOT_SHARED_DIRTY,
      AMBA_CHI_REQ_WRITE_NO_SNP,
      AMBA_CHI_REQ_WRITE_UNIQUE,
      AMBA_CHI_REQ_WRITE_BACK_FULL,
      AMBA_CHI_REQ_WRITE_CLEAN_FULL,
      AMBA_CHI_REQ_WRITE_EVICT_FULL,
      AMBA_CHI_REQ_CLEAN_SHARED,
      AMBA_CHI_REQ_CLEAN_INVALID,
      AMBA_CHI_REQ_MAKE_INVALID,
      AMBA_CHI_REQ_EVICT,
      AMBA_CHI_REQ_ATOMIC_SWAP,
      AMBA_CHI_REQ_ATOMIC_ADD,
      AMBA_CHI_REQ_ATOMIC_CLR,
      AMBA_CHI_REQ_ATOMIC_SET,
      AMBA_CHI_REQ_DVM_OP,
      AMBA_CHI_REQ_PREFETCH_TGT,
      AMBA_CHI_REQ_READ_PERSIST,
      AMBA_CHI_REQ_STASH_ONCE_SHARED: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_is_valid_resp_status(bit [7:0] status);
    case (status)
      AMBA_CHI_RESP_COMP,
      AMBA_CHI_RESP_COMPDB,
      AMBA_CHI_RESP_RETRY,
      AMBA_CHI_RESP_FAIL,
      AMBA_CHI_RESP_PCRD_GRANT: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_is_valid_snoop_type(bit [7:0] snoop);
    case (snoop)
      AMBA_CHI_SNOOP_READ_ONCE,
      AMBA_CHI_SNOOP_READ_SHARED,
      AMBA_CHI_SNOOP_READ_CLEAN,
      AMBA_CHI_SNOOP_READ_NOT_SHARED_DIRTY,
      AMBA_CHI_SNOOP_READ_UNIQUE,
      AMBA_CHI_SNOOP_MAKE_INVALID,
      AMBA_CHI_SNOOP_CLEAN_SHARED,
      AMBA_CHI_SNOOP_CLEAN_INVALID,
      AMBA_CHI_SNOOP_DVM,
      AMBA_CHI_SNOOP_STASH_ONCE_SHARED: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_is_read_req_opcode(bit [7:0] opcode);
    case (opcode)
      AMBA_CHI_REQ_READ_SHARED,
      AMBA_CHI_REQ_READ_EXCL,
      AMBA_CHI_REQ_READ_ONCE,
      AMBA_CHI_REQ_READ_UNIQUE,
      AMBA_CHI_REQ_READ_CLEAN,
      AMBA_CHI_REQ_READ_NOT_SHARED_DIRTY,
      AMBA_CHI_REQ_READ_PERSIST: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_is_write_req_opcode(bit [7:0] opcode);
    case (opcode)
      AMBA_CHI_REQ_WRITE_NO_SNP,
      AMBA_CHI_REQ_WRITE_UNIQUE,
      AMBA_CHI_REQ_WRITE_BACK_FULL,
      AMBA_CHI_REQ_WRITE_CLEAN_FULL,
      AMBA_CHI_REQ_WRITE_EVICT_FULL: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_is_atomic_req_opcode(bit [7:0] opcode);
    case (opcode)
      AMBA_CHI_REQ_ATOMIC_SWAP,
      AMBA_CHI_REQ_ATOMIC_ADD,
      AMBA_CHI_REQ_ATOMIC_CLR,
      AMBA_CHI_REQ_ATOMIC_SET: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_req_needs_data_return(bit [7:0] opcode);
    return amba_chi_is_read_req_opcode(opcode) || amba_chi_is_atomic_req_opcode(opcode);
  endfunction

  function automatic bit amba_chi_req_needs_snoop(bit [7:0] opcode);
    case (opcode)
      AMBA_CHI_REQ_STASH_ONCE_SHARED,
      AMBA_CHI_REQ_DVM_OP: return 1'b1;
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_req_has_payload(bit [7:0] opcode);
    return amba_chi_is_write_req_opcode(opcode) || amba_chi_is_atomic_req_opcode(opcode);
  endfunction

  function automatic void amba_chi_get_req_expectation(
      bit [7:0] opcode,
      output bit need_resp,
      output bit need_data,
      output bit need_snoop,
      output bit has_req_payload
  );
    need_resp = 1'b1;
    need_data = amba_chi_req_needs_data_return(opcode);
    need_snoop = amba_chi_req_needs_snoop(opcode);
    has_req_payload = amba_chi_req_has_payload(opcode);
  endfunction

  function automatic bit amba_chi_is_resp_status_allowed_for_req(
      bit [7:0] req_opcode,
      bit [7:0] resp_status
  );
    if (!amba_chi_is_valid_resp_status(resp_status)) begin
      return 1'b0;
    end

    if (resp_status == AMBA_CHI_RESP_RETRY || resp_status == AMBA_CHI_RESP_FAIL) begin
      return 1'b1;
    end

    if (amba_chi_is_atomic_req_opcode(req_opcode)) begin
      return (resp_status == AMBA_CHI_RESP_COMPDB) || (resp_status == AMBA_CHI_RESP_COMP);
    end

    if (amba_chi_req_needs_data_return(req_opcode)) begin
      return (resp_status == AMBA_CHI_RESP_COMPDB) ||
             (resp_status == AMBA_CHI_RESP_COMP) ||
             (resp_status == AMBA_CHI_RESP_PCRD_GRANT);
    end

    return (resp_status == AMBA_CHI_RESP_COMP) ||
           (resp_status == AMBA_CHI_RESP_PCRD_GRANT);
  endfunction

  function automatic bit amba_chi_is_contiguous_be(bit [15:0] be);
    bit seen_one;
    bit seen_zero_after_one;

    seen_one = 1'b0;
    seen_zero_after_one = 1'b0;
    for (int i = 0; i < 16; i++) begin
      if (be[i]) begin
        seen_one = 1'b1;
        if (seen_zero_after_one) begin
          return 1'b0;
        end
      end else if (seen_one) begin
        seen_zero_after_one = 1'b1;
      end
    end
    return be != 16'h0000;
  endfunction

  function automatic bit amba_chi_supports_req_opcode(amba_chi_version_e version,
                                                      bit [7:0] opcode);
    case (version)
      AMBA_CHI_VERSION_A: return amba_chi_supports_req_opcode_vA(opcode);
      AMBA_CHI_VERSION_B: return amba_chi_supports_req_opcode_vB(opcode);
      AMBA_CHI_VERSION_C: return amba_chi_supports_req_opcode_vC(opcode);
      AMBA_CHI_VERSION_D: return amba_chi_supports_req_opcode_vD(opcode);
      AMBA_CHI_VERSION_E: return amba_chi_supports_req_opcode_vE(opcode);
      default: return 1'b0;
    endcase
  endfunction

  function automatic bit amba_chi_supports_snoop_type(amba_chi_version_e version,
                                                      bit [7:0] snoop);
    case (version)
      AMBA_CHI_VERSION_A: return amba_chi_supports_snoop_type_vA(snoop);
      AMBA_CHI_VERSION_B: return amba_chi_supports_snoop_type_vB(snoop);
      AMBA_CHI_VERSION_C: return amba_chi_supports_snoop_type_vC(snoop);
      AMBA_CHI_VERSION_D: return amba_chi_supports_snoop_type_vD(snoop);
      AMBA_CHI_VERSION_E: return amba_chi_supports_snoop_type_vE(snoop);
      default: return 1'b0;
    endcase
  endfunction

  class amba_chi_item extends uvm_sequence_item;
    rand amba_chi_version_e version;
    rand amba_chi_role_e role;
    rand amba_chi_channel_e channel;
    rand bit [15:0] txn_id;
    rand bit [63:0] address;
    rand bit [10:0] src_id;
    rand bit [10:0] tgt_id;
    rand bit [3:0] qos;
    rand bit [3:0] txn_type;
    rand bit [2:0] order;
    rand bit [2:0] size;
    rand bit [2:0] mem_attr;
    rand bit [1:0] endian;
    rand bit allow_retry;
    rand bit exp_comp_dbid;
    rand bit [7:0] opcode;
    rand bit [7:0] resp_opcode;
    rand bit [7:0] resp_status;
    rand bit [2:0] resp_err;
    rand bit [5:0] dbid;
    rand bit [3:0] ccid;
    rand bit [1:0] pas;
    rand bit [7:0] mecid;
    rand bit mismatched_mecid;
    rand bit [3:0] data_id;
    rand bit data_last;
    rand bit data_poison;
    rand bit [15:0] data_be;
    rand bit [7:0] snoop_type;
    rand bit [2:0] snoop_attr;
    rand bit [10:0] fwd_nid;
    rand bit [7:0] trace_tag;
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

    constraint req_attr_c {
      src_id inside {[0:2047]};
      tgt_id inside {[0:2047]};
      qos inside {[0:15]};
      txn_type inside {[0:15]};
      order inside {[0:7]};
      size inside {[0:6]};
      mem_attr inside {[0:7]};
      endian inside {[0:2]};
      resp_err inside {[0:7]};
      ccid inside {[0:15]};
      snoop_attr inside {[0:7]};
    }

    constraint beat_attr_c {
      if (channel == AMBA_CHI_CH_DATA) {
        data_be != 16'h0000;
      }
    }

    constraint channel_field_legality_c {
      if (channel == AMBA_CHI_CH_REQ) {
        amba_chi_is_valid_req_opcode(opcode);
        amba_chi_supports_req_opcode(version, opcode);
        if (!amba_chi_req_has_payload(opcode)) {
          data_words.size() == 0;
        }
      }
      if (channel == AMBA_CHI_CH_RESP) {
        amba_chi_is_valid_resp_status(resp_status);
        data_words.size() == 0;
      }
      if (channel == AMBA_CHI_CH_SNOOP) {
        amba_chi_is_valid_snoop_type(snoop_type);
        amba_chi_supports_snoop_type(version, snoop_type);
        data_words.size() == 0;
      }
    }

    `uvm_object_utils_begin(amba_chi_item)
      `uvm_field_enum(amba_chi_version_e, version, UVM_DEFAULT)
      `uvm_field_enum(amba_chi_role_e, role, UVM_DEFAULT)
      `uvm_field_enum(amba_chi_channel_e, channel, UVM_DEFAULT)
      `uvm_field_int(txn_id, UVM_DEFAULT)
      `uvm_field_int(address, UVM_DEFAULT)
      `uvm_field_int(src_id, UVM_DEFAULT)
      `uvm_field_int(tgt_id, UVM_DEFAULT)
      `uvm_field_int(qos, UVM_DEFAULT)
      `uvm_field_int(txn_type, UVM_DEFAULT)
      `uvm_field_int(order, UVM_DEFAULT)
      `uvm_field_int(size, UVM_DEFAULT)
      `uvm_field_int(mem_attr, UVM_DEFAULT)
      `uvm_field_int(endian, UVM_DEFAULT)
      `uvm_field_int(allow_retry, UVM_DEFAULT)
      `uvm_field_int(exp_comp_dbid, UVM_DEFAULT)
      `uvm_field_int(opcode, UVM_DEFAULT)
      `uvm_field_int(resp_opcode, UVM_DEFAULT)
      `uvm_field_int(resp_status, UVM_DEFAULT)
      `uvm_field_int(resp_err, UVM_DEFAULT)
      `uvm_field_int(dbid, UVM_DEFAULT)
      `uvm_field_int(ccid, UVM_DEFAULT)
      `uvm_field_int(pas, UVM_DEFAULT)
      `uvm_field_int(mecid, UVM_DEFAULT)
      `uvm_field_int(mismatched_mecid, UVM_DEFAULT)
      `uvm_field_int(data_id, UVM_DEFAULT)
      `uvm_field_int(data_last, UVM_DEFAULT)
      `uvm_field_int(data_poison, UVM_DEFAULT)
      `uvm_field_int(data_be, UVM_DEFAULT)
      `uvm_field_int(snoop_type, UVM_DEFAULT)
      `uvm_field_int(snoop_attr, UVM_DEFAULT)
      `uvm_field_int(fwd_nid, UVM_DEFAULT)
      `uvm_field_int(trace_tag, UVM_DEFAULT)
      `uvm_field_queue_int(data_words, UVM_DEFAULT)
      `uvm_field_int(feature_mask, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "amba_chi_item");
      super.new(name);
      src_id = '0;
      tgt_id = '0;
      qos = '0;
      txn_type = '0;
      order = '0;
      size = 3'd4;
      mem_attr = '0;
      endian = 2'd0;
      allow_retry = 1'b0;
      exp_comp_dbid = 1'b0;
      resp_opcode = '0;
      resp_err = '0;
      dbid = '0;
      ccid = '0;
      pas = 2'b00;
      mecid = 8'h00;
      mismatched_mecid = 1'b0;
      data_id = 1'b0;
      data_last = 1'b1;
      data_poison = 1'b0;
      data_be = 16'hFFFF;
      snoop_attr = '0;
      fwd_nid = '0;
      trace_tag = '0;
    endfunction

    function string convert2string();
      return $sformatf("ver=%0d role=%0d ch=%0d txn=0x%0h addr=0x%0h src=%0d tgt=%0d opc=0x%0h ropc=0x%0h rstat=0x%0h rerr=%0h dbid=%0d did=%0d last=%0d snoop=0x%0h words=%0d mask=0x%0h",
                       version, role, channel, txn_id, address, src_id, tgt_id, opcode, resp_opcode,
                       resp_status, resp_err, dbid, data_id, data_last, snoop_type,
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
    rand int unsigned max_resp_latency_cycles;
    rand int unsigned max_data_latency_cycles;
    rand int unsigned max_snoop_latency_cycles;
    rand int unsigned max_data_beats;
    rand bit en_strict_timing;
    rand bit en_strict_semantics;
    virtual amba_chi_if vif;

    constraint feature_mask_c {
      feature_mask == amba_chi_version_feature_mask(version);
    }

    constraint capacity_c {
      max_outstanding inside {[1:256]};
      data_width_bytes inside {4, 8, 16, 32, 64};
      max_resp_latency_cycles inside {[1:4096]};
      max_data_latency_cycles inside {[1:4096]};
      max_snoop_latency_cycles inside {[1:4096]};
      max_data_beats inside {[1:64]};
    }

    `uvm_object_utils_begin(amba_chi_cfg)
      `uvm_field_enum(amba_chi_version_e, version, UVM_DEFAULT)
      `uvm_field_int(feature_mask, UVM_DEFAULT)
      `uvm_field_int(is_active_master, UVM_DEFAULT)
      `uvm_field_int(is_active_slave, UVM_DEFAULT)
      `uvm_field_int(max_outstanding, UVM_DEFAULT)
      `uvm_field_int(data_width_bytes, UVM_DEFAULT)
      `uvm_field_int(max_resp_latency_cycles, UVM_DEFAULT)
      `uvm_field_int(max_data_latency_cycles, UVM_DEFAULT)
      `uvm_field_int(max_snoop_latency_cycles, UVM_DEFAULT)
      `uvm_field_int(max_data_beats, UVM_DEFAULT)
      `uvm_field_int(en_strict_timing, UVM_DEFAULT)
      `uvm_field_int(en_strict_semantics, UVM_DEFAULT)
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
      max_resp_latency_cycles = 256;
      max_data_latency_cycles = 256;
      max_snoop_latency_cycles = 256;
      max_data_beats = 16;
      en_strict_timing = 1'b1;
      en_strict_semantics = 1'b1;
    endfunction
  endclass

endpackage