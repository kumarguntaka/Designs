class our_test extends uvm_test;
  `uvm_component_utils(our_test)

  our_env env;
  our_add_seq seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = our_env::type_id::create("env", this);
    seq = our_add_seq::type_id::create("seq");
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass






