/**************************************************************************
***                                                                     *** 
***         Kumar Sai Reddy, Spring, 2024									*** 
***                                                                     *** 
*************************************************************************** 
***  Filename: design.sv    Created by Kumar Sai Reddy,           ***  
***  Version                Version V0p1                                ***  
***  Status                 Tested                                      ***  
***************************************************************************/
`timescale 1ns/10ps


`include "pio_regs.sv"
package bob;
`include "regs.svp"
endpackage : bob

module top();
import bob::* ;
reg clk;
reg reset;
reg [11:0] addr;
reg RW;
reg busy;
reg sel;
reg [31:0] wdata,rdata;

initial begin
    clk=0;
    #5;
    repeat(30000) begin
        #5 clk=1;
        #5 clk=0;
    end
    $display("Ran out of clocks");
    $finish;
end
initial begin
//    $display("I'm alive");
    $dumpfile("rdump.vcd");
    $dumpvars(4,top);
end

typedef struct packed {
    reg [11:0] addr;
    reg [31:0] edata;
} RCHK;

RCHK resetx[]={ {CTRL_OFF,CTRL_RESET},{FSTAT_OFF,FSTAT_RESET},
    {FDEBUG_OFF,FDEBUG_RESET},
    {FLEVEL_OFF,FLEVEL_RESET},{TXF0_OFF,32'h0},{TXF1_OFF,32'h0},
    {TXF2_OFF,32'h0},{TXF3_OFF,32'h0},{IRQ_OFF,32'h0},{IRQ_FORCE_OFF,32'h0},
    {INPUT_SYNC_BYPASS_OFF,32'h0},{DBG_PADOUT_OFF,32'h0},{DBG_PADOE_OFF,32'h0},
    {DBG_CFGINFO_OFF,32'h0020_4010},{SM0_CLKDIV_OFF,32'h0001_0000},
    {SM1_CLKDIV_OFF,32'h0001_0000},{SM2_CLKDIV_OFF,32'h0001_0000},
    {SM3_CLKDIV_OFF,32'h0001_0000},
    {SM0_EXECCTRL_OFF,32'h0001f000},{SM1_EXECCTRL_OFF,32'h0001f000},
    {SM2_EXECCTRL_OFF,32'h0001f000},{SM3_EXECCTRL_OFF,32'h0001f000},
    {SM0_SHIFTCTRL_OFF,32'h000c_0000},{SM1_SHIFTCTRL_OFF,32'h000c_0000},
    {SM2_SHIFTCTRL_OFF,32'h000c_0000},{SM3_SHIFTCTRL_OFF,32'h000c_0000},
    {SM0_ADDR_OFF,32'h0},{SM1_ADDR_OFF,32'h0},{SM2_ADDR_OFF,32'h0},
    {SM3_ADDR_OFF,32'h0},
    {SM0_PINCTRL_OFF,32'h1400_0000},{SM1_PINCTRL_OFF,32'h1400_0000},
    {SM2_PINCTRL_OFF,32'h1400_0000},{SM3_PINCTRL_OFF,32'h1400_0000},
    {INTR_OFF,32'h0},{IRQ0_INTE_OFF,32'h0},{IRQ0_INTF_OFF,32'h0},
    {IRQ0_INTS_OFF,32'h0},{IRQ1_INTE_OFF,32'h0},{IRQ1_INTF_OFF,32'h0},
    {IRQ1_INTS_OFF,32'h0}
};

RCHK rwt[]={ {CTRL_OFF,CTRL_MASK},
    {INPUT_SYNC_BYPASS_OFF,INPUT_SYNC_BYPASS_MASK},
    {SM0_CLKDIV_OFF,SM_CLKDIV_MASK},
    {SM1_CLKDIV_OFF,SM_CLKDIV_MASK},
    {SM2_CLKDIV_OFF,SM_CLKDIV_MASK},
    {SM3_CLKDIV_OFF,SM_CLKDIV_MASK},
    {SM0_EXECCTRL_OFF,SM_EXECCTRL_MASK},
    {SM1_EXECCTRL_OFF,SM_EXECCTRL_MASK},
    {SM2_EXECCTRL_OFF,SM_EXECCTRL_MASK},
    {SM3_EXECCTRL_OFF,SM_EXECCTRL_MASK},
    {SM0_SHIFTCTRL_OFF,SM_SHIFTCTRL_MASK},
    {SM1_SHIFTCTRL_OFF,SM_SHIFTCTRL_MASK},
    {SM2_SHIFTCTRL_OFF,SM_SHIFTCTRL_MASK},
    {SM3_SHIFTCTRL_OFF,SM_SHIFTCTRL_MASK},
    {SM0_INSTR_OFF,SM_INSTR_MASK},
    {SM1_INSTR_OFF,SM_INSTR_MASK},
    {SM2_INSTR_OFF,SM_INSTR_MASK},
    {SM3_INSTR_OFF,SM_INSTR_MASK},
    {SM0_PINCTRL_OFF,SM_PINCTRL_MASK},
    {SM1_PINCTRL_OFF,SM_PINCTRL_MASK},
    {SM2_PINCTRL_OFF,SM_PINCTRL_MASK},
    {SM3_PINCTRL_OFF,SM_PINCTRL_MASK},
    {IRQ0_INTE_OFF,IRQ0_INTE_MASK},
    {IRQ0_INTF_OFF,IRQ0_INTF_MASK},
    {IRQ1_INTE_OFF,IRQ1_INTE_MASK},
    {IRQ1_INTF_OFF,IRQ1_INTF_MASK}

    };

int errcnt=0;
task errit(input string msg);
    $error(msg);
    errcnt+=1;
    if(errcnt>3) begin
        $fatal("Max error count reached");
    end
endtask : errit

task wr1(input RCHK rc);
    reg [31:0] wd,rb;
    wd=$urandom();
    addr=rc.addr;
    sel=1;
    RW=1;
    wdata=wd;
    @(posedge(clk)) #1;
    RW=0;
    wdata=32'h0bad0bad;
    @(posedge(clk));
    rb=rdata;
    if ( (wd&rc.edata) !== rb) begin
        errit($sformatf("addr %h Got %h, expected %h after random write %h",
            rc.addr,rb,wdata&rc.edata,wd));
    end
    sel=0;
    addr=0;
    wdata=32'hdeadbeef;
endtask : wr1

task read1(input RCHK rc);
    addr=rc.addr;
    sel=1;
    RW=0;
    @(posedge(clk)) ;
    #1;
    sel=0;
    addr=12'h190;
    wdata=32'hdeadbeef;
    if (^rdata === 1'bX) begin
        errit($sformatf("addr %h data has X %h",rc.addr,rdata));
    end
    if (rdata !== rc.edata) begin
        errit($sformatf("addr %h reset to %h, expected %h",rc.addr,rdata,rc.edata));
    end

endtask : read1


initial begin : bob
    reset=1;
    repeat(3) @(posedge(clk)) #1;
    reset=0;
    repeat(3) @(posedge(clk)) #1;
    foreach (resetx[ix]) begin
        read1(resetx[ix]);
    end
    repeat(1800) begin
        repeat($urandom_range(3)) @(posedge(clk)) #1;
        read1(resetx[$urandom_range(resetx.size()-1)]);
    end
    foreach (rwt[ix]) begin
        repeat(100) wr1(rwt[ix]);
    end
    repeat(5000) begin
        repeat($urandom_range(2)) @(posedge(clk)) #1;
        wr1(rwt[$urandom_range(rwt.size()-1)]);
    end
    if(errcnt==0) begin
        $display("\n\nWhat a day, it worked\n\n");
        $finish;
    end else begin
        $display("Sad Sad Sad, there were errors");
        $finish;
    end

end : bob

pio_regs pir(clk,reset,sel,RW,addr,wdata,rdata,busy);

endmodule : top
