//-----------------------------------------------------------------
// TASK 2: LINE BUFFER
//
//-----------------------------------------------------------------
module line_buffer (i_clk, i_rst, i_data, i_enb, o_valid, o_data);
//-----		INPUTS		-------------------------------------------	
	input i_clk;
	input i_rst;
	input i_enb;
	input [7:0] i_data;
//-----		OUTPUTS		-------------------------------------------	
	output o_valid;
	output [7:0] o_data[9];
//-----		WIRES			-------------------------------------------	

//-----		REGS			-------------------------------------------

//-----		OTHERS      -------------------------------------------

//-----------------------------------------------------------------
//-----		MODULE CONTENT		-------------------------------------
//-----------------------------------------------------------------
	
	assign o_valid = i_enb;   	// Just a dummy assignement. Replace with your code.
	assign o_data[0] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[1] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[2] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[3] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[4] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[5] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[6] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[7] = i_data;	// Just a dummy assignement. Replace with your code.
	assign o_data[8] = i_data;	// Just a dummy assignement. Replace with your code.
	
endmodule 