/**************************************************************************
***                                                                     *** 
***         Kumar Sai Reddy, Fall, 2023									*** 
***                                                                     *** 
*************************************************************************** 
***  Filename: design.sv    Created by Kumar Sai Reddy, 3/29/2023       ***  
***  Version                Version V0p1                                ***  
***  Status                 Tested                                      ***  
***************************************************************************/

`include "tw_factor.sv"
import tw_factor_pkg::*;
`define WIDTH 16




module tb;

reg Clk, Reset;
reg PushIn, FirstData;
  reg [`WIDTH-1:0] DinR, DinI;
wire PushOut;
wire [47:0] DataOut;

real rr[128]; 

real ii[128];

fft_128 DUT(Clk,Reset,PushIn,FirstData,DinR,DinI,PushOut,DataOut);

always #5 Clk=~Clk;

initial begin
	Clk=1; Reset=0;
	PushIn=1; FirstData=1;
	rr={0.244750,0.013671,-0.110017,-0.010693,-0.003419,-0.005967,0.002896,-0.011262,-0.045426,0.025701,0.013771,-0.003157,0.005464,0.001409,0.012587,-0.037204,0.026674,0.019431,-0.001566,0.002750,-0.020203,0.022236,-0.011085,0.000589,0.014605,0.012903,-0.035030,-0.048598,0.005311,-0.031337,0.013549,0.031256,0.052063,0.044617,-0.010607,-0.001024,-0.025338,-0.023498,-0.049761,0.014436,0.026564,-0.022566,0.018820,-0.008676,0.005780,-0.013315,0.001497,0.029959,0.004576,-0.007781,-0.018512,0.028213,-0.011898,0.001429,0.022842,0.004715,-0.016555,-0.042474,0.030456,-0.024583,0.002678,-0.003100,-0.129841,0.041921,0.213500,0.041921,-0.129841,-0.003100,0.002678,-0.024583,0.030456,-0.042474,-0.016555,0.004715,0.022842,0.001429,-0.011898,0.028213,-0.018512,-0.007781,0.004576,0.029959,0.001497,-0.013315,0.005780,-0.008676,0.018820,-0.022566,0.026564,0.014436,-0.049761,-0.023498,-0.025338,-0.001024,-0.010607,0.044617,0.052063,0.031256,0.013549,-0.031337,0.005311,-0.048598,-0.035030,0.012903,0.014605,0.000589,-0.011085,0.022236,-0.020203,0.002750,-0.001566,0.019431,0.026674,-0.037204,0.012587,0.001409,0.005464,-0.003157,0.013771,0.025701,-0.045426,-0.011262,0.002896,-0.005967,-0.003419,-0.010693,-0.110017,0.013671};
	ii={0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000};
	for(int m=0;m<128;m=m+1) begin
		DinR=(rr[m]==1.00)?16'h7FFF:rr[m]*32768.00;
		DinI=(ii[m]==1.00)?16'h7FFF:ii[m]*32768.00;
		#10; FirstData=0;
	end
	$finish;
end

initial begin
  #50000; $finish;
end

endmodule





module fft_128(
input Clk, Reset, 
input PushIn, FirstData, 
  input [`WIDTH-1:0] DinR, DinI, 
output PushOut, 
output [47:0] DataOut);

reg [6:0] ADDR;//6:0
reg [6:0] ADDR_n;//6:0
reg [3:0] state;
reg [3:0] ready;

int l;

// Storage Registers for Recieving Input Data //
real xR[128];
real xI[128];

always@(posedge Clk or posedge Reset) begin
	if(FirstData) begin  //** Doubt?? - What after 128 data, again FirstData high?? **//
		ADDR=0;
		if(DinR[15]==0) xR[ADDR]= DinR/32768.00;
		if(DinR[15]==1) begin xR[ADDR]=-DinR/32768.00; xR[ADDR]=-xR[ADDR]; end
		if(DinI[15]==0) xI[ADDR]= DinI/32768.00;
		if(DinI[15]==1) begin xI[ADDR]=-DinI/32768.00; xI[ADDR]=-xI[ADDR]; end
        $display("time=%0d,ADDR=%0d,xR=%f,xI=%f,DinR=%0h,DinI=%0h",$time,ADDR,xR[ADDR],xI[ADDR],DinR,DinI);
		ADDR=ADDR+1;
	end
	else if(!FirstData&(ADDR!=0)) begin
		// Bit Reversal and Storing Data //
		if(DinR[15]==0) xR[ADDR]= DinR/32768.00;
		if(DinR[15]==1) begin xR[ADDR]=-DinR/32768.00; xR[ADDR]=-xR[ADDR]; end
		if(DinI[15]==0) xI[ADDR]= DinI/32768.00;
		if(DinI[15]==1) begin xI[ADDR]=-DinI/32768.00; xI[ADDR]=-xI[ADDR]; end
		$display("time=%0d,ADDR=%0d,xR=%f,xI=%f,DinR=%0h,DinI=%0h",$time,ADDR,xR[ADDR],xI[ADDR],DinR,DinI);
		if(ADDR==127) ready=1; else ready=0;
		ADDR=ADDR+1;
	end
	// pushing state to 0 to begin fft-128 //
	if(ready) state=0;
end

// Storage realisters for Recieving Input Data to Bit Reversal //
real InR[128]; real InI[128];
// Storage realisters for Recieving Bit Reversal Data to Intermediate Data //
real I0R[128]; real I0I[128]; real I1R[128]; real I1I[128]; real I2R[128]; real I2I[128];
real I3R[128]; real I3I[128]; real I4R[128]; real I4I[128]; real I5R[128]; real I5I[128];
real I6R[128]; real I6I[128]; real I7R[128]; real I7I[128];
// Storage realisters for Recieving complex multiplication Data //
real Te1R[128]; real Te1I[128]; real Te2R[128]; real Te2I[128]; real Te3R[128]; real Te3I[128]; 
real Te4R[128]; real Te4I[128]; real Te5R[128]; real Te5I[128]; real Te6R[128]; real Te6I[128]; 
real Te7R[128]; real Te7I[128];

// Complex Multiplication Task //
task comp_mul(input real IR,II,WR,WI, output real TeR,TeI);
	TeR=IR*WR-II*WI;
	TeI=II*WR+IR*WI;
    $display("Inside Comp_Mul time=%0d,IR=%f,II=%f,WR=%f,WI=%f,TeR=%f,TeI=%f",$time,IR,II,WR,WI,TeR,TeI);
endtask

always@(*) begin
	case(state)
		0: begin
			ADDR=0;
			for(int i=0; i<128; i=i+1) begin//128
				// Bit Reversal and Storing Data //
				ADDR_n[0]=ADDR[6];
				ADDR_n[1]=ADDR[5];
				ADDR_n[2]=ADDR[4];
				ADDR_n[3]=ADDR[3];
				ADDR_n[4]=ADDR[2];
				ADDR_n[5]=ADDR[1];
				ADDR_n[6]=ADDR[0];
				InR[i]=xR[ADDR_n];
				InI[i]=xI[ADDR_n];
				$display("State-0 time=%0d,ADDR=%0d,ADDR_n=%0d,xR=%f,xI=%f,InR=%f,InI=%f",$time,ADDR,ADDR_n,xR[ADDR_n],xI[ADDR_n],InR[i],InI[i]);
				ADDR=ADDR+1;
			end
			state=1;
		end
		1: begin
			for(int i=0; i<128; i=i+2) begin//128
				for(int j=i; j<i+2; j=j+1) begin
					I0R[j]=InR[i]+InR[i+1]*((j<i+1)?1:-1);
					I0I[j]=InI[i]+InI[i+1]*((j<i+1)?1:-1);
					$display("State-1 time=%0d,j=%0d,InR[i]=%f,InR[i+1]=%f,InI[i]=%f,InI[i+1]=%f,I0R=%f,I0I=%f",$time,j,InR[i],InR[i+1],InI[i],InI[i+1],I0R[j],I0I[j]);
				end
			end
			state=2;
		end
		2: begin
			for(int i=0; i<128; i=i+4) begin//128
				for(int j=i+2; j<i+4; j=j+1) begin
					comp_mul(I0R[j],I0I[j],W4R[j-(i+2)],W4I[j-(i+2)],Te1R[j-2],Te1I[j-2]);
				end
				l=i;
				for(int k=i; k<i+4; k=k+1) begin
					I1R[k]=I0R[l]+Te1R[l]*((k<i+2)?1:-1);
					I1I[k]=I0I[l]+Te1I[l]*((k<i+2)?1:-1);
					if(l==i+1) l=i; else l=l+1;
					$display("State-2 time=%0d,k=%0d,I0R[l]=%f,I0I[l]=%f,Te1R[l]=%f,Te1I[l]=%f,I1R=%f,I1I=%f",$time,k,I0R[l],I0I[l],Te1R[l],Te1I[l],I1R[k],I1I[k]);
				end
			end
			state=3;
		end
		3: begin
			for(int i=0; i<128; i=i+8) begin//128
				for(int j=i+4; j<i+8; j=j+1) begin
					comp_mul(I1R[j],I1I[j],W8R[j-(i+4)],W8I[j-(i+4)],Te2R[j-4],Te2I[j-4]);
				end
				l=i;
				for(int k=i; k<i+8; k=k+1) begin
					I2R[k]=I1R[l]+Te2R[l]*((k<i+4)?1:-1);
					I2I[k]=I1I[l]+Te2I[l]*((k<i+4)?1:-1);
					if(l==i+3) l=i; else l=l+1;
					$display("State-3 time=%0d,k=%0d,I1R[l]=%f,I1I[l]=%f,Te2R[l]=%f,Te2I[l]=%f,I2R=%f,I2I=%f",$time,k,I1R[l],I1I[l],Te2R[l],Te2I[l],I2R[k],I2I[k]);
				end
			end
			state=4;
		end
		4: begin
			for(int i=0; i<128; i=i+16) begin//128
				for(int j=i+8; j<i+16; j=j+1) begin
					comp_mul(I2R[j],I2I[j],W16R[j-(i+8)],W16I[j-(i+8)],Te3R[j-8],Te3I[j-8]);
				end
				l=i;
				for(int k=i; k<i+16; k=k+1) begin
					I3R[k]=I2R[l]+Te3R[l]*((k<i+8)?1:-1);
					I3I[k]=I2I[l]+Te3I[l]*((k<i+8)?1:-1);
					if(l==i+7) l=i; else l=l+1;
					$display("State-4 time=%0d,k=%0d,I2R[l]=%f,I2I[l]=%f,Te3R[l]=%f,Te3I[l]=%f,I3R=%f,I3I=%f",$time,k,I2R[l],I2I[l],Te3R[l],Te3I[l],I3R[k],I3I[k]);
				end
			end
			state=5;
		end
		5: begin
			for(int i=0; i<128; i=i+32) begin//128
				for(int j=i+16; j<i+32; j=j+1) begin
					comp_mul(I3R[j],I3I[j],W32R[j-(i+16)],W32I[j-(i+16)],Te4R[j-16],Te4I[j-16]);
				end
				l=i;
				for(int k=i; k<i+32; k=k+1) begin
					I4R[k]=I3R[l]+Te4R[l]*((k<i+16)?1:-1);
					I4I[k]=I3I[l]+Te4I[l]*((k<i+16)?1:-1);
					if(l==i+15) l=i; else l=l+1;
					$display("State-5 time=%0d,k=%0d,I3R[l]=%f,I3I[l]=%f,Te4R[l]=%f,Te4I[l]=%f,I4R=%f,I4I=%f",$time,k,I3R[l],I3I[l],Te4R[l],Te4I[l],I4R[k],I4I[k]);
				end
			end
			state=6;
		end
		6: begin
			for(int i=0; i<128; i=i+64) begin//128
				for(int j=i+32; j<i+64; j=j+1) begin
					comp_mul(I4R[j],I4I[j],W64R[j-(i+32)],W64I[j-(i+32)],Te5R[j-32],Te5I[j-32]);
				end
				l=i;
				for(int k=i; k<i+64; k=k+1) begin
					I5R[k]=I4R[l]+Te5R[l]*((k<i+32)?1:-1);
					I5I[k]=I4I[l]+Te5I[l]*((k<i+32)?1:-1);
					if(l==i+31) l=i; else l=l+1;
					$display("State-6 time=%0d,k=%0d,I4R[l]=%f,I4I[l]=%f,Te5R[l]=%f,Te5I[l]=%f,I5R=%f,I5I=%f",$time,k,I4R[l],I4I[l],Te5R[l],Te5I[l],I5R[k],I5I[k]);
				end
			end
			state=7;
		end
		7: begin
			for(int i=0; i<128; i=i+128) begin//128
				for(int j=i+64; j<i+128; j=j+1) begin
					comp_mul(I5R[j],I5I[j],W128R[j-(i+64)],W128I[j-(i+64)],Te6R[j-64],Te6I[j-64]);
				end
				l=i;
				for(int k=i; k<i+128; k=k+1) begin
					I6R[k]=I5R[l]+Te6R[l]*((k<i+64)?1:-1);
					I6I[k]=I5I[l]+Te6I[l]*((k<i+64)?1:-1);
					if(l==i+63) l=i; else l=l+1;
					$display("State-7 time=%0d,k=%0d,I5R[l]=%f,I5I[l]=%f,Te6R[l]=%f,Te6I[l]=%f,I6R=%f,I6I=%f",$time,k,I5R[l],I5I[l],Te6R[l],Te6I[l],I6R[k],I6I[k]);
				end
			end
			state=10;
		end
		default: state=8;
	endcase
end

endmodule