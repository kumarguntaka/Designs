class our_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(our_scoreboard)

	uvm_analysis_imp#(seq_item,our_scoreboard) recv;

function new(string path = "our_scoreboard", uvm_component parent = null);
	super.new(path,parent);	
endfunction
	
virtual function void build_phase(uvm_phase phase);
	recv=new("recv",this);
endfunction

logic [7:0] pd_Z, pdc_Z;
logic [0:0] pd_stop;

virtual function void write(seq_item req);
	begin	
		// DUT out Predictor //
		case(req.op)
			0: pd_Z = req.A;
			/* 1: pd_Z = req.A+req.B+{8'b0,req.ci};
			2: pd_Z = req.A-req.B+{8'b0,req.ci};
			3: pd_Z = req.A*req.B+9'b0; */
		endcase
		// Recirculating Logic Predictor //
		case(pd_stop)	
			0: begin
				if(req.pushin) pd_stop = 1;
				pd_Z=pd_Z;
			end
			1: begin 
				if(req.pushin && !req.stopin)
					pd_Z=pd_Z;
				else if(req.stopin)
					pd_Z=pdc_Z;
				if(req.stopin | req.pushin) pd_stop = 1; else pd_stop = 0;
			end
		endcase
		
		pdc_Z = pd_Z;
		
		if(pd_Z!={req.sum}) `uvm_error("SCO","TEST FAILED")
	end
	
endfunction

endclass
