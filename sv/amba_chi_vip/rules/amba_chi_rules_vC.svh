function automatic bit amba_chi_supports_req_opcode_vC(bit [7:0] opcode);
  case (opcode)
    AMBA_CHI_REQ_ATOMIC_SWAP,
    AMBA_CHI_REQ_ATOMIC_ADD,
    AMBA_CHI_REQ_ATOMIC_CLR,
    AMBA_CHI_REQ_ATOMIC_SET: return 1'b1;
    default: return amba_chi_supports_req_opcode_vB(opcode);
  endcase
endfunction

function automatic bit amba_chi_supports_snoop_type_vC(bit [7:0] snoop);
  return amba_chi_supports_snoop_type_vB(snoop);
endfunction
