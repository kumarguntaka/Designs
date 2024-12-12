// Import the timing parameters from package 
import timing_parameters::*;

//Memory controller module
module memory_controller
(
);

//Internal variable and flag definitions
int f1,fd;
longint current_time=0, pop_time = 0, load_timer=0;
int size;
bit havependingrequest = 0;
bit queuefull = 0, queueempty=1, ready=1;

//Array to keep track of open rows
bit open_row[2**BANK_GROUP_WIDTH][2**BANK_WIDTH][2**ROW_WIDTH] = '{default:0};
/*Internal Variables and Flags:

Internal variables and flags are defined to manage the memory controller's operations:
f1, fd: File-related variables.
current_time: Tracks the current simulation time.
pop_time: Tracks the time when a transaction is popped from the queue.
load_timer: Timer used for scheduling memory operations.
size: Tracks the size of the queue.
havependingrequest: Flag indicating whether there is a pending request.
queuefull, queueempty: Flags indicating whether the queue is full or empty.
ready: Flag indicating whether the memory controller is ready to process requests.
open_row: 3-dimensional array tracking open rows in memory banks.*/
//Instruction queue structure

typedef struct packed {
longint request_time;
int op;
logic [2:0] bytes;
logic [2:0] low_col;
logic [1:0] bank_group;
logic [1:0] bank;
logic [7:0] col;
logic [14:0] row;
}Transaction;

//Structure for the file reading 
typedef struct packed {
longint clock, command;
logic [32:0] addr;} str;

str inputs;
//Instruction buffer
Transaction queue[$:(BUFFER_SIZE-1)];
//Objects used for push and pop from instruction buffer
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
  
					push.bytes = inputs.addr[2:0];
					push.low_col = inputs.addr[5:3];
					push.bank_group = inputs.addr[7:6];
					push.bank = inputs.addr[9:8];
					push.col = inputs.addr[17:10];	
					push.row = inputs.addr[32:18];	
					push.request_time = inputs.clock;
					push.op = inputs.command;
					queue.push_back(push);
					$display("Memory Request inserted into Queue: Current Time: %0d, Request Time=%0d CPU Cycles, Operation=%s,\n\t\t Address: Row=%0h, Column=%0h, Bank=%0h, Bank_Grp=%0h, Low Column=%0h, Byte_Index=%0h\n", current_time, push.request_time, op_str, push.row, push.col, push.bank, push.bank_group, push.low_col, push.bytes);
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
	end
	current_time++;
	end while (!queueempty || havependingrequest || !$feof(f1));
	$fclose(f1);
end
/*Let's delve into the details of the file reading and queue management part of the memory controller module:

1. **File Reading**:
   - The memory controller module reads memory requests from a file specified by the `filename` variable.
   - It uses the `$value$plusargs` system function to read the file name from command-line arguments.
   - The file is opened for reading using `$fopen`.
   - Inside the `initial` block, a `do-while` loop iterates through the file contents until the end of the file (`$feof`) or until the queue is empty and there are no pending requests.
   - Within the loop:
     - It checks if the queue is not full (`!queuefull`) and there is no pending request (`!havependingrequest`).
     - If conditions are met, it reads a line from the file using `$fscanf` and stores the values in the `inputs` structure.
     - It sets `havependingrequest` flag to indicate the presence of a pending request.
   - The loop also handles conditions where there is at least one pending request and the queue is not empty.
   - After processing all requests, the file is closed using `$fclose`.

2. **Queue Management**:
   - The memory controller maintains a queue named `queue` to store memory requests.
   - When a memory request is read from the file and stored in the `inputs` structure, it is converted into a `Transaction` and pushed into the `queue` using the `push_back` method.
   - Before pushing the transaction into the queue, it checks if the queue is not full (`!queuefull`).
   - If the queue size reaches the maximum capacity (16 in this case), the `queuefull` flag is set to 1 to indicate that the queue is full.
   - After pushing the transaction into the queue, it updates the `size` variable with the current size of the queue.
   - Information about the inserted memory request, including the current time, request time, operation, and address details, is displayed using `$display`.

Overall, this part of the code manages the reading of memory requests from a file and the insertion of these requests into a queue. It ensures that the queue does not overflow 
its capacity and provides information about the inserted memory requests for monitoring purposes.*/

//Function for memory controller operations
function void scheduler();
	static longint unsigned counter = 0;
	int size_new;
	int bank_group, bank, row, col, op;
	bank_group = queue[0].bank_group;
	bank = queue[0].bank;
	row = queue[0].row;
	col = queue[0].col;
	op = queue[0].op;
	
	if(ready==1) begin
		if(open_row[bank_group][bank][row] == 1) begin
			unique case(op)
				0: READ(bank_group,bank, col, load_timer);
				1: WRITE(bank_group,bank, col, load_timer);		
				2: READ(bank_group,bank, col, load_timer);
	  		endcase	
			ready=0;
			pop_time=load_timer;
		end
		else begin
			for(int i=0;i<(2**ROW_WIDTH);i++) begin
				if(open_row[bank_group][bank][i]==1) begin
					PRECHARGE(bank_group,bank, load_timer);
					open_row[bank_group][bank][i]=0;
					ACTIVATE(bank_group,bank, row, load_timer);
					open_row[bank_group][bank][row]=1;
					unique case(op)
						0: READ(bank_group,bank, col,load_timer);
						1: WRITE(bank_group,bank, col,load_timer);		
						2: READ(bank_group,bank, col, load_timer);
	  				endcase	
					ready=0;
					pop_time=load_timer;
					break;
				end
			end
		end
	end
	if(ready==1) begin
		ACTIVATE(bank_group,bank, row,load_timer);
		open_row[bank_group][bank][row]=1;
		unique case(op)
			0: READ(bank_group,bank, col, load_timer);
			1: WRITE(bank_group,bank, col,load_timer);		
			2: READ(bank_group,bank, col,load_timer);
	  	endcase	
		pop_time=load_timer;
		ready=0;

	end

	// Queue item pop logic
	if(counter >= (2*pop_time)) begin
		pop = queue.pop_front();
		unique case(pop.op)
			0: op_str = "READ";
			1: op_str = "WRITE";		
			2: op_str= "INSTRUCTION_FETCH";
	  	endcase	
		$display("Memory Request removed from Queue: Current Time=%0d, Request Time=%0d CPU Cycles, Operation=%s,\n\t\t Address: Row=%0h, Col=%0h, Bank=%0h, Bank_Grp=%0h, Low Column=%0h, Byte_Index=%0h\n", current_time, pop.request_time, op_str, pop.row, pop.col, pop.bank, pop.bank_group, pop.low_col, pop.bytes);
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
/*Let's explore the scheduler function in the memory controller module:

1. **Scheduler Function**:
   - The `scheduler` function is responsible for scheduling memory operations based on the contents of the queue and the status of open rows.
   - It operates within the context of the `initial` block and is called when there are pending memory requests in the queue (`!queueempty`).
   - The scheduler function begins by selecting the first transaction from the queue and extracting its parameters, including the bank group, bank, row, column, and operation type.
   - It checks if the memory controller is ready (`ready == 1`) to process the transaction and if the selected row is open (`open_row[bank_group][bank][row] == 1`).
   - If the memory controller is ready and the row is open, it proceeds to perform the memory operation specified by the transaction's operation type (`op`).
   - If the row is not open, it searches for an open row within the same bank group and bank. Upon finding an open row, it issues a precharge command to close the currently open row, followed by an activate command to open the desired row.
   - After issuing the activate command, it updates the `ready` flag to indicate that the memory controller is busy and cannot accept new requests until the current operation completes.
   - The scheduler function also updates the `pop_time` variable with the time required to complete the operation.
   - If the memory controller is not ready to process the transaction immediately, it waits until the counter reaches twice the `pop_time` before popping the transaction from the queue and issuing the corresponding memory command.
   - Once the memory operation is completed, the scheduler function pops the transaction from the queue, updates flags and timers, and checks if the queue is empty. If the queue is empty, the `queueempty` flag is set to 1.

Overall, the scheduler function orchestrates memory operations based on the contents of the queue and the status of open rows. It ensures that memory commands are issued in a timely manner and that the memory controller operates efficiently.*/

//Function to provide PRECHARGE command
function void PRECHARGE(input logic [1:0] bank_group, logic [1:0] bank, longint timer);
	$display("%d PRE %1h %1h \n",current_time+(timer*2), bank_group, bank);
	fd=$fopen("finaloutput.txt","a");	
	$fwrite(fd,"%0d\tPRE\t%0h\t%0h\n",current_time+(timer*2), bank_group, bank);
	$fclose(fd);
	load_timer=timer+TRP;
endfunction
/*PRECHARGE Function:

The PRECHARGE function is responsible for issuing a precharge command to close a row in a memory bank.
It takes the bank group and bank as input parameters to specify the target memory bank.
Additionally, it takes a timer parameter to calculate the timing for the precharge operation.
Inside the function, it displays the precharge command along with the current simulation time and the specified bank group and bank.
It also updates the load_timer with the timing for the precharge operation plus the value of TRP (precharge delay).
#####This function is used in the scheduler to close an open row before activating a new row.####*/
						
//Function to provide ACTIVATE command
function void ACTIVATE(input logic [1:0] bank_group, logic [1:0] bank, logic [14:0] row, longint timer);
	$display("%d ACT %1h %1h %h \n",current_time+(timer*2), bank_group, bank, row);
	fd=$fopen("finaloutput.txt","a");	
	$fwrite(fd,"%0d\tACT\t%0h\t%0h\t%0h\n",current_time+(timer*2), bank_group, bank, row);
	$fclose(fd);
	load_timer=timer+TRCD;
endfunction
/*ACTIVATE Function:

The ACTIVATE function is responsible for issuing an activate command to open a specific row in a memory bank.
Similar to the PRECHARGE function, it takes the bank group, bank, and row as input parameters to specify the target memory row.
It also takes a timer parameter to calculate the timing for the activate operation.
Inside the function, it displays the activate command along with the current simulation time and the specified bank group, bank, and row.
It updates the load_timer with the timing for the activate operation plus the value of TRCD (row-to-column delay).
###This function is used in the scheduler to open a row before performing read or write operations.*/

//Function to provide READ command
function void READ(input logic [1:0] bank_group, logic [1:0] bank, logic [7:0] col, longint timer);
	$display("%d RD %1h %1h %2h \n",current_time+(timer*2),bank_group, bank, col);
	fd=$fopen("finaloutput.txt","a");	
	$fwrite(fd,"%0d\tRD \t%0h\t%0h\t%0h\n",current_time+(timer*2),bank_group, bank, col);
	$fclose(fd);
	load_timer=timer+TCL;
	DATA(load_timer);
endfunction
/*READ Function:

The READ function is responsible for issuing a read command to retrieve data from a specific column in a memory bank.
It takes the bank group, bank, and column as input parameters to specify the target memory location.
Similar to other functions, it also takes a timer parameter to calculate the timing for the read operation.
Inside the function, it displays the read command along with the current simulation time and the specified bank group, bank, and column.
It updates the load_timer with the timing for the read operation plus the value of TCL (column access latency).
#######Additionally, it calls the DATA function to handle the data phase of the read operation.*/

//Function to provide WRITE command
function void WRITE(input logic [1:0] bank_group, logic [1:0] bank, logic [7:0] col, longint timer);
	$display("%d WR %1h %1h %2h \n",current_time+(timer*2),bank_group, bank, col);
	fd=$fopen("finaloutput.txt","a");	
	$fwrite(fd,"%0d\tWR \t%0h\t%0h\t%0h\n",current_time+(timer*2),bank_group, bank, col);
	$fclose(fd);
	load_timer=timer+TCWD;
	DATA(load_timer);
endfunction
/*WRITE Function:

The WRITE function is responsible for issuing a write command to store data into a specific column in a memory bank.
Similar to the READ function, it takes the bank group, bank, and column as input parameters to specify the target memory location.
It also takes a timer parameter to calculate the timing for the write operation.
Inside the function, it displays the write command along with the current simulation time and the specified bank group, bank, and column.
It updates the load_timer with the timing for the write operation plus the value of TCWD (write column delay).
######Similar to the READ function, it calls the DATA function to handle the data phase of the write operation.*/
//Function to account for data phase

function void DATA(longint timer);
	load_timer=timer+T_BURST;
endfunction
/*DATA Function:

The DATA function is responsible for handling the data phase of memory operations, such as read or write.
It takes a timer parameter to calculate the timing for the data phase.
Inside the function, it updates the load_timer with the timing for the data phase plus the value of T_BURST (burst transfer time).*/
endmodule
/*These functions collectively manage the timing and execution of memory commands,
 ensuring proper operation of the memory controller module. Each function encapsulates 
 specific memory operations and handles the timing constraints associated with them.*/