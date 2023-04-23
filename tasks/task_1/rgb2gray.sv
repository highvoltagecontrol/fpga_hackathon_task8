//----------------------------------------------------------------------------------------
// TASK 1: RGB 2 Grayscale 
// 
//----------------------------------------------------------------------------------------
module rgb2gray(i_clk, i_rst, i_enb, i_RGB, o_gray, o_valid , o_uart_data);

//-----		INPUTS		------------------------------------------------------------------
	input i_clk;
	input i_rst;
	input i_enb;
	input [7:0] i_RGB;
//-----		OUTPUTS		------------------------------------------------------------------
	output [7:0] o_gray;
	output o_valid;
	
	output reg [7:0] o_uart_data;
//-----    WIRES         -----------------------------------------------------------------
//-----    REGS         ------------------------------------------------------------------

//========================================================================================
//    		MODULE CONTENT		
//========================================================================================

	assign o_uart_data = 8'h5a;

	assign o_gray = i_RGB; 	// Just a dummy assignement. Replace with your code.
	assign o_valid = i_enb;	// Just a dummy assignement. Replace with your code.
		
endmodule 