function automatic bit amba_chi_supports_req_opcode_vD(bit [7:0] opcode);
  case (opcode)
    AMBA_CHI_REQ_DVM_OP,
    AMBA_CHI_REQ_PREFETCH_TGT: return 1'b1;
    default: return amba_chi_supports_req_opcode_vC(opcode);
  endcase
endfunction

function automatic bit amba_chi_supports_snoop_type_vD(bit [7:0] snoop);
  if (snoop == AMBA_CHI_SNOOP_DVM) begin
    return 1'b1;
  end
  return amba_chi_supports_snoop_type_vC(snoop);
endfunction
