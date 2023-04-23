module serializer_task_9(i_clk, i_rst, i_data, i_enb, o_data, o_valid, o_busy);
	
	localparam ALL_ONES = 4'b1111;
	
	input i_clk;
	input i_rst;
	input [7:0] i_data[4];
	input i_enb;
	output reg [7:0] o_data = 0;
	output o_valid;
	
	wire [3:0] w_rdreq;
	wire [3:0] w_wrreq;
	reg [3:0] r_wrreq = 0;
	reg [7:0] r_data_del[4] = '{default:0};
	wire [3:0] w_empty;
	wire [3:0] w_full;
	wire [3:0] w_almost_full;
	wire [3:0] w_almost_empty;
	wire [7:0] w_q_fifo[4];
	reg [2:0] r_counter = 0;
	reg [2:0] r_counter_del = 0;
	reg [2:0] r_counter_del_2 = 0;
	wire [3:0] w_one_hot_out;
	wire w_valid;
	reg r_output_valid = 0;
	
	typedef enum {s_LOAD, s_SEND} states;
	states state = s_LOAD;
	states next = s_LOAD;
	states state_del = s_LOAD;
	output o_busy;
	
   genvar i;
	
	assign w_wrreq = r_wrreq;
	
	generate
		for(i=0;i<4;i++) begin:gen_loop_0
			always@(posedge i_clk) begin
				r_data_del[i] <= i_data[i];
			end
		end
	endgenerate
	
	always@(*) begin
		case(state)
			s_LOAD: begin
				if(w_almost_full == ALL_ONES)
					next = s_SEND;
				else
					next = s_LOAD;
			end
			s_SEND: begin
				if(w_empty == ALL_ONES)
					next = s_LOAD;
				else
					next = s_SEND;
			end
		endcase
	end
	
	always@(posedge i_clk)
		if (i_rst)
			state <= s_LOAD;
		else
			state <= next;

		
	always@(posedge i_clk) begin
		case(state)
			s_LOAD: begin
				if(i_enb) 
					r_wrreq <= ALL_ONES;
				else
					r_wrreq <= 0;
			end
			s_SEND: begin
				r_wrreq <= 0;
			end
		endcase
	end
	
	generate
		for(i=0;i<4;i++) begin:gen_loop_1
			serializer_fifo_task_9	serializer_fifo_task_9 (
				.clock ( i_clk ),
				.sclr ( i_rst ),
				.data ( r_data_del[i] ),
				.rdreq ( w_rdreq[i] ),
				.wrreq ( w_wrreq[i] ),
				.almost_empty ( w_almost_empty[i]),
				.almost_full ( w_almost_full[i]),
				.empty ( w_empty[i] ),
				.full ( w_full[i] ),
				.q ( w_q_fifo[i] )
			);
		end
	endgenerate
	
	always@(posedge i_clk) begin
		if(state == s_SEND)
			r_counter <= r_counter + 1'b1;
		if(r_counter >= 4)
			r_counter <= 1;
		if (state == s_LOAD || w_empty == ALL_ONES)
			r_counter <= 0;
	end
	
	one_hot_task_9	one_hot_task_9 (
		.clock ( i_clk ),
		.aclr ( i_rst ),
		.data ( r_counter ),
		.eq1 ( w_one_hot_out[0] ),
		.eq2 ( w_one_hot_out[1] ),
		.eq3 ( w_one_hot_out[2] ),
		.eq4 ( w_one_hot_out[3] )
	);
	
	assign w_rdreq = (w_empty == ALL_ONES) ? 4'd0 : w_one_hot_out;
	
	always@(posedge i_clk) begin
		case(r_counter_del_2)
			1: o_data <= w_q_fifo[0];
			2: o_data <= w_q_fifo[1];
			3: o_data <= w_q_fifo[2];
			4: o_data <= w_q_fifo[3];
			default: o_data <= 0;
		endcase
	end
	
	always@(posedge i_clk) begin
		r_counter_del <= r_counter;
		r_counter_del_2 <= r_counter_del;
		
		if(w_empty == ALL_ONES) begin
			r_counter_del <= 0;
			r_counter_del_2 <= 0;
		end
	end
	
	always@(posedge i_clk) begin
		if(r_counter_del_2 != 0)
			r_output_valid <= 1'b1;
		else
			r_output_valid <= 1'b0;
	end
	
	assign o_valid = r_output_valid;
	
	always@(posedge i_clk) begin
		state_del <= state;
	end
	
	assign o_busy = (state_del == s_SEND) ? 1'b1 : 1'b0;
	
endmodule 