//----------------------------------------------------------------------------------------------
// TASK 3: Convolution engine
//
//----------------------------------------------------------------------------------------------
module conv_engine (i_clk, i_rst, i_data, i_valid, o_pixel, o_valid);

//-----		PARAMETERS	------------------------------------------------------------------------
	localparam KERNEL_SIZE = 9;
	localparam VALID_OUTPUT_LATENCY  = 10;
//-----		INPUTS		------------------------------------------------------------------------
	input i_clk;
	input i_rst;
	input i_valid;
	input [7:0] i_data;
//-----		OUTPUTS		------------------------------------------------------------------------
	output [7:0] o_pixel;
	output o_valid;
//-----		WIRES			------------------------------------------------------------------------
   wire [7:0] w_win [KERNEL_SIZE];
	wire w_rst_counter;
//-----		REGS			------------------------------------------------------------------------
	reg [8:0] r_mult[KERNEL_SIZE] = '{default:0};
	reg [15:0] r_add[KERNEL_SIZE-1] = '{default:0};
	reg [15:0] r_divide ;
	reg [7:0] r_kernel[KERNEL_SIZE] = '{1, 2, 1, 2, 0, 1, 1, 0, 1};
	reg [7:0] r_entry_buffer[KERNEL_SIZE] = '{default:0};
	reg [3:0] r_counter = 0;
	reg r_win_last = 0;
	reg r_del[VALID_OUTPUT_LATENCY] = '{default:0};
//-----		OTHERS      ------------------------------------------------------------------------
	genvar i;
	genvar j;
	genvar k;
//==============================================================================================
//    		MODULE CONTENT		
//==============================================================================================

//--------- FORMING WINDOW ---------------------------------------------------------------------
  	//Counter for a window formation.
	always@(posedge i_clk) begin
		if (i_rst)
			r_counter <= 0;
		else if (w_rst_counter)
			r_counter <= 0;
		else if(i_valid)
			r_counter <= r_counter + 1'b1;
		else
			r_counter <= r_counter;
	end
	
	always@(posedge i_clk) begin
		if(w_rst_counter)
			r_win_last <= 1;
		else
			r_win_last <= 0;
	end
	
	assign w_rst_counter = (r_counter == 8) ? 1'b1 : 1'b0;
	
	// Buffer for storing input data and "catch"
	// a whole window.
	always@(posedge i_clk) 
		r_entry_buffer[8] <= i_data;					//Entry point of the buffer
	
   generate
		for(i=KERNEL_SIZE-2;i>=0;i--) begin: buffer_loop //Rest of the buffer
			always@(posedge i_clk) begin
				r_entry_buffer[i] <= r_entry_buffer[i+1];   
			end														  
		end
	endgenerate

	//If the buffer is filled with a proper data than send this data further.  
	generate
		for(j=0;j<KERNEL_SIZE;j++) begin: win_loop
			assign w_win[j] = (r_win_last) ? r_entry_buffer[j]: 0;
		end
	endgenerate
	
//--------- MULTIPLICATION STAGE ---------------------------------------------------------------
	generate
		for(i=0;i<KERNEL_SIZE;i++) begin: mult_loop
			always@(posedge i_clk) begin
				r_mult[i] <= w_win[i] * r_kernel[i];
			end
		end
	endgenerate	
	
//-------- ADDITION STAGE ----------------------------------------------------------------------	
	always@(posedge i_clk) 
		r_add[0] <= r_mult[0] + r_mult[1];
	
	generate
		for(i=1;i<KERNEL_SIZE-1;i++) begin:add_loop
			always@(posedge i_clk) 
				r_add[i] <= r_mult[i+1] + r_add[i-1];
		end
	endgenerate
//------- DIVISION STAGE -----------------------------------------------------------------------
	
	div	div_inst (
		.clock ( i_clk ),   //IP Core from Altera Library. DO NOT CHANGE IT!!!
		.aclr  ( i_rst ),
		.denom ( 9 ),
		.numer ( r_add[KERNEL_SIZE-2] ),
		.quotient ( r_divide ),
		.remain ( )
	);
	assign o_pixel = r_divide[7:0];
//------- VALID OUTPUT -------------------------------------------------------------------------
	//Generates one pulse tick to inform that the output data is valid. 
	//It delays ticks that informs about the last sample in input buffer.
	always@(posedge i_clk)
		if (i_rst)
			r_del[0] <= 1'b0;
		else
			r_del[0] <= r_win_last;
	
	generate
		for(k=0;k<VALID_OUTPUT_LATENCY-1;k++) begin:latency_loop
			always@(posedge i_clk)
				if (i_rst) begin
					r_del[k+1] <= 1'b0;
				end
				else begin
					r_del[k+1] <= r_del[k];
				end
		end
	endgenerate
	
	assign o_valid = r_del[VALID_OUTPUT_LATENCY-1];
endmodule 