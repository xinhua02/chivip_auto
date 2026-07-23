`uvm_analysis_imp_decl(_cov_master)
`uvm_analysis_imp_decl(_cov_slave)

class amba_chi_env_cov extends uvm_component;
  `uvm_component_utils(amba_chi_env_cov)

  uvm_analysis_imp_cov_master#(amba_chi_item, amba_chi_env_cov) master_imp;
  uvm_analysis_imp_cov_slave#(amba_chi_item, amba_chi_env_cov) slave_imp;

  covergroup master_req_cg with function sample(amba_chi_item item);
    option.per_instance = 1;

    cp_version: coverpoint item.version {
      bins a = {AMBA_CHI_VERSION_A};
      bins b = {AMBA_CHI_VERSION_B};
      bins c = {AMBA_CHI_VERSION_C};
      bins d = {AMBA_CHI_VERSION_D};
      bins e = {AMBA_CHI_VERSION_E};
    }

    cp_channel: coverpoint item.channel {
      bins req = {AMBA_CHI_CH_REQ};
    }

    cp_opcode: coverpoint item.opcode {
      bins read_shared  = {AMBA_CHI_REQ_READ_SHARED};
      bins read_excl    = {AMBA_CHI_REQ_READ_EXCL};
      bins write_no_snp = {AMBA_CHI_REQ_WRITE_NO_SNP};
      bins write_unique  = {AMBA_CHI_REQ_WRITE_UNIQUE};
    }

    cp_role: coverpoint item.role {
      bins master = {AMBA_CHI_ROLE_MASTER};
    }

    version_opcode_cross: cross cp_version, cp_opcode;
  endgroup

  covergroup slave_resp_cg with function sample(amba_chi_item item);
    option.per_instance = 1;

    cp_version: coverpoint item.version {
      bins a = {AMBA_CHI_VERSION_A};
      bins b = {AMBA_CHI_VERSION_B};
      bins c = {AMBA_CHI_VERSION_C};
      bins d = {AMBA_CHI_VERSION_D};
      bins e = {AMBA_CHI_VERSION_E};
    }

    cp_channel: coverpoint item.channel {
      bins resp = {AMBA_CHI_CH_RESP};
    }

    cp_status: coverpoint item.resp_status {
      bins comp   = {AMBA_CHI_RESP_COMP};
      bins compdb = {AMBA_CHI_RESP_COMPDB};
      bins retry  = {AMBA_CHI_RESP_RETRY};
      bins fail   = {AMBA_CHI_RESP_FAIL};
    }

    cp_role: coverpoint item.role {
      bins slave = {AMBA_CHI_ROLE_SLAVE};
    }

    version_status_cross: cross cp_version, cp_status;
  endgroup

  covergroup slave_data_snoop_cg with function sample(amba_chi_item item);
    option.per_instance = 1;

    cp_channel: coverpoint item.channel {
      bins data  = {AMBA_CHI_CH_DATA};
      bins snoop = {AMBA_CHI_CH_SNOOP};
    }

    cp_data_count: coverpoint item.data_words.size() {
      bins one = {1};
      bins many = {[2:16]};
    }

    cp_snoop_type: coverpoint item.snoop_type {
      bins any_type[] = {[0:255]};
    }

    channel_cross: cross cp_channel, cp_data_count;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    master_imp = new("master_imp", this);
    slave_imp = new("slave_imp", this);
    master_req_cg = new();
    slave_resp_cg = new();
    slave_data_snoop_cg = new();
  endfunction

  function void write_cov_master(amba_chi_item item);
    master_req_cg.sample(item);
  endfunction

  function void write_cov_slave(amba_chi_item item);
    if (item.channel == AMBA_CHI_CH_RESP) begin
      slave_resp_cg.sample(item);
    end else begin
      slave_data_snoop_cg.sample(item);
    end
  endfunction
endclass