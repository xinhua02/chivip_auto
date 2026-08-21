class amba_chi_slave_version_matrix_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_version_matrix_seq)

  amba_chi_version_e version = AMBA_CHI_VERSION_E;

  function new(string name = "amba_chi_slave_version_matrix_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(60ns);

    case (version)
      AMBA_CHI_VERSION_A: begin
        send_resp("rsp_a0", 16'hA101, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_A);
        send_data_beat("data_a0", 16'hA101, 32'haaaa_a101, 4'd0, 1'b1, 16'hFFFF, AMBA_CHI_VERSION_A);
        send_resp("rsp_a1", 16'hA102, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_A);
      end
      AMBA_CHI_VERSION_B: begin
        send_resp("rsp_b0", 16'hB101, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_B);
        send_data_beat("data_b0", 16'hB101, 32'hbbbb_b101, 4'd0, 1'b1, 16'hFFFF, AMBA_CHI_VERSION_B);
        send_resp("rsp_b1", 16'hB102, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_B);
      end
      AMBA_CHI_VERSION_C: begin
        send_resp("rsp_c0", 16'hC101, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_C, 6'h03, 4'h4);
        send_data_beat("data_c0", 16'hC101, 32'hcccc_c101, 4'd0, 1'b1, 16'hFFFF,
                       AMBA_CHI_VERSION_C, 6'h03, 4'h4);
        send_resp("rsp_c1", 16'hC102, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_C);
        send_data_beat("data_c1", 16'hC102, 32'hcccc_c102, 4'd0, 1'b1, 16'hFFFF, AMBA_CHI_VERSION_C);
      end
      AMBA_CHI_VERSION_D: begin
        send_snoop("snoop_d0", 16'hD101, AMBA_CHI_SNOOP_DVM, AMBA_CHI_VERSION_D);
        send_resp("rsp_d0", 16'hD101, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_D);
        send_resp("rsp_d1", 16'hD102, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_D);
      end
      AMBA_CHI_VERSION_E: begin
        send_resp("rsp_e0", 16'hE101, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_E, 6'h05, 4'h6);
        send_data_beat("data_e0", 16'hE101, 32'heeee_e101, 4'd0, 1'b1, 16'hFFFF,
                       AMBA_CHI_VERSION_E, 6'h05, 4'h6);
        send_snoop("snoop_e1", 16'hE102, AMBA_CHI_SNOOP_STASH_ONCE_SHARED, AMBA_CHI_VERSION_E);
        send_resp("rsp_e1", 16'hE102, AMBA_CHI_RESP_COMP, AMBA_CHI_VERSION_E);
      end
      AMBA_CHI_VERSION_F: begin
        send_resp("rsp_f0_retry", 16'hF101, AMBA_CHI_RESP_RETRY, AMBA_CHI_VERSION_F);
        send_resp("rsp_f0_pcrd", 16'hF101, AMBA_CHI_RESP_PCRD_GRANT, AMBA_CHI_VERSION_F);
        send_resp("rsp_f1", 16'hF102, AMBA_CHI_RESP_COMPDB, AMBA_CHI_VERSION_F, 6'h06, 4'h7);
        send_data_beat("data_f1", 16'hF102, 32'hffff_f102, 4'd0, 1'b1, 16'hFFFF,
                       AMBA_CHI_VERSION_F, 6'h06, 4'h7);
      end
      default: begin
        `uvm_fatal(get_type_name(), $sformatf("unsupported version %0d", version))
      end
    endcase
  endtask
endclass
