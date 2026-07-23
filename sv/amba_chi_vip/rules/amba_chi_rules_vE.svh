function automatic bit amba_chi_supports_req_opcode_vE(bit [7:0] opcode);
  case (opcode)
    AMBA_CHI_REQ_READ_UNIQUE,
    AMBA_CHI_REQ_READ_PERSIST,
    AMBA_CHI_REQ_STASH_ONCE_SHARED: return 1'b1;
    default: return amba_chi_supports_req_opcode_vD(opcode);
  endcase
endfunction

function automatic bit amba_chi_supports_snoop_type_vE(bit [7:0] snoop);
  if (snoop == AMBA_CHI_SNOOP_STASH_ONCE_SHARED) begin
    return 1'b1;
  end
  return amba_chi_supports_snoop_type_vD(snoop);
endfunction
