/**************************************************************************
***                                                                     *** 
***         Kumar Sai Reddy, Spring, 2024									*** 
***                                                                     *** 
*************************************************************************** 
***  Filename: design.sv    Created by Kumar Sai Reddy,           ***  
***  Version                Version V0p1                                ***  
***  Status                 Tested                                      ***  
***************************************************************************/

package pio_reg_pkg;

	//Parameter declaration
	
	parameter int ADDR_WIDTH = 12;
	parameter int DATA_WIDTH = 32;

	////////////////////////////////
	// Typedefs for RW registers //
	///////////////////////////////
	
	typedef struct packed {
		logic [31:0] CTRL_ADDR;
		logic [31:0] CTRL_DATA;
		} PIO_CTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] INPUT_SYNC_BYPASS_ADDR;
		logic [31:0] INPUT_SYNC_BYPASS_DATA;
		} PIO_INPUT_SYNC_BYPASS_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM0_CLKDIV_ADDR;
		logic [31:0] SM0_CLKDIV_DATA;
		} PIO_SM0_CLKDIV_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM1_CLKDIV_ADDR;
		logic [31:0] SM1_CLKDIV_DATA;
		} PIO_SM1_CLKDIV_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM2_CLKDIV_ADDR;
		logic [31:0] SM2_CLKDIV_DATA;
		} PIO_SM2_CLKDIV_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM2_CLKDIV_ADDR;
		logic [31:0] SM2_CLKDIV_DATA;
		} PIO_SM3_CLKDIV_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM0_EXECCTRL_ADDR;
		logic [31:0] SM0_EXECCTRL_DATA;
		} PIO_SM0_EXECCTRL_REG_RW;
	
	typedef struct packed {
		logic [31:0] SM1_EXECCTRL_ADDR;
		logic [31:0] SM1_EXECCTRL_DATA;
		} PIO_SM1_EXECCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM2_EXECCTRL_ADDR;
		logic [31:0] SM2_EXECCTRL_DATA;
		} PIO_SM2_EXECCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM3_EXECCTRL_ADDR;
		logic [31:0] SM3_EXECCTRL_DATA;
		} PIO_SM3_EXECCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM0_SHIFTCTRL_ADDR;
		logic [31:0] SM0_SHIFTCTRL_DATA;
		} PIO_SM0_SHIFTCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM1_SHIFTCTRL_ADDR;
		logic [31:0] SM1_SHIFTCTRL_DATA;
		} PIO_SM1_SHIFTCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM2_SHIFTCTRL_ADDR;
		logic [31:0] SM2_SHIFTCTRL_DATA;
		} PIO_SM2_SHIFTCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM3_SHIFTCTRL_ADDR;
		logic [31:0] SM3_SHIFTCTRL_DATA;
		} PIO_SM3_SHIFTCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM0_INSTR_ADDR;
		logic [31:0] SM0_INSTR_DATA;
		} PIO_SM0_INSTR_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM1_INSTR_ADDR;
		logic [31:0] SM1_INSTR_DATA;
		} PIO_SM1_INSTR_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM2_INSTR_ADDR;
		logic [31:0] SM2_INSTR_DATA;
		} PIO_SM2_INSTR_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM3_INSTR_ADDR;
		logic [31:0] SM3_INSTR_DATA;
		} PIO_SM3_INSTR_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM0_PINCTRL_ADDR;
		logic [31:0] SM0_PINCTRL_DATA;
		} PIO_SM0_PINCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM1_PINCTRL_ADDR;
		logic [31:0] SM1_PINCTRL_DATA;
		} PIO_SM1_PINCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM2_PINCTRL_ADDR;
		logic [31:0] SM2_PINCTRL_DATA;
		} PIO_SM2_PINCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] SM3_PINCTRL_ADDR;
		logic [31:0] SM3_PINCTRL_DATA;
		} PIO_SM3_PINCTRL_REG_RW;
		
	typedef struct packed {
		logic [31:0] IRQ0_INTE_ADDR;
		logic [31:0] IRQ0_INTE_DATA;
		} PIO_IRQ0_INTE_REG_RW;
		
	typedef struct packed {
		logic [31:0] IRQ0_INTF_ADDR;
		logic [31:0] IRQ0_INTF_DATA;
		} PIO_IRQ0_INTF_REG_RW;
		
	typedef struct packed {
		logic [31:0] IRQ1_INTE_ADDR;
		logic [31:0] IRQ1_INTE_DATA;
		} PIO_IRQ1_INTE_REG_RW;
		
	typedef struct packed {
		logic [31:0] IRQ1_INTF_ADDR;
		logic [31:0] IRQ1_INTF_DATA;
		} PIO_IRQ1_INTF_REG_RW;
	
	////////////////////////////////
	// Typedefs for RO registers //
	///////////////////////////////		

	typedef struct packed {
		logic [31:0] FSTAT_ADDR;
		logic [31:0] FSTAT_DATA;
		} PIO_FSTAT_REG_RD;	
	
	////////////////////////////////
	// Typedefs for  WR registers //
	////////////////////////////////	
	
	typedef struct packed {
		logic [31:0] CTRL_ADDR;
		logic [31:0] CTRL_DATA;
		} PIO_CTRL_REG_WR;
		
	////////////////////////////////
	
	// RW register type
	typedef struct packed{
		PIO_CTRL_REG_RW 				CTRL_REG;
		PIO_INPUT_SYNC_BYPASS_REG_RW	NPUT_SYNC_BYPASS;
		PIO_SM0_CLKDIV_REG_RW			SM0_CLKDIV;
		PIO_SM1_CLKDIV_REG_RW           SM1_CLKDIV;
		PIO_SM2_CLKDIV_REG_RW           SM2_CLKDIV;
		PIO_SM3_CLKDIV_REG_RW           SM3_CLKDIV;
		PIO_SM0_EXECCTRL_REG_RW         SM0_EXECCTRL;
		PIO_SM1_EXECCTRL_REG_RW         SM1_EXECCTRL;
		PIO_SM2_EXECCTRL_REG_RW         SM2_EXECCTRL;
		PIO_SM3_EXECCTRL_REG_RW         SM3_EXECCTRL;
		PIO_SM0_SHIFTCTRL_REG_RW        SM0_SHIFTCTRL;
		PIO_SM1_SHIFTCTRL_REG_RW        SM1_SHIFTCTRL;
		PIO_SM2_SHIFTCTRL_REG_RW        SM2_SHIFTCTRL;
		PIO_SM3_SHIFTCTRL_REG_RW        SM3_SHIFTCTRL;
		PIO_SM0_INSTR_REG_RW            SM0_INSTR;
		PIO_SM1_INSTR_REG_RW            SM1_INSTR;
		PIO_SM2_INSTR_REG_RW            SM2_INSTR;
		PIO_SM3_INSTR_REG_RW            SM3_INSTR;
		PIO_SM0_PINCTRL_REG_RW          SM0_PINCTRL;
		PIO_SM1_PINCTRL_REG_RW          SM1_PINCTRL;
		PIO_SM2_PINCTRL_REG_RW          SM2_PINCTRL;
		PIO_SM3_PINCTRL_REG_RW          SM3_PINCTRL;
		PIO_IRQ0_INTE_REG_RW            IRQ0_INTE;
		PIO_IRQ0_INTF_REG_RW            IRQ0_INTF;
		PIO_IRQ1_INTE_REG_RW            IRQ1_INTE;
		PIO_IRQ1_INTF_REG_RW            IRQ1_INTF;
	} PIO_REG_RW;
	
	//PIO Register Offsets
	parameter logic [ADDR_WIDTH-1:0] PIO_CTRL_OFF 				= 12'h 000;
	parameter logic [ADDR_WIDTH-1:0] PIO_FSTAT_OFF 				= 12'h 004;
	parameter logic [ADDR_WIDTH-1:0] PIO_FDEBUG_OFF 			= 12'h 008;
	parameter logic [ADDR_WIDTH-1:0] PIO_FLEVEL_OFF 			= 12'h 00C;
	parameter logic [ADDR_WIDTH-1:0] PIO_TXF0_OFF 				= 12'h 010;
	parameter logic [ADDR_WIDTH-1:0] PIO_TXF1_OFF 				= 12'h 014;
	parameter logic [ADDR_WIDTH-1:0] PIO_TXF2_OFF 				= 12'h 018;
	parameter logic [ADDR_WIDTH-1:0] PIO_TXF3_OFF 				= 12'h 01C;
	parameter logic [ADDR_WIDTH-1:0] PIO_RXF0_OFF 				= 12'h 020;
	parameter logic [ADDR_WIDTH-1:0] PIO_RXF1_OFF 				= 12'h 024;
	parameter logic [ADDR_WIDTH-1:0] PIO_RXF2_OFF 				= 12'h 028;
	parameter logic [ADDR_WIDTH-1:0] PIO_RXF3_OFF 				= 12'h 02C;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ_OFF 				= 12'h 030;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ_FORCE_OFF 			= 12'h 034;
	parameter logic [ADDR_WIDTH-1:0] PIO_INPUT_SYNC_BYPASS_OFF 	= 12'h 038;
	parameter logic [ADDR_WIDTH-1:0] PIO_DBG_PADOUT_OFF 		= 12'h 03C;
	parameter logic [ADDR_WIDTH-1:0] PIO_DBG_PADOE_OFF 			= 12'h 040;
	parameter logic [ADDR_WIDTH-1:0] PIO_DBG_CFGINFO_OFF 		= 12'h 044;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM0_OFF 		= 12'h 048;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM1_OFF 		= 12'h 04C;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM2_OFF 		= 12'h 050;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM3_OFF 		= 12'h 054;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM4_OFF 		= 12'h 058;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM5_OFF 		= 12'h 05C;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM6_OFF 		= 12'h 060;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM7_OFF 		= 12'h 064;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM8_OFF 		= 12'h 068;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM9_OFF 		= 12'h 06C;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM10_OFF 		= 12'h 070;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM11_OFF 		= 12'h 074;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM12_OFF 		= 12'h 078;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM13_OFF 		= 12'h 07C;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM14_OFF 		= 12'h 080;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM15_OFF 		= 12'h 084;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM16_OFF 		= 12'h 088;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM17_OFF 		= 12'h 08C;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM18_OFF 		= 12'h 090;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM19_OFF 		= 12'h 094;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM20_OFF 		= 12'h 098;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM21_OFF 		= 12'h 09C;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM22_OFF 		= 12'h 0A0;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM23_OFF 		= 12'h 0A4;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM24_OFF 		= 12'h 0A8;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM25_OFF 		= 12'h 0AC;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM26_OFF 		= 12'h 0B0;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM27_OFF 		= 12'h 0B4;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM28_OFF 		= 12'h 0B8;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM29_OFF 		= 12'h 0BC;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM30_OFF 		= 12'h 0C0;
	parameter logic [ADDR_WIDTH-1:0] PIO_INSTR_MEM31_OFF 		= 12'h 0C4;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM0_CLKDIV_OFF 		= 12'h 0C8;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM0_EXECCTRL_OFF 		= 12'h 0CC;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM0_SHIFTCTRL_OFF 		= 12'h 0D0;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM0_ADDR_OFF 			= 12'h 0D4;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM0_INSTR_OFF 			= 12'h 0D8;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM0_PINCTRL_OFF 		= 12'h 0DC;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM1_CLKDIV_OFF 		= 12'h 0E0;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM1_EXECCTRL_OFF 		= 12'h 0E4;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM1_SHIFTCTRL_OFF 		= 12'h 0E8;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM1_ADDR_OFF 			= 12'h 0EC;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM1_INSTR_OFF 			= 12'h 0F0;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM1_PINCTRL_OFF 		= 12'h 0F4;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM2_CLKDIV_OFF 		= 12'h 0F8;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM2_EXECCTRL_OFF 		= 12'h 0FC;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM2_SHIFTCTRL_OFF 		= 12'h 100;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM2_ADDR_OFF 			= 12'h 104;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM2_INSTR_OFF 			= 12'h 108;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM2_PINCTRL_OFF 		= 12'h 10C;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM3_CLKDIV_OFF 		= 12'h 110;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM3_EXECCTRL_OFF 		= 12'h 114;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM3_SHIFTCTRL_OFF		= 12'h 118;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM3_ADDR_OFF 			= 12'h 11C;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM3_INSTR_OFF 			= 12'h 120;
	parameter logic [ADDR_WIDTH-1:0] PIO_SM3_PINCTRL_OFF 		= 12'h 124;
	parameter logic [ADDR_WIDTH-1:0] PIO_INTR_OFF 				= 12'h 128;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ0_INTE_OFF 			= 12'h 12C;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ0_INTF_OFF 			= 12'h 130;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ0_INTS_OFF 			= 12'h 134;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ1_INTE_OFF 			= 12'h 138;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ1_INTF_OFF 			= 12'h 13C;
	parameter logic [ADDR_WIDTH-1:0] PIO_IRQ1_INTS_OFF 			= 12'h 140;
	
	//Reset values for Registers
	parameter logic [DATA_WIDTH-1:0] PIO_CTRL_RESET 				= 32'h 0000_0000; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_FSTAT_RESET 				= 32'h 0F00_0F00; //-F-0_-F-0
	parameter logic [DATA_WIDTH-1:0] PIO_FDEBUG_RESET 				= 32'h 0000_0000; //-0-0_-0-0
	parameter logic [DATA_WIDTH-1:0] PIO_FLEVEL_RESET 				= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF0_RESET 				= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF1_RESET 				= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF2_RESET 				= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF3_RESET 				= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_RXF0_RESET 				= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_RXF1_RESET 				= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_RXF2_RESET 				= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_RXF3_RESET 				= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ_RESET 					= 32'h 0000_0000; //----_--00
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ_FORCE_RESET 			= 32'h 0000_0000; //----_--00
	parameter logic [DATA_WIDTH-1:0] PIO_INPUT_SYNC_BYPASS_RESET 	= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_DBG_PADOUT_RESET 			= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_DBG_PADOE_RESET 			= 32'h 0000_0000; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_DBG_CFGINFO_RESET 			= 32'h 0020_4010; //----_---- //This Value is taken from Prof. Morris Jones TB(top.sv)
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM0_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM1_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM2_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM3_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM4_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM5_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM6_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM7_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM8_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM9_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM10_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM11_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM12_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM13_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM14_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM15_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM16_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM17_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM18_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM19_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM20_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM21_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM22_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM23_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM24_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM25_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM26_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM27_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM28_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM29_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM30_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM31_RESET 			= 32'h 0000_0000; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_CLKDIV_RESET 			= 32'h 0001_0000; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_EXECCTRL_RESET 		= 32'h 0001_F000; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_SHIFTCTRL_RESET 		= 32'h 000C_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_ADDR_RESET 			= 32'h 0000_0000; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_INSTR_RESET 			= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_PINCTRL_RESET 			= 32'h 1400_0000; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_CLKDIV_RESET 			= 32'h 0001_0000; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_EXECCTRL_RESET 		= 32'h 0001_F000; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_SHIFTCTRL_RESET 		= 32'h 000C_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_ADDR_RESET 			= 32'h 0000_0000; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_INSTR_RESET 			= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_PINCTRL_RESET 			= 32'h 1400_0000; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_CLKDIV_RESET 			= 32'h 0001_0000; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_EXECCTRL_RESET 		= 32'h 0001_F000; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_SHIFTCTRL_RESET 		= 32'h 000C_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_ADDR_RESET 			= 32'h 0000_0000; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_INSTR_RESET 			= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_PINCTRL_RESET 			= 32'h 1400_0000; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_CLKDIV_RESET 			= 32'h 0001_0000; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_EXECCTRL_RESET 		= 32'h 0001_F000; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_SHIFTCTRL_RESET		= 32'h 000C_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_ADDR_RESET 			= 32'h 0000_0000; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_INSTR_RESET 			= 32'h 0000_0000; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_PINCTRL_RESET 			= 32'h 1400_0000; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INTR_RESET 				= 32'h 0000_0000; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ0_INTE_RESET 			= 32'h 0000_0000; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ0_INTF_RESET 			= 32'h 0000_0000; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ0_INTS_RESET 			= 32'h 0000_0000; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ1_INTE_RESET 			= 32'h 0000_0000; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ1_INTF_RESET 			= 32'h 0000_0000; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ1_INTS_RESET 			= 32'h 0000_0000; //----_-000
	
	//Mask values for Registers
	parameter logic [DATA_WIDTH-1:0] PIO_CTRL_MASK 				= 32'h 0000_0FFF; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_FSTAT_MASK 			= 32'h 0F0F_0F0F; //-F-0_-F-0
	parameter logic [DATA_WIDTH-1:0] PIO_FDEBUG_MASK 			= 32'h 0F0F_0F0F; //-0-0_-0-0
	parameter logic [DATA_WIDTH-1:0] PIO_FLEVEL_MASK 			= 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF0_MASK 				= 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF1_MASK 				= 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF2_MASK 				= 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_TXF3_MASK 				= 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_RXF0_MASK 				= 32'h FFFF_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_RXF1_MASK 				= 32'h FFFF_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_RXF2_MASK 				= 32'h FFFF_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_RXF3_MASK 				= 32'h FFFF_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ_MASK 				= 32'h 0000_00FF; //----_--00
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ_FORCE_MASK 		= 32'h 0000_00FF; //----_--00
	parameter logic [DATA_WIDTH-1:0] PIO_INPUT_SYNC_BYPASS_MASK = 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_DBG_PADOUT_MASK 		= 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_DBG_PADOE_MASK 		= 32'h FFFF_FFFF; //0000_0000
	parameter logic [DATA_WIDTH-1:0] PIO_DBG_CFGINFO_MASK 		= 32'h 003F_0F3F; //----_---- //This Value is taken from Prof. Morris Jones TB(top.sv)
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM0_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM1_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM2_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM3_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM4_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM5_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM6_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM7_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM8_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM9_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM10_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM11_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM12_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM13_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM14_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM15_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM16_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM17_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM18_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM19_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM20_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM21_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM22_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM23_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM24_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM25_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM26_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM27_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM28_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM29_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM30_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INSTR_MEM31_MASK 		= 32'h 0000_FFFF; //----_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_CLKDIV_MASK 		= 32'h FFFF_FF00; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_EXECCTRL_MASK 		= 32'h FFFF_FF9F; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_SHIFTCTRL_MASK 	= 32'h FFFF_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_ADDR_MASK 			= 32'h 0000_001F; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_INSTR_MASK 		= 32'h 0000_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM0_PINCTRL_MASK 		= 32'h FFFF_FFFF; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_CLKDIV_MASK 		= 32'h FFFF_FF00; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_EXECCTRL_MASK 		= 32'h FFFF_FF9F; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_SHIFTCTRL_MASK 	= 32'h FFFF_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_ADDR_MASK 			= 32'h 0000_001F; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_INSTR_MASK 		= 32'h 0000_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM1_PINCTRL_MASK 		= 32'h FFFF_FFFF; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_CLKDIV_MASK 		= 32'h FFFF_FF00; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_EXECCTRL_MASK 		= 32'h FFFF_FF9F; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_SHIFTCTRL_MASK 	= 32'h FFFF_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_ADDR_MASK 			= 32'h 0000_001F; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_INSTR_MASK 		= 32'h 0000_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM2_PINCTRL_MASK 		= 32'h FFFF_FFFF; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_CLKDIV_MASK 		= 32'h FFFF_FF00; //0001_00--
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_EXECCTRL_MASK 		= 32'h FFFF_FF9F; //0001_F0(0--0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_SHIFTCTRL_MASK		= 32'h FFFF_0000; //000C_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_ADDR_MASK 			= 32'h 0000_001F; //----_--(---0)0
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_INSTR_MASK 		= 32'h 0000_FFFF; //----_----
	parameter logic [DATA_WIDTH-1:0] PIO_SM3_PINCTRL_MASK 		= 32'h FFFF_FFFF; //1400_0000
	parameter logic [DATA_WIDTH-1:0] PIO_INTR_MASK 				= 32'h 0000_0FFF; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ0_INTE_MASK 		= 32'h 0000_0FFF; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ0_INTF_MASK 		= 32'h 0000_0FFF; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ0_INTS_MASK 		= 32'h 0000_0FFF; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ1_INTE_MASK 		= 32'h 0000_0FFF; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ1_INTF_MASK 		= 32'h 0000_0FFF; //----_-000
	parameter logic [DATA_WIDTH-1:0] PIO_IRQ1_INTS_MASK 		= 32'h 0000_0FFF; //----_-000
	
	// Register index
	typedef enum int {
    PIO_CTRL,
    PIO_FSTAT,
    PIO_FDEBUG,
    PIO_FLEVEL,
    PIO_TXF0,
    PIO_TXF1,
    PIO_TXF2,
    PIO_TXF3,
    PIO_RXF0,
    PIO_RXF1,
    PIO_RXF2,
    PIO_RXF3,
    PIO_IRQ,
    PIO_IRQ_FORCE,
    PIO_INPUT_SYNC_BYPASS,
    PIO_DBG_PADOUT,
	PIO_DBG_PADOE,
    PIO_DBG_CFGINFO,
    PIO_INSTR_MEM0,
    PIO_INSTR_MEM1,
    PIO_INSTR_MEM2,
    PIO_INSTR_MEM3,
    PIO_INSTR_MEM4,
    PIO_INSTR_MEM5,
    PIO_INSTR_MEM6,
    PIO_INSTR_MEM7,
    PIO_INSTR_MEM8,
    PIO_INSTR_MEM9,
    PIO_INSTR_MEM10,
    PIO_INSTR_MEM11,
    PIO_INSTR_MEM12,
    PIO_INSTR_MEM13,
    PIO_INSTR_MEM14,
    PIO_INSTR_MEM15,
    PIO_INSTR_MEM16,
    PIO_INSTR_MEM17,
    PIO_INSTR_MEM18,
    PIO_INSTR_MEM19,
    PIO_INSTR_MEM20,
    PIO_INSTR_MEM21,
    PIO_INSTR_MEM22,
    PIO_INSTR_MEM23,
    PIO_INSTR_MEM24,
    PIO_INSTR_MEM25,
    PIO_INSTR_MEM26,
    PIO_INSTR_MEM27,
    PIO_INSTR_MEM28,
    PIO_INSTR_MEM29,
    PIO_INSTR_MEM30,
    PIO_INSTR_MEM31,
    PIO_SM0_CLKDIV,
    PIO_SM0_EXECCTRL,
    PIO_SM0_SHIFTCTRL,
    PIO_SM0_ADDR,
    PIO_SM0_INSTR,
    PIO_SM0_PINCTRL,
    PIO_SM1_CLKDIV,
    PIO_SM1_EXECCTRL,
    PIO_SM1_SHIFTCTRL,
    PIO_SM1_ADDR,
    PIO_SM1_INSTR,
    PIO_SM1_PINCTRL,
    PIO_SM2_CLKDIV,
    PIO_SM2_EXECCTRL,
    PIO_SM2_SHIFTCTRL,
    PIO_SM2_ADDR,
    PIO_SM2_INSTR,
    PIO_SM2_PINCTRL,
    PIO_SM3_CLKDIV,
    PIO_SM3_EXECCTRL,
    PIO_SM3_SHIFTCTRL,
    PIO_SM3_ADDR,
    PIO_SM3_INSTR,
    PIO_SM3_PINCTRL,
    PIO_INTR,
    PIO_IRQ0_INTE,
    PIO_IRQ0_INTF,
    PIO_IRQ0_INTS,
    PIO_IRQ1_INTE,
    PIO_IRQ1_INTF,
    PIO_IRQ1_INTS
	} PIO_REG_ID;
	
endpackage: pio_reg_pkg