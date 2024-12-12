module readfile
(
input logic clock,
input bit full_in, empty_in,
output longint unsigned clock_number, 
output int command,
output logic [35:0] address,
output bit valid, done
);

string enable;
int f1;
longint counter=0;

typedef struct {
longint clock, command;
logic [35:0] addr;} str;

str inputs;
string filename;

initial begin
	$value$plusargs("%s",filename);
	f1 = $fopen(filename,"r");
	if(f1)begin
		$display("File open");
		while(!$feof(f1)) begin
			if(!full_in) begin
				$fscanf(f1,"%d%d%h", inputs.clock, inputs.command, inputs.addr);
				if(empty_in) begin 
					if(counter < inputs.clock) begin
						@(posedge clock) counter = inputs.clock;
						valid =0;
					end
				end
				else begin
					@(posedge clock) counter = counter + 1;
					valid = 0;
				end
				clock_number = inputs.clock;
				command = inputs.command;
				address = inputs.addr;
				valid = 1;
			
				if($test$plusargs("enable")) begin
					$display($time,,"Counter = %d CPU Clock Cycle = %d Command  = %d Address = %h", counter, inputs.clock, inputs.command, inputs.addr);
				end
			end
			else begin
				@(posedge clock) counter = counter + 1;
				valid =0;
			end
		end
		@(posedge clock) valid = 0; done=1;
		#10 
		if(!$test$plusargs("enable")) begin
			$display("Parsing completed. Debugger turned off.");
		end
		
		$fclose(f1);
		
	end
	else begin
		$display("Unable to find file named %s",filename);
		
	end
	
end

endmodule