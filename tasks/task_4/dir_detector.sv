//-----------------------------------------------------------------------------
// TASK 4: DIRECTION DETECTOR
//
//-----------------------------------------------------------------------------
module dir_detector(i_clk, i_rst, i_enb, o_dir, i_data, o_valid);
//-----		INPUTS		-------------------------------------------------------
	input i_clk;
	input i_rst;
	input i_enb;
	input signed [7:0] i_data;
//-----		OUTPUTS		-------------------------------------------------------	
   output [2:0] o_dir;
   output o_valid;
//-----		WIRES			-------------------------------------------------------
	
//-----		REGS			-------------------------------------------------------

//-----		OTHERS      -------------------------------------------------------

//-----------------------------------------------------------------------------
//-----		MODULE CONTENT		-------------------------------------------------
//-----------------------------------------------------------------------------	
	assign o_dir = i_data[2:0]; 	// Just a dummy assignement. Replace with your code.
	assign o_valid = i_enb;	// Just a dummy assignement. Replace with your code.
	
endmodule 