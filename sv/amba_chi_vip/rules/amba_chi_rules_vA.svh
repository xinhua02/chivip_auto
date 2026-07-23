function automatic bit amba_chi_supports_req_opcode_vA(bit [7:0] opcode);
  case (opcode)
    AMBA_CHI_REQ_READ_SHARED,
    AMBA_CHI_REQ_READ_EXCL,
    AMBA_CHI_REQ_WRITE_NO_SNP,
    AMBA_CHI_REQ_WRITE_UNIQUE,
    AMBA_CHI_REQ_WRITE_BACK_FULL,
    AMBA_CHI_REQ_CLEAN_SHARED,
    AMBA_CHI_REQ_CLEAN_INVALID,
    AMBA_CHI_REQ_MAKE_INVALID,
    AMBA_CHI_REQ_EVICT: return 1'b1;
    default: return 1'b0;
  endcase
endfunction

function automatic bit amba_chi_supports_snoop_type_vA(bit [7:0] snoop);
  case (snoop)
    AMBA_CHI_SNOOP_READ_ONCE,
    AMBA_CHI_SNOOP_READ_SHARED,
    AMBA_CHI_SNOOP_READ_CLEAN,
    AMBA_CHI_SNOOP_READ_NOT_SHARED_DIRTY,
    AMBA_CHI_SNOOP_READ_UNIQUE,
    AMBA_CHI_SNOOP_MAKE_INVALID,
    AMBA_CHI_SNOOP_CLEAN_SHARED,
    AMBA_CHI_SNOOP_CLEAN_INVALID: return 1'b1;
    default: return 1'b0;
  endcase
endfunction
