//----------------------------------------------------------------------------------------
// TASK 8: BUTTERFLY 
// 
//----------------------------------------------------------------------------------------
module butterfly(i_clk, i_rst, i_data, i_enb, o_valid, o_A_re, o_A_im, o_B_re, o_B_im);

//-----		INPUTS		------------------------------------------------------------------	
	input i_clk;
	input i_rst;
	input i_enb;
	input [7:0]  i_data;
//-----		OUTPUTS		------------------------------------------------------------------	
	output [31:0] o_A_re;
	output [31:0] o_A_im;
	output [31:0] o_B_re;
	output [31:0] o_B_im;
	output o_valid;
//-----    WIRES         -----------------------------------------------------------------
//-----    REGS         ------------------------------------------------------------------
	reg [7:0] buffer [23:0];
	reg [7:0] byte_cnt = 0;
	
	reg buffer_received = 0;
	reg fft_start = 0;
	reg [8:0] valid_pipe = 0;
	
	reg [31:0] A_re = 0;
	reg [31:0] A_im = 0;
	reg [31:0] B_re = 0;
	reg [31:0] B_im = 0;
	reg [31:0] W_re = 0;
	reg [31:0] W_im = 0;
	
	reg [31:0] BWre = 0;
	reg [31:0] BWim = 0;
	
	reg [31:0] A_P_BWre = 0;
	reg [31:0] A_P_BWim = 0;
	
	reg [31:0] A_M_BWre = 0;
	reg [31:0] A_M_BWim = 0;
	
	reg [31:0] A_re_pipe[5:0];
	reg [31:0] A_im_pipe[5:0];
	
	
	//========================================================================================	
	localparam  FFT_RADIX2_WIDTH        = 24;
	localparam  PIPE_WIDTH        		= 6;

	localparam  A_RE_3         			= 0;
	localparam  A_RE_2         			= 1;
	localparam  A_RE_1         			= 2;
	localparam  A_RE_0         			= 3;
				
	localparam  A_IM_3         			= 4;
	localparam  A_IM_2         			= 5;
	localparam  A_IM_1         			= 6;
	localparam  A_IM_0         			= 7;
				
	localparam  B_RE_3         			= 8;
	localparam  B_RE_2         			= 9;
	localparam  B_RE_1         			= 10;
	localparam  B_RE_0         			= 11;
				
	localparam  B_IM_3         			= 12;
	localparam  B_IM_2         			= 13;
	localparam  B_IM_1         			= 14;
	localparam  B_IM_0         			= 15;
				
	localparam  W_RE_3         			= 16;
	localparam  W_RE_2         			= 17;
	localparam  W_RE_1         			= 18;
	localparam  W_RE_0         			= 19;
				
	localparam  W_IM_3         			= 20;
	localparam  W_IM_2         			= 21;
	localparam  W_IM_1         			= 22;
	localparam  W_IM_0         			= 23;
	
	integer 		i								= 0;
	
//========================================================================================
//    		MODULE CONTENT		

	
	assign o_A_re = A_P_BWre; 	// Just a dummy assignement. Replace with your code.
	assign o_A_im = A_P_BWim; 	// Just a dummy assignement. Replace with your code.
	assign o_B_re = A_M_BWre; 	// Just a dummy assignement. Replace with your code.
	assign o_B_im = A_M_BWim; 	// Just a dummy assignement. Replace with your code.
	assign o_valid = valid_pipe[8];		// Just a dummy assignement. Replace with your code.	
	
	/* buffer collector */
	always @(posedge i_clk) begin
		if (i_rst) begin
			/* clear buffer */
			for (i = 0 ; i < FFT_RADIX2_WIDTH-1 ; i = i + 1) begin
				buffer[i] <= 0;
			end
			byte_cnt <= 0;
			buffer_received <= 0;
		end
		else begin
			buffer_received <= 0;
			if (i_enb) begin
				byte_cnt <= byte_cnt + 1;
				/* collect 24 bytes of data payloads*/
				case(byte_cnt)
					/* A componennt real part */
					A_RE_3: begin
						buffer[A_RE_3] <= i_data;
					end
					A_RE_2: begin
						buffer[A_RE_2] <= i_data;
					end
					A_RE_1: begin
						buffer[A_RE_1] <= i_data;
					end
					A_RE_0: begin
						buffer[A_RE_0] <= i_data;
					end
					/* A componennt imagine part */
					A_IM_3: begin
						buffer[A_IM_3] <= i_data;
					end
					A_IM_2: begin
						buffer[A_IM_2] <= i_data;
					end
					A_IM_1: begin
						buffer[A_IM_1] <= i_data;
					end
					A_IM_0: begin
						buffer[A_IM_0] <= i_data;
					end
					/* B componennt real part */
					B_RE_3: begin
						buffer[B_RE_3] <= i_data;
					end
					B_RE_2: begin
						buffer[B_RE_2] <= i_data;
					end
					B_RE_1: begin
						buffer[B_RE_1] <= i_data;
					end
					B_RE_0: begin
						buffer[B_RE_0] <= i_data;
					end
					/* B componennt imagine part */
					B_IM_3: begin
						buffer[B_IM_3] <= i_data;
					end
					B_IM_2: begin
						buffer[B_IM_2] <= i_data;
					end
					B_IM_1: begin
						buffer[B_IM_1] <= i_data;
					end
					B_IM_0: begin
						buffer[B_IM_0] <= i_data;
					end
					/* omega componennt real part */
					W_RE_3: begin
						buffer[W_RE_3] <= i_data;
					end
					W_RE_2: begin
						buffer[W_RE_2] <= i_data;
					end
					W_RE_1: begin
						buffer[W_RE_1] <= i_data;
					end
					W_RE_0: begin
						buffer[W_RE_0] <= i_data;
					end
					/* omega componennt imagine part */
					W_IM_3: begin
						buffer[W_IM_3] <= i_data;
					end
					W_IM_2: begin
						buffer[W_IM_2] <= i_data;
					end
					W_IM_1: begin
						buffer[W_IM_1] <= i_data;
					end
					W_IM_0: begin
						buffer[W_IM_0] <= i_data;
					end
				endcase
				
				if (byte_cnt == FFT_RADIX2_WIDTH-1) begin
					buffer_received <= 1;
					byte_cnt <= 0;
				end
			end
		end
	end
	
	/* radix2 fft processor */
	always @(posedge i_clk) begin
		if (i_rst) begin
			A_re <= 0;
			A_im <= 0;
			B_re <= 0;
			B_im <= 0;
			W_im <= 0;
			W_re <= 0;
			fft_start <= 1'b0;
		end
		else begin
			fft_start <= 1'b0;
			if (buffer_received) begin
				/* A componennt real part */
				A_re[31:24] <= buffer[A_RE_3];
				A_re[23:16] <= buffer[A_RE_2];
				A_re[15:8] 	<= buffer[A_RE_1];
				A_re[7:0] 	<= buffer[A_RE_0];
				/* A componennt imagine part */
				A_im[31:24] <= buffer[A_IM_3];
				A_im[23:16] <= buffer[A_IM_2];
				A_im[15:8] 	<= buffer[A_IM_1];
				A_im[7:0] 	<= buffer[A_IM_0];
				
				/* B componennt real part */
				B_re[31:24] <= buffer[B_RE_3];
				B_re[23:16] <= buffer[B_RE_2];
				B_re[15:8] 	<= buffer[B_RE_1];
				B_re[7:0] 	<= buffer[B_RE_0];
				/* B componennt imagine part */
				B_im[31:24] <= buffer[A_IM_3];
				B_im[23:16] <= buffer[A_IM_2];
				B_im[15:8] 	<= buffer[A_IM_1];
				B_im[7:0] 	<= buffer[A_IM_0];
				
				/* W componennt real part */
				W_re[31:24] <= buffer[W_RE_3];
				W_re[23:16] <= buffer[W_RE_2];
				W_re[15:8] 	<= buffer[W_RE_1];
				W_re[7:0] 	<= buffer[W_RE_0];
				/* W componennt imagine part */
				W_im[31:24] <= buffer[W_IM_3];
				W_im[23:16] <= buffer[W_IM_2];
				W_im[15:8] 	<= buffer[W_IM_1];
				W_im[7:0] 	<= buffer[W_IM_0];
				fft_start <= 1'b1;
			end
		end
	end
	
	/* B * W (Delay 6 clk cycles) */
	fp_mul_cplx fp_mul_cplx_fft(
		.clk    (i_clk),    				//    clk.clk
		.areset (i_rst), 					// areset.reset
		.a      (B_re),      			//      a.a
		.b      (B_im),      			//      b.b
		.c      (W_re),      			//      c.c
		.d      (W_im),      			//      d.d
		.q      (BWre),      			//      q.q
		.r      (BWim)       			//      r.r
	);
	
	/* Z^-6 Delay*/
	always @(posedge i_clk) begin
		if (i_rst) begin
			for (i = 0 ; i < PIPE_WIDTH-1 ; i = i + 1) begin
				A_re_pipe[i] <= 0;
				A_im_pipe[i] <= 0;
			end
			valid_pipe <= 0;
		end
		else begin
			A_re_pipe[0] <= A_re;
			A_re_pipe[5:1] <= A_re_pipe[4:0];
			A_im_pipe[0] <= A_im[31:0];
			A_im_pipe[5:1] <= A_im_pipe[4:0];
			
			valid_pipe[0] = fft_start;
			valid_pipe[8:1] = valid_pipe[7:0];
		end
	end
	
	/* Aex = A + B * W (Delay 2 clk cycles) */
	fp_add fp_add_fft_re(
		.clk    (i_clk),    				//    clk.clk
		.areset (i_rst), 					// areset.reset
		.a      (A_re_pipe[5]),      	//      a.a
		.b      (BWre),      			//      b.b
		.q      (A_P_BWre)      		//      q.q
	);
	
	fp_add fp_add_fft_im(
		.clk    (i_clk),    				//    clk.clk
		.areset (i_rst), 					// areset.reset
		.a      (A_im_pipe[5]),      	//      a.a
		.b      (BWim),      			//      b.b
		.q      (A_P_BWim)      		//      q.q
	);
	
	/* Bex = A - B * W */
	fp_sub fp_sub_fft_re(
		.clk    (i_clk),    				//    clk.clk
		.areset (i_rst), 					// areset.reset
		.a      (A_re_pipe[5]),      	//      a.a
		.b      (BWre),      			//      b.b
		.q      (A_M_BWre)      		//      q.q
	);
	
	fp_sub fp_sub_fft_im(
		.clk    (i_clk),    				//    clk.clk
		.areset (i_rst), 					// areset.reset
		.a      (A_im_pipe[5]),      	//      a.a
		.b      (BWim),      			//      b.b
		.q      (A_M_BWim)      		//      q.q
	);
	
	
	
endmodule 