//----------------------------------------------------------------------------------------
// TASK 6: 3B/4B ENCODER
//
//----------------------------------------------------------------------------------------
module encoder_3b4b (i_clk, i_rst, i_data_in, i_rd_in, i_enb, o_data_out, o_rd_out, o_valid);

//-----		INPUTS		------------------------------------------------------------------
  input      i_clk;
  input      i_rst;
  input      [2:0] i_data_in;
  input      i_rd_in;
  input      i_enb;
//-----		OUTPUTS		------------------------------------------------------------------
  output reg [3:0] o_data_out;
  output reg       o_rd_out;
  output reg       o_valid;
//-----    WIRES         -----------------------------------------------------------------
//-----    REGS         ------------------------------------------------------------------

//========================================================================================
//    		MODULE CONTENT
//========================================================================================

  assign o_data_out = {1'b0, i_data_in};  // Just a dummy assignement. Replace with your code.
  assign o_valid    = i_enb;              // Just a dummy assignement. Replace with your code.
  assign o_rd_out   = 1'b0;               // Just a dummy assignement. Replace with your code.
  
endmodule