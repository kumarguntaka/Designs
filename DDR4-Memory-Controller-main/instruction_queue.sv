module instruction_queue
(
input logic clock,
input bit valid, done,
output bit full, empty,
input longint time_in,
input int operation_in,
input [35:0] address_in
);
/*
Input and Output Ports:

The module has several input and output ports:
clock: Clock signal used for synchronous operations.
valid: Signal indicating the validity of the incoming transaction.
done: Signal indicating the completion of a task.
time_in: Input signal representing the time of the transaction.
operation_in: Input signal representing the type of operation.
address_in: Input signal representing the address of the transaction.
full: Output signal indicating whether the queue is full.
empty: Output signal indicating whether the queue is empty.
*/

typedef struct packed {
longint current_time;
int op;
logic [2:0] byte_index;
logic [2:0] burst_order;
logic [1:0] bank_group;
logic [1:0] bank;
logic [7:0] col;
logic [17:0] row;
}Transaction;
/*Transaction Structure:

The Transaction typedef defines the structure of a memory transaction, 
including fields such as current_time, op, byte_index, burst_order, 
bank_group, bank, col, and row.*/

int age[0:15];			
int age_ptr=0;
int size =0;		

string op_str;

Transaction unbound_que[$];	
Transaction in_que[$:15];	
Transaction queue;		
Transaction pop_var;		
/*Queue and Variables:

The module declares variables to manage the queue and track transaction ages:
age: An array used to track the age of transactions.
age_ptr: A pointer indicating the current position in the age array.
size: Variable tracking the size of the queue.
op_str: A string variable used to store the string representation of the operation type.
unbound_que: A dynamic array to store incoming transactions before they are added to the main queue.
in_que: A queue used to store transactions currently in the queue.
queue: A variable used to hold the current transaction being processed.
pop_var: A variable used to hold the transaction removed from the queue.*/


always_ff @(posedge clock) begin
	if(valid) begin
		queue.current_time = time_in;
		queue.op = operation_in;

	  unique case(queue.op)
		0: op_str = "READ";
		1: op_str = "WRITE";		
		2: op_str= "INSTRUCTION_FETCH";
	  endcase			
  
		queue.byte_index = address_in[2:0];
		queue.burst_order = address_in[5:3];
		queue.bank_group = address_in[7:6];
		queue.bank = address_in[9:8];
		queue.col = address_in[17:10];	
		queue.row = address_in[35:18];	
		age[age_ptr] = 1;
		unbound_que.push_back(queue);
		size = in_que.size();

		if(size<16) begin
		   in_que = unbound_que;
		   $display($time,"Memory Request inserted into Queue: Request Time=%d CPU Cycles, Operation=%s,\n\t\t Address: Row=%5h, Col=%2h, Bank=%1h, Bank_Grp=%1h, Burst_Order=%1h, Byte_Index=%1h\n", in_que[$].current_time, op_str, in_que[$].row, in_que[$].col, in_que[$].bank, in_que[$].bank_group, in_que[$].burst_order, in_que[$].byte_index);
		end
	end
end
/*Always Block 1:

This block is sensitive to the positive edge of the clock signal.
It processes incoming transactions when valid is high.
It updates the fields of the queue variable with the incoming transaction data.
It adds the queue transaction to the unbound_que dynamic array.
If the queue size is less than 16, it copies the contents of unbound_que to in_que.
It displays information about the inserted memory request.*/

always_ff @(posedge clock) begin
	if(valid)
		age_ptr = age_ptr + 1'd1;
	else
		age_ptr = age_ptr;
end
/*Always Block 2:

This block increments the age_ptr when valid is high, allowing the age 
tracking mechanism to advance.
*/

always_ff @(posedge clock) begin
	integer i;
	for(i=0;i<16; i=i+1) begin
		if(age[0] == 0 || age[i] > 0) begin
			age[i] = age[i] + 1'd1;
			
		end
		else
			age[i] = 1'd0;
	end
end
/*Always Block 3:

This block iterates through the age array to update the age of transactions.
It increments the age of active transactions and resets the age of 
inactive transactions.
*/

always_ff @(posedge clock) begin
	integer i,j,size2,size1;
	foreach(age[i]) begin
		if(age[i] == 'd101) begin
			
			for(j=i;j<15;j=j+1) begin
				age[j] = age[j+1];
			end
			age[15]=1;
			size1= unbound_que.size();
						
	
			if(size1!=0) begin
				unique case(unbound_que[0].op)
				0: op_str = "READ";
				1: op_str = "WRITE";		
				2: op_str= "INSTRUCTION_FETCH";
				endcase
				$display($time,,"Memory Request removed from Queue: Request Time=%d CPU Cycles, Operation=%s,\n\t\t Address: Row=%5h, Col=%2h, Bank=%1h, Bank_Grp=%1h, Burst_Order=%1h, Byte_Index=%1h\n", unbound_que[0].current_time, op_str, unbound_que[0].row, unbound_que[0].col, unbound_que[0].bank, unbound_que[0].bank_group, unbound_que[0].burst_order, unbound_que[0].byte_index);
				pop_var=unbound_que.pop_front();
				in_que=unbound_que[0:15];
				size2 = in_que.size();
				if(size2==0)
				empty=1;
				else
				empty=0;

			   
				end
			else begin
				age[0:15] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0};
				age_ptr = 0;
			end

			if(size1==0 && done==1)
				$stop;
			
			

			if(size2==16) begin
				full=1;
				unique case(in_que[0].op)
				0: op_str = "READ";
				1: op_str = "WRITE";		
				2: op_str= "INSTRUCTION_FETCH";
				endcase
			        $display($time,,"Memory Request inserted into Queue: Request Time=%d CPU Cycles, Operation=%s,\n\t\t Address: Row=%5h, Col=%2h, Bank=%1h, Bank_Grp=%1h, Burst_Order=%1h, Byte_Index=%1h\n", in_que[$].current_time, op_str, in_que[$].row, in_que[$].col, in_que[$].bank, in_que[$].bank_group, in_que[$].burst_order, in_que[$].byte_index);
			end	
			else full=0;	

			$display("Full=%1b, Empty=%1b", full, empty);

			
		end
	end
	
end
/*Always Block 4:

This block removes transactions from the queue when they reach a certain age (101 cycles).
It updates the age array and removes the oldest transaction from the unbound_que.
It updates the in_que queue with the remaining transactions.
It displays information about the removed memory request.
It handles conditions such as queue emptying and stopping the simulation when all 
transactions are processed.*/

endmodule
/*Overall, the instruction queue module manages incoming memory transactions, tracks their age, 
removes old transactions, and provides status information about the queue. It ensures efficient 
memory request handling while considering queue size constraints and transaction ages.*/