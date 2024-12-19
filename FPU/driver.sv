class our_driver extends uvm_driver#(seq_item);
	`uvm_component_utils(our_driver)
	
	virtual intf vif;
	seq_item req;
	
	function new(string name = "drv", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		req = seq_item::type_id::create("req");
		if(!uvm_config_db#(virtual intf)::get(this, "","vif",vif))
			`uvm_fatal("No_vif", {"Virtual interface must be set for: ",get_full_name(),".vif"});
	endfunction: build_phase
	
	virtual task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask: run_phase
	
	// Let's try to add the reset case //
	
	virtual task drive();
		@(posedge vif.clk);
		vif.A <= req.A;
		vif.B <= req.B;
		vif.op <= req.op;
		@(posedge vif.clk);
		req.sum <= vif.sum;
		@(posedge vif.clk);
	endtask: drive
	
endclass: our_driver 
