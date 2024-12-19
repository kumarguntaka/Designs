class our_agent extends uvm_agent; 
  `uvm_component_utils(our_agent) 
  
  our_sequencer sequencer;
  our_driver driver;
  our_monitor monitor;

//constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction:new
    
//Build Phase  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
        
    driver = our_driver::type_id::create("driver",this);
    sequencer = our_sequencer::type_id::create("sequencer",this);  
    monitor = our_monitor::type_id::create("monitor",this);
  endfunction: build_phase
    
//connect Phase 
  function void connect_phase(uvm_phase phase);
   driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction: connect_phase
endclass: our_agent