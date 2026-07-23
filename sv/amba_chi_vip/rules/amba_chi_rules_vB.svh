function automatic bit amba_chi_supports_req_opcode_vB(bit [7:0] opcode);
  case (opcode)
    AMBA_CHI_REQ_READ_ONCE,
    AMBA_CHI_REQ_READ_CLEAN,
    AMBA_CHI_REQ_READ_NOT_SHARED_DIRTY,
    AMBA_CHI_REQ_WRITE_CLEAN_FULL,
    AMBA_CHI_REQ_WRITE_EVICT_FULL: return 1'b1;
    default: return amba_chi_supports_req_opcode_vA(opcode);
  endcase
endfunction

function automatic bit amba_chi_supports_snoop_type_vB(bit [7:0] snoop);
  return amba_chi_supports_snoop_type_vA(snoop);
endfunction
