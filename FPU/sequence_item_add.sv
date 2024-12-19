class our_add_seq extends uvm_sequence#(seq_item);
	`uvm_object_utils(our_add_seq)
	
	seq_item req;
	
	function new (string name= "our_add_seq");
		super.new("our_add_seq");
	endfunction

	task alu_ONE_zero_item();
		repeat(5) begin
			req = seq_item::type_id::create("req");
			start_item(req);
			//assert(req.A = 8'b0 || req.B = 8'b0);
			req.randomize() with {(req.A == 0 || req.B == 0);};
			req.op = 0; req.pushin=1;
			//req.A = 8'b0;
			//req.B = 8'b0;
			`uvm_info("SEQ",$sformatf("printingbvchjc %0s",req.sprint()),UVM_LOW)
			finish_item(req);
		end
	endtask
	
	task alu_NINF_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		req.randomize() with {(req.A==8'b11111000 || req.B==8'b11111000);};
		finish_item(req);
	endtask
	
	task alu_PINF_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {(req.A==8'b01111000 || req.B==8'b01111000);});
		finish_item(req);
	endtask
	
	task alu_NAN_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {(req.A[2:0] != 3'b000 && req.A[6:3] == 4'b1111) || (req.B[2:0] != 3'b000 && req.B[6:3] == 4'b1111);});
		finish_item(req);
	endtask
	
	task alu_ZERO_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {((req.A[2:0] == req.B[2:0] && req.A[6:3] == req.B[6:3]) && req.A[7] != req.B[7]);});
		finish_item(req);
	endtask
	
	task alu_DENRM_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {(req.A[6:3] == 4'b0000 && req.A[2:0] != 3'b000) && (req.B[6:3] == 4'b0000 && req.B[2:0] != 3'b000);});
		finish_item(req);
	endtask
	
	task alu_resA_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize with {req.A[6:3]>req.B[6:3] && A[6:3]-B[6:3]>8'b00000100;});
		finish_item(req);
	endtask
	
	task alu_resB_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize with {req.B[6:3]>req.A[6:3] && B[6:3]-A[6:3]>8'b00000100;});
		finish_item(req);
	endtask
	
	task alu_ADD_item();
		req = seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		finish_item(req);
	endtask
  
  
virtual task body();
    alu_ONE_zero_item();
    /* alu_NINF_item();
    alu_PINF_item();
    alu_NAN_item();
    alu_ZERO_item();
    alu_DENRM_item();
    alu_resA_item();
    alu_resB_item();
    alu_ADD_item(); */
endtask

  
endclass