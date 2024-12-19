/**************************************************************************
***                                                                     *** 
***         Kumar Sai Reddy, Fall, 2023									*** 
***                                                                     *** 
*************************************************************************** 
***  Filename: design.sv    Created by Kumar Sai Reddy, 3/29/2023       ***  
***  Version                Version V0p1                                ***  
***  Status                 Tested                                      ***  
***************************************************************************/
`include "fftw.sv"


/* module tb;

reg Clk, Reset;
reg PushIn, FirstData;
reg signed [16:0] DinR, DinI;
wire PushOut;
wire [47:0] DataOut;

real rr[128]; 

real ii[128];

fft_128 DUT(Clk,Reset,PushIn,FirstData,DinR,DinI,PushOut,DataOut);

always #5 Clk=~Clk;

initial begin
	Clk=1; Reset=1;
	#5;  Reset=0;
	PushIn=1; FirstData=1;
	rr={0.244750,0.013671,-0.110017,-0.010693,-0.003419,-0.005967,0.002896,-0.011262,-0.045426,0.025701,0.013771,-0.003157,0.005464,0.001409,0.012587,-0.037204,0.026674,0.019431,-0.001566,0.002750,-0.020203,0.022236,-0.011085,0.000589,0.014605,0.012903,-0.035030,-0.048598,0.005311,-0.031337,0.013549,0.031256,0.052063,0.044617,-0.010607,-0.001024,-0.025338,-0.023498,-0.049761,0.014436,0.026564,-0.022566,0.018820,-0.008676,0.005780,-0.013315,0.001497,0.029959,0.004576,-0.007781,-0.018512,0.028213,-0.011898,0.001429,0.022842,0.004715,-0.016555,-0.042474,0.030456,-0.024583,0.002678,-0.003100,-0.129841,0.041921,0.213500,0.041921,-0.129841,-0.003100,0.002678,-0.024583,0.030456,-0.042474,-0.016555,0.004715,0.022842,0.001429,-0.011898,0.028213,-0.018512,-0.007781,0.004576,0.029959,0.001497,-0.013315,0.005780,-0.008676,0.018820,-0.022566,0.026564,0.014436,-0.049761,-0.023498,-0.025338,-0.001024,-0.010607,0.044617,0.052063,0.031256,0.013549,-0.031337,0.005311,-0.048598,-0.035030,0.012903,0.014605,0.000589,-0.011085,0.022236,-0.020203,0.002750,-0.001566,0.019431,0.026674,-0.037204,0.012587,0.001409,0.005464,-0.003157,0.013771,0.025701,-0.045426,-0.011262,0.002896,-0.005967,-0.003419,-0.010693,-0.110017,0.013671};
	ii={0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000};
	for(int m=0;m<128;m=m+1) begin
		DinR=(rr[m]==1.00)?16'h7FFF:rr[m]*32768.00;
		DinI=(ii[m]==1.00)?16'h7FFF:ii[m]*32768.00;
		#10; FirstData=0;
	end
	//$finish;
end

initial begin
  #50000; $finish;
end

endmodule  */


module fft_128(
input reg Clk, Reset, 
input reg PushIn, FirstData, 
input reg signed [16:0] DinR, DinI, 
output reg PushOut, 
output reg [47:0] DataOut);

reg [6:0] ADDR, ADDR_n;
reg [3:0] state=0,state_d;
reg [7:0] cnt, cnt_d;

bit sec, sec_d;
bit [7:0] bs, bs_d;
bit StartFFT, StartFFT_d;

parameter real dep[3] = {23'd885,23'd8159,23'd22749};

bit [6:0] k_d,k;
bit [6:0] mul_d,mul;
bit [6:0] lvl_d,lvl;
bit [7:0] mcnt_d,mcnt;
bit [7:0] slice_d,slice;
bit [7:0] subcnt0_d,subcnt1_d,subcnt2_d,subcnt3_d,subcnt0,subcnt1,subcnt2,subcnt3;

reg PushOut_d;
reg [47:0] DataOut_d; 
reg [47:0] DataT; 

typedef reg signed [22:0] TmA;
typedef struct packed {
	TmA re;
	TmA im;
} cmpx;

typedef reg signed [45:0] TmM;
typedef struct packed {
	TmM re;
	TmM im;
} mmpx;

typedef cmpx [127:0] Acmpx;
 cmpx  In;
Acmpx AIn;
Acmpx BIn;
Acmpx CIn;
 cmpx EnR;
  TmM EnG;


always@(posedge Clk or posedge Reset) begin
	if(Reset) begin
		cnt   <=  7'b0;
		sec   <=  1'b0;
	end
	else begin
		cnt   <= #1 cnt_d;
		sec   <= #1 sec_d;
		In.re <= #1 DinR;
		In.im <= #1 DinI;
		AIn[cnt] <= #1 In; 
	end
end

always_comb begin
	cnt_d = cnt;
	sec_d = sec;
	//$display("PushIn=%0d",PushIn);
	if(FirstData&PushIn) begin
		cnt_d = cnt;
		sec_d = 1'b1;
		//$display($time," DinR = %h, In.re = %h, DinI = %h, In.im = %h, cnt = %d, sec = %b", DinR, In.re, DinI, In.im, cnt, sec);
	end
	else if(sec&PushIn) begin
		cnt_d = cnt+1'b1;
		//$display($time," DinR = %h, In.re = %h, DinI = %h, In.im = %h, cnt = %d, sec = %b", DinR, In.re, DinI, In.im, cnt, sec);
		if(cnt==127) begin
			cnt_d = 7'b0;
			sec_d = 1'b0;
			StartFFT_d = 1'b1;
		end
	end
	if(!sec) StartFFT_d = 1'b0;
end

always_comb begin 
	state_d=state;
	k_d=k;
	mul_d=mul;
	lvl_d=lvl;
	mcnt_d=mcnt;
	subcnt0_d =subcnt0;
	subcnt1_d =subcnt1;
	subcnt2_d =subcnt2;
	subcnt3_d =subcnt3;
	slice_d=slice;
	PushOut_d=PushOut;
	DataOut_d=DataOut;
	case(state)
		0: begin
			PushOut_d=1'b0;
			DataOut_d=48'b0;
			if(StartFFT) begin
				BIn = bitrev(AIn);
				slice_d=1;
				state_d=1;
				mcnt_d=1;
				k_d=1<<(6-lvl);
				subcnt0_d=1;
				subcnt1_d=3;
				subcnt2_d=5;
				subcnt3_d=7;
			end
		end 
		1: begin  
			//$display($time," subcnt0=%d, subcnt1=%d, subcnt2=%d, subcnt3=%d",subcnt0, subcnt1, subcnt2, subcnt3);
			//$display($time," slice=%d, mcnt=%d, mul=%d",slice, mcnt,mul);
 			CIn[subcnt0] = cmul(BIn[subcnt0],fftwiddle(k*(mul+0)));
			CIn[subcnt1] = cmul(BIn[subcnt1],fftwiddle(k*(mul+1)));
			CIn[subcnt2] = cmul(BIn[subcnt2],fftwiddle(k*(mul+2)));
			CIn[subcnt3] = cmul(BIn[subcnt3],fftwiddle(k*(mul+3)));
			
			CIn[subcnt0-slice] = csum(CIn[subcnt0],BIn[subcnt0-slice]);
			CIn[subcnt1-slice] = csum(CIn[subcnt1],BIn[subcnt1-slice]);
			CIn[subcnt2-slice] = csum(CIn[subcnt2],BIn[subcnt2-slice]);
			CIn[subcnt3-slice] = csum(CIn[subcnt3],BIn[subcnt3-slice]);
			
			CIn[subcnt0] = csub(BIn[subcnt0-slice],CIn[subcnt0]);
			CIn[subcnt1] = csub(BIn[subcnt1-slice],CIn[subcnt1]);
			CIn[subcnt2] = csub(BIn[subcnt2-slice],CIn[subcnt2]);
			CIn[subcnt3] = csub(BIn[subcnt3-slice],CIn[subcnt3]);
			
			if(slice==1) begin
				subcnt0_d=slice+subcnt3+1;
				subcnt1_d=slice+subcnt3+3;
				subcnt2_d=slice+subcnt3+5;
				subcnt3_d=slice+subcnt3+7;
			end
			else if(slice==2) begin
				subcnt0_d=slice+subcnt3+1;
				subcnt1_d=slice+subcnt3+2;
				subcnt2_d=slice+subcnt3+5;
				subcnt3_d=slice+subcnt3+6;
			end
			else if(slice>2) begin
				if((subcnt3+1)%mcnt==0) begin
					subcnt0_d=slice+subcnt3+1;
					subcnt1_d=slice+subcnt3+2;
					subcnt2_d=slice+subcnt3+3;
					subcnt3_d=slice+subcnt3+4;
				end
				else begin
					subcnt0_d=subcnt3+1;
					subcnt1_d=subcnt3+2;
					subcnt2_d=subcnt3+3;
					subcnt3_d=subcnt3+4;
				end
			end
			
			mul_d=mul+4;
			if(subcnt3>127) begin 
				//Acmpx_display(CIn);
				if(slice==64) begin
					state_d=2;
				end 
				slice_d=slice<<1; 
				mcnt_d=slice<<2; 
				lvl_d=lvl+1;
				k_d=1<<(6-(lvl+1));
				mul_d=0;
				BIn=CIn;
				if(slice==1) begin
					subcnt0_d=2;
					subcnt1_d=3;
					subcnt2_d=6;
					subcnt3_d=7;
				end
				else begin
					subcnt0_d=(slice<<1)+0;
					subcnt1_d=(slice<<1)+1;
					subcnt2_d=(slice<<1)+2;
					subcnt3_d=(slice<<1)+3;
				end
			end
		end
		2: begin 
			DataOut_d=48'b0;
			for(int i=4; i<52; i=i+2) begin
				EnR=ceng(CIn[i],CIn[i]);
				DataT=3;
				for(int j=0; j<3; j=j+1) begin
					if(EnR.re<dep[j]) begin
						DataT=j;
						break;
					end
				end
				DataT=DataT<<(i-4);
				DataOut_d=DataOut_d|DataT;
			end
			//$display("DataOut_d=%h",DataOut_d);
			//$finish;
			state_d=0;
			PushOut_d=1;
		end
	endcase
end

always@(posedge Clk or posedge Reset) begin
	if(Reset) begin
		StartFFT <= 0;
		state <= 0;
		k <= 0;
		mul <= 0;
		lvl <= 0;
		mcnt <= 0;
		slice <= 0;
		subcnt0 <= 0;
		subcnt1 <= 0;
		subcnt2 <= 0;
		subcnt3 <= 0;
		PushOut <= 1'b0;
		DataOut <= 48'b0;
	end
	else begin
		StartFFT <= #1 StartFFT_d;
		state <= #1 state_d;
		k <= #1 k_d;
		mul <= #1 mul_d;
		lvl <= #1 lvl_d;
		mcnt <= #1 mcnt_d;
		slice <= #1 slice_d;
		subcnt0 <= #1 subcnt0_d;
		subcnt1 <= #1 subcnt1_d;
		subcnt2 <= #1 subcnt2_d;
		subcnt3 <= #1 subcnt3_d;
		PushOut <= #1 PushOut_d;
		DataOut <= #1 DataOut_d;
	end
end


function Acmpx bitrev(input Acmpx Ip);
	ADDR=0;
	for(int i=0; i<128; i=i+1) begin
		ADDR_n[0]=ADDR[6];
		ADDR_n[1]=ADDR[5];
		ADDR_n[2]=ADDR[4];
		ADDR_n[3]=ADDR[3];
		ADDR_n[4]=ADDR[2];
		ADDR_n[5]=ADDR[1];
		ADDR_n[6]=ADDR[0];
		ADDR=ADDR+1;
		bitrev[i]=Ip[ADDR_n];
	end
endfunction

function cmpx csum(cmpx A, cmpx B);
	csum.re = A.re+B.re;
	csum.im = A.im+B.im;
endfunction

function cmpx csub(cmpx A, cmpx B);
	csub.re = A.re-B.re;
	csub.im = A.im-B.im;
endfunction

function cmpx cmul(cmpx A, cmpx B);
	mmpx Temp;
	Temp.re = A.re*B.re - A.im*B.im;
	Temp.im = A.im*B.re + A.re*B.im;
	Temp.re = Temp.re>>15;
	Temp.im = Temp.im>>15;
	cmul.re = Temp.re;
	cmul.im = Temp.im;
endfunction

function cmpx ceng(cmpx A, cmpx B);
	mmpx Temp;
	Temp.re = A.re*B.re + A.im*B.im;
	Temp.re = Temp.re>>15;
	ceng.re = Temp.re;
endfunction
	

function Acmpx_display(Acmpx DspA);
	cmpx Dsp; 
	$display("\t\t-----------------\t\t");
	for(int i=0; i<128; i=i+1) begin
		Dsp=DspA[i];
 		$display($time," Dsp.re = %f",Dsp.re/32768.00);
		$display($time," Dsp.im = %f",Dsp.im/32768.00);
		$display("\t\t-----------------\t\t");
	end
endfunction


endmodule