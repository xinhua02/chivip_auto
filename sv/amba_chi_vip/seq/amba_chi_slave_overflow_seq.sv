class amba_chi_slave_overflow_seq extends amba_chi_slave_txn_lib_seq;
  `uvm_object_utils(amba_chi_slave_overflow_seq)

  function new(string name = "amba_chi_slave_overflow_seq");
    super.new(name);
  endfunction

  task body();
    delay_ns(200ns);
  endtask
endclass