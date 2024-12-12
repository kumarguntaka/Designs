module readfile
(
);

int f1;
int current_time=0, size, pop_time = 0, load_timer=0;
bit havependingrequest = 0;
bit queuefull = 0, queueempty=1, ready=1;

bit open_row[4][4][26142] = '{default:0};

typedef struct packed {
int request_time;
int op;
logic [2:0] byte_index;
logic [2:0] burst_order;
logic [1:0] bank_group;
logic [1:0] bank;
logic [7:0] col;
logic [17:0] row;
}Transaction;

typedef struct packed {
int clock, command;
logic [35:0] addr;} str;

str inputs;
Transaction queue[$:15];
Transaction push, pop;

string filename;
string op_str;

initial begin
	$value$plusargs("%s",filename);
	f1 = $fopen(filename,"r");
	do begin
	if(!queuefull) begin
		if(!havependingrequest) begin
			if(!$feof(f1)) begin
				$fscanf(f1,"%d%d%h", inputs.clock, inputs.command, inputs.addr);
				havependingrequest = 1;
				if($test$plusargs("enable")) begin
					$display("CPU Clock Cycle = %d Command  = %d Address = %h", inputs.clock, inputs.command, inputs.addr);
				end
			end
		end
		if(havependingrequest) begin
			if(queueempty) begin
				if(current_time < inputs.clock)
					current_time = inputs.clock;
			end
			if(current_time >= inputs.clock) begin
					unique case(inputs.command)
						0: op_str = "READ";
						1: op_str = "WRITE";		
						2: op_str= "INSTRUCTION_FETCH";
	  				endcase			
  
					push.byte_index = inputs.addr[2:0];
					push.burst_order = inputs.addr[5:3];
					push.bank_group = inputs.addr[7:6];
					push.bank = inputs.addr[9:8];
					push.col = inputs.addr[17:10];	
					push.row = inputs.addr[35:18];	
					push.request_time = inputs.clock;
					push.op = inputs.command;
					queue.push_back(push);
					$display("Memory Request inserted into Queue: Current Time: %0d, Request Time=%0d CPU Cycles, Operation=%s,\n\t\t Address: Row=%5h, Col=%2h, Bank=%1h, Bank_Grp=%1h, Burst_Order=%1h, Byte_Index=%1h\n", current_time, push.request_time, op_str, push.row, push.col, push.bank, push.bank_group, push.burst_order, push.byte_index);
					havependingrequest = 0;
					queueempty = 0;
					size = queue.size();
					if(size == 16)
						queuefull = 1;
			end
		end
	end
		
	if(!queueempty) begin
		scheduler();
		//$display("%1b",queueempty);
		//PRECHARGE();
		//ACTIVATE();
		//READ();
		//DATA();

	end
	current_time++;
	end while (!queueempty || havependingrequest || !$feof(f1));
	
end

/*function scheduler(); 
	static int unsigned counter = 0;
	int size_new;
	if(counter >= 100) begin
		pop = queue.pop_front();
		$display("Memory Request removed from Queue: Current Time=%0d, Request Time=%0d CPU Cycles, Operation=%s,\n\t\t Address: Row=%5h, Col=%2h, Bank=%1h, Bank_Grp=%1h, Burst_Order=%1h, Byte_Index=%1h\n", current_time, pop.request_time, op_str, pop.row, pop.col, pop.bank, pop.bank_group, pop.burst_order, pop.byte_index);
		//$display("Output from QUEUE: Current Time: %d %p\n", current_time, pop); 
		counter = 0;
		queuefull = 0;
		size_new = queue.size();
		if(size_new == 0)
			queueempty = 1;	
	end
	else
		counter++;
endfunction*/
function void scheduler();
	static int unsigned counter = 0;
	static string state;
	int size_new;
	int bank_group, bank, row;
	bank_group = queue[0].bank_group;
	bank = queue[0].bank;
	row = queue[0].row;
	
	if(ready==1) begin
	if(open_row[bank_group][bank][row] == 1) begin
		READ(queue[0].bank_group,queue[0].bank, queue[0].col,load_timer);
		ready=0;
		pop_time=load_timer;
	end
	else begin
		for(int k=0;k<26124;k++) begin
			if(open_row[bank_group][bank][k]==1) begin
				PRECHARGE(queue[0].bank_group,queue[0].bank, load_timer);
				open_row[bank_group][bank][k]=0;
				open_row[bank_group][bank][row]=1;
				ACTIVATE(queue[0].bank_group,queue[0].bank, queue[0].row, load_timer);
				unique case(queue[0].op)
					0: READ(queue[0].bank_group,queue[0].bank, queue[0].col,load_timer);
					1: WRITE(queue[0].bank_group,queue[0].bank, queue[0].col,load_timer);		
					2: READ(queue[0].bank_group,queue[0].bank, queue[0].col, load_timer);
	  			endcase	
				ready=0;
				pop_time=load_timer;
				break;
			end
		end
	end
	end
	if(ready==1) begin
		begin
		ACTIVATE(queue[0].bank_group,queue[0].bank, queue[0].row,load_timer);
		//open_row[queue[0].bank_group][queue[0].bank][queue[0].row]=1;
		open_row[bank_group][bank][row]=1;
		unique case(queue[0].op)
			0: READ(queue[0].bank_group,queue[0].bank, queue[0].col, load_timer);
			1: WRITE(queue[0].bank_group,queue[0].bank, queue[0].col,load_timer);		
			2: READ(queue[0].bank_group,queue[0].bank, queue[0].col,load_timer);
	  	endcase	
		pop_time=load_timer;
		//$display("%d, %d, %d, %d", bank_group, bank, row, open_row[bank_group][bank][row]);
		ready=0;
		end
		//pop=queue.pop_front();
		//$display("Memory Request removed from Queue: Current Time=%0d, Request Time=%0d CPU Cycles, Operation=%s,\n\t\t Address: Row=%5h, Col=%2h, Bank=%1h, Bank_Grp=%1h, Burst_Order=%1h, Byte_Index=%1h\n", current_time, pop.request_time, op_str, pop.row, pop.col, pop.bank, pop.bank_group, pop.burst_order, pop.byte_index);

	end

	// Queue item pop logic
	if(counter >= pop_time) begin
		pop = queue.pop_front();
		unique case(pop.op)
						0: op_str = "READ";
						1: op_str = "WRITE";		
						2: op_str= "INSTRUCTION_FETCH";
	  				endcase	
		$display("Memory Request removed from Queue: Current Time=%0d, Request Time=%0d CPU Cycles, Operation=%s,\n\t\t Address: Row=%5h, Col=%2h, Bank=%1h, Bank_Grp=%1h, Burst_Order=%1h, Byte_Index=%1h\n", current_time, pop.request_time, op_str, pop.row, pop.col, pop.bank, pop.bank_group, pop.burst_order, pop.byte_index);
		//$display("Output from QUEUE: Current Time: %d %p\n", current_time, pop); 
		counter = 0;
		queuefull = 0;
		ready = 1;
		load_timer=0;
		size_new = queue.size();
		if(size_new == 0)
			queueempty = 1;	
	end
	else
		counter++; 
endfunction

/*function PRECHARGE();
	static int pre_counter = 24;
	static int TRP=24;
	int i;
	for(i=0;i<TRP;i=i+1)
	begin
		
		pre_counter=pre_counter-1;
		current_time=current_time+1;
		if(pre_counter==0)
		begin
			$display("%d PRE %1h %1h \n",current_time, push.bank_group, push.bank);
		end
	end
endfunction*/

function PRECHARGE(input logic [1:0] bank_group, logic [1:0] bank, int timer);
	static int pre_counter = 24;
	static int TRP=24;
	$display("%d PRE %1h %1h \n",current_time+timer, bank_group, bank);
	//pop_time = TRP;
	load_timer=timer+24;
endfunction
						
function ACTIVATE(input logic [1:0] bank_group, logic [1:0] bank, logic [17:0] row, int timer);
	static int pre_counter = 24;
	static int TRCD=24;
	$display("%d ACT %1h %1h %h \n",current_time+timer, bank_group, bank, row);
	//pop_time = TRCD;
	load_timer=timer+24;
endfunction

function READ(input logic [1:0] bank_group, logic [1:0] bank, logic [7:0] col, int timer);
	static int pre_counter = 24;
	static int TCL=24;
	$display("%d RD  %1h %1h %2h \n ",current_time+timer,bank_group, bank, col);
	//pop_time=24; 
	load_timer=timer+24;
endfunction

function WRITE(input logic [1:0] bank_group, logic [1:0] bank, logic [7:0] col, int timer);
	static int pre_counter = 24;
	static int TCL=24;
	$display("%d WR  %1h %1h %2h \n ",current_time+timer,bank_group, bank, col);
	//pop_time=24; 
	load_timer=timer+24;
endfunction

function DATA();
	static int pre_counter = 4;
	static int T_BURST=4;
	if(pre_counter!=0)
	begin
		pre_counter=pre_counter-1;
	end
	else begin
		pre_counter=4;
		/*if(pre_counter==0)
		begin
			//$display("%d DATA ",current_time);
		end*/
	end
endfunction
endmodule
