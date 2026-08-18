function automatic bit amba_chi_supports_req_opcode_vF(bit [7:0] opcode);
  return amba_chi_supports_req_opcode_vE(opcode);
endfunction

function automatic bit amba_chi_supports_snoop_type_vF(bit [7:0] snoop);
  return amba_chi_supports_snoop_type_vE(snoop);
endfunction
