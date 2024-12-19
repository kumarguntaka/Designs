
`uvm_analysis_imp_decl(_request)
`uvm_analysis_imp_decl(_request1)

class our_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(our_scoreboard)
  uvm_analysis_imp_request#(seq_item, our_scoreboard) request_export_m;
  uvm_analysis_imp_request1#(seq_item, our_scoreboard) request1_export_m;
 
  seq_item exp_trans[$];
  seq_item act_trans[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   
    request_export_m = new("request_export_m", this);
    request1_export_m = new("request1_export_m", this);
  endfunction : build_phase 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase 


//driving output
  function void write_request1(seq_item trans);
    `uvm_info("ALU_SB", "Received DUT Output transaction", UVM_NONE)
    trans.print();
    seq_item.push_back(trans); 
  endfunction : write_legacy

//driving expected output
  function void write_request(seq_item trans);
    `uvm_info("ALU_SB", "Received DUT input transaction", UVM_NONE)
    trans.print();
    case(trans.op)
      ADD: begin
        trans.result = ADD(trans.a,trans.b);
        end

    endcase
    exp_trans_q_m.push_back(trans);
  endfunction : write_request

  virtual task run_phase(uvm_phase phase);
    fork
      compare_trans();
    join_none
  endtask : run_phase

  task compare_trans();
    alu_trans act_trans;
    alu_trans exp_trans;
    forever begin
      wait((exp_trans_q_m.size() > 0) && (act_trans_q_m.size() > 0));
      act_trans = act_trans_q_m.pop_front();
      exp_trans = exp_trans_q_m.pop_front();

      // TODO: act_trans.compare(exp_trans));;
      
      if(act_trans.opcode_m != exp_trans.opcode_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched opcode, expected = 0x%0x, actual = 0x%0x", exp_trans.opcode_m, act_trans.opcode_m))
      end
      if(act_trans.operand1_m != exp_trans.operand1_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched operand1, expected = 0x%0x, actual = 0x%0x", exp_trans.operand1_m, act_trans.operand1_m))
      end
      if(act_trans.operand2_m != exp_trans.operand2_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched operand2, expected = 0x%0x, actual = 0x%0x", exp_trans.operand2_m, act_trans.operand2_m))
      end
      if(act_trans.result_m != exp_trans.result_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched result, expected = 0x%0x, actual = 0x%0x", exp_trans.result_m, act_trans.result_m))
      end
      if(act_trans.status_m != exp_trans.status_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched status, expected = 0x%0x, actual = 0x%0x", exp_trans.status_m, act_trans.status_m))
      end
    end
  endtask : compare_trans

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if(act_trans_q_m.size()) begin
      `uvm_error("ALU_SB", $psprintf("The actual trans queue hasn't completed %0d", act_trans_q_m.size()))
    end
    if(exp_trans_q_m.size()) begin
      `uvm_error("ALU_SB", $psprintf("The expected trans queue hasn't completed %0d", exp_trans_q_m.size()))
    end
  endfunction : report_phase


// tasks for caluclating arithmatic logics 

typedef struct packed { bit s; bit[3:0] e; bit[2:0]m;} A_S;
typedef struct packed { bit s; bit[3:0] e; bit[2:0]m;} A_n_S;

task ADD ( input A,B);

if(A[6:0] ==0 && B[6:0]==0)
	result=0;
else if(A[6:0] ==0 && (B.e!=4'b1111 || B.e!=4'b0000))
	result=B;
else if((A.e!=4'b1111 || A.e!=4'b0000) && B[6:0]==0)
	result=A;
else if(A[6:0]!=0 && B[6:0]!=0) begin

	result= 
	(((A.s==1) && (A.e==4'b1111) && (A.m==3'b000)) || ((B.s==1) && (B.e==4'b1111) && (B.m==3'b000)))
	?8'b11111_000: (((A.s==0) && (A.e==4'b1111) && (A.m==3'b000)) || ((B.s==0) && (B.e==4'b1111) && (B.m==3'b000)))
	?8'b01111_000: (((A.e==4'b1111) && (A.m!=3'b000)) || ((B.e==4'b1111) && (B.m!=3'b000))) 
	?8'b11111_010 : ((A.s^B.s) && (A.m == B.m) && ( A.e == B.e)) 
	?8'b00000000:((A.e == 0 && A.m!=0) || (B.e == 0 && B.m!=0 ))
	?8'b00000_111: ((A.e>B.e)&&((A.e-B.e)>4))?A:((A.e<B.e)&&((A.e-B.e)<-4)) ? B:ADD_new(A,B);

end
endtask


// NORMAL ADD FUNCTION
function bit [7:0] ADD_new ( input A_S A_n,B_n);

bit sc;
bit [3:0] ec;
bit [8:0] ma,mb;
bit [8:0] mc_unr;
bit [2:0] mcr;
bit [4:0] mcxr;
bit[7:0]add_result;
bit trig;

int i;
int j;



ma={1'b0,1'b1,A_n.m,4'b0000};
mb={1'b0,1'b1,B_n.m,4'b0000};

if ( A_n.e==B_n.e) begin
	ec=A_n.e;
end
else if( A_n.e>B_n.e ) begin
	ec=A_n.e;
	mb=mb>>(A_n.e-B_n.e);
end
else if (B_n.e>A_n.e )
begin
	ec=B_n.e;
	ma=ma>>(B_n.e-A_n.e);
end

case({A_n.s,B_n.s})

2'b00,2'b11 : begin
                sc=A_n.s;
                mc_unr = ma + mb;
            end
			
2'b01,2'b10 : begin
            if( ma>mb) begin
                mc_unr=ma-mb;
                sc=A_n.s;
                end
            else if ( mb>ma ) begin
                mc_unr= mb-ma;
                sc=B_n.s;
            end
            end
endcase

if( mc_unr[8] == 1) begin  
    
// mc_unr={1'b1,mc_unr[7:0]}; 
    ec+=1;  
	 if(( mc_unr[4]==1||  mc_unr[4]==0) && (mc_unr[3:0]==4'b0000))
	     
		mcr=mc_unr[7:5];
	if( (mc_unr[4]==1) && (|(mc_unr[3:0]))) begin
        mcxr= mc_unr[8:5]+1;
        if(mcxr[4]==1) begin
            mcr=mcxr[3:1];
            ec+=1;
        end 
        else if(mcxr[4]==0)
            mcr=mcxr[2:0];
        end 
    end       
else if(mc_unr[8]==0 && mc_unr[7]==1) begin 
	
    mc_unr={mc_unr[7:0],1'b0}; 
    if((mc_unr[4]==1|| mc_unr[4]==0) && (mc_unr[3:1]==3'b000))
        mcr=mc_unr[7:5];
	else if( (mc_unr[4]==1) && (|(mc_unr[3:1]))) begin
        mcxr= mc_unr[8:5]+1;
        if(mcxr[4]==1) begin
            mcr=mcxr[3:1];
            ec+=1;
        end 
        else if(mcxr[4]==0)
            mcr=mcxr[2:0];
        end  
    end 
else if (mc_unr[8]==0 && mc_unr[7]==0) begin 
    j=7;
	
	
	for (i=2;i<7;i++) begin 
		trig=1;
        j-=1;
		if(mc_unr[j]==1)
			break;
        end 
        mc_unr=mc_unr<<i;
        ec=ec-(i-1);
		
        if((mc_unr[4]==1|| mc_unr[4]==0) && (mc_unr[3:1]==3'b000))
            mcr=mc_unr[7:5];
        else if( (mc_unr[4]==1) && (|(mc_unr[3:1]))) begin
                mcxr= mc_unr[8:5]+1;
                if(mcxr[3]==1) begin
                 mcr=mcxr[3:1];
                 ec+=1;
                    end 
                else if(mcxr[4]==0)
                     mcr=mcxr[2:0];
    end  
end 
            
			
if(ec>=15) begin
	add_result=sc?8'b11111_000:8'b01111_000;
	return add_result;
end
else if (ec<=0 && mcr!=0) begin
	add_result=8'b00000_111;
    return add_result;
end
else return {sc,ec,mcr};

endfunction: add_task

//mul task
task MUL ( input A_S A,B);

if ( A[6:0]==0 && B[6:0]==0 )
	result=0;
else if(A[6:0]==0 && B[6:0]!=0)
	result=0;
else if (A[6:0]!=0 && B[6:0]==0)
	result=0;
else if (A[6:0]!=0 && B[6:0]!=0) begin

	result= 
	(((A.s==1) && (A.e==4'b1111) && (A.m==3'b000)) || ((B.s==1) && (B.e==4'b1111) && (B.m==3'b000)))
	? NINF: (((A.s==0) && (A.e==4'b1111) && (A.m==3'b000)) || ((B.s==0) && (B.e==4'b1111) && (B.m==3'b000)))
	? PINF : (((A.e==4'b1111) && (A.m!=3'b000)) || ((B.e==4'b1111) && (B.m!=3'b000)) ) 
	?Nan :((A.e == 0 && A.m!=0) || (B.e == 0 && B.m!=0 ))
	?Denorm:MUL_new(A,B);
end
endtask



 // Regular Multiplication
  function bit[7:0] MUL_new ( input A_S A_n,B_n );

bit sc;
bit [3:0] ec;
bit [3:0] ma,mb;
bit [7:0] mcunr;
bit [2:0] mcr;
bit [4:0]mcxr;
bit[7:0]mul_result;

// CONCATENATION OF LEADING 1 IN THE MANTISSA
ma={1'b1,A_n.m};
mb={1'b1,B_n.m};

sc=A_n.s^B_n.s;

ec=(A_n.e+B_n.e)-7;

if(ec>=15) begin
mul_result=sc?NINF:PINF;
return mul_result;
end
else if (ec<=0 && mcr!=0)  begin 
          mul_result=Denorm;
         return mul_result;
                 end 
else mcunr= ma*mb;


if (mcunr[7] == 1) begin
        mcunr=mcunr>>1; 
        ec+=1;
        if ( (mcunr[2]==0) || (mcunr[2]==1 && mcunr[1:0]==2'b00) ) begin  
      mcr = mcunr[5:3];
         
          end
        else if ( (mcunr[2] ==1) && ((mcunr[1:0]==2'b1x) || (mcunr[1:0]==2'b01)) ) begin
                    mcxr=mcunr[6:3]+1;
                    if(mcxr[4]==1) begin
                         mcr=mcxr[3:1];
                         ec+=1;
                         end 
                     else if(mcxr[4]==0)
                             mcr=mcxr[2:0];
                    end
                     end
else if (mcunr[7]==0) begin 
          
       if ( (mcunr[2]==0) || (mcunr[2]==1 && mcunr[1:0]==2'b00) ) begin  
                 mcr = mcunr[5:3];
       
          end
       else if ( (mcunr[2] ==1) && ((mcunr[1:0]==2'b1x) || (mcunr[1:0]==2'b01)) ) begin
                    mcxr=mcunr[6:3]+1;
                    if(mcxr[4]==1) begin
                         mcr=mcxr[3:1];
                         ec+=1;
                         end 
                     else if(mcxr[4]==0)
                             mcr=mcxr[2:0];
                    end
                     end

if(ec>=15) begin
mul_result=sc?NINF:PINF;
return mul_result;
end
    else if (ec<=0 && mcr!=0) begin
       mul_result=Denorm;
      return mul_result;
    end 
else return {sc,ec,mcr};
    
endfunction

// sub



endclass : alu_scoreboard
`endif