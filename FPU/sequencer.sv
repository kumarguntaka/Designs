class our_sequencer extends uvm_sequencer #(seq_item);
	`uvm_component_utils(our_sequencer)

	// Constructor
	function new(string name = "our_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
endclass