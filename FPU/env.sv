class our_env extends uvm_env;
`uvm_component_utils(our_env)

function new(string name="our_env", uvm_component parent=null);
super.new(name,parent);
endfunction

our_agent agent;
our_scoreboard scoreboard;


//build phase
function void build_phase( uvm_phase phase);
agent = our_agent::type_id::create("agent", this);
scoreboard = our_scoreboard::type_id::create("scorboard",this);
endfunction


//connect phase
function void connect_phase(uvm_phase phase);
agent.monitor.request_in_port.connect(scoreboard.recv);
endfunction

endclass