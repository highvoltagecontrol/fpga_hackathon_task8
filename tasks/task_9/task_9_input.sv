//============================================================================================================================
// TASK INPUT
// 
//============================================================================================================================
module task_9_input(i_clk, i_rst, i_tdata_valid, i_tdata, i_tdata_last, o_tready, o_data, o_busy, o_empty, o_enb);
//-----		INPUTS		------------------------------------------------------------------------------------------------------	
	input i_clk;
	input i_rst;
	input i_tdata_valid;
	input [7:0] i_tdata;
	input i_tdata_last;
//-----		OUTPUTS		------------------------------------------------------------------------------------------------------
	output o_tready;
	output [7:0] o_data;
	output o_busy;
	output o_empty;
        output o_enb;
//-----		WIRES			------------------------------------------------------------------------------------------------------
   wire [7:0] w_fifo_in;
	wire [7:0] w_fifo_out;
	wire w_wrreq;
	wire w_rdreq;
	wire w_empty;
//-----		REGS			------------------------------------------------------------------------------------------------------
	reg r_busy = 0;
	reg r_tready = 0;
        reg r_rdreq_del = 0;
//-----     OTHERS      ------------------------------------------------------------------------------------------------------
   typedef enum {s_IDLE, s_START_REQ, s_LOAD, s_SEND} task_input_enum;		
	task_input_enum state = s_IDLE;
	task_input_enum next_state = s_IDLE;
	
//============================================================================================================================
// 		   MODULE CONTENT		                                                                                               
//============================================================================================================================
 

//--------- NEXT STATE LOGIC  ------------------------------------------------------------------------------------------------	
	always @(*) begin
	if (i_rst) begin
		next_state <= s_IDLE;
	end
	else begin
		case(state) 
			s_IDLE: begin
				if(w_empty)
					next_state = s_START_REQ;
				else if (!w_empty)
					next_state = s_SEND;
				else
					next_state = s_IDLE;
			end
			s_START_REQ: begin
				next_state = s_LOAD;			
			end
			s_LOAD: begin
				if(i_tdata_last)
					next_state = s_IDLE;
				else
					next_state = s_LOAD;
			end
			s_SEND: begin
				if(w_empty)
					next_state = s_IDLE;
				else
					next_state = s_SEND;		
			end
			default: begin
				next_state = s_IDLE;
			end
		endcase
	end
  end
//--------- UPDATING STATE    ------------------------------------------------------------------------------------------------ 
	always @(posedge i_clk)
		if (i_rst) begin
			state <= s_IDLE;
		end
		else begin
			state <= next_state;
		end
//--------- OUTPUT LOGIC      ------------------------------------------------------------------------------------------------
	always @(posedge i_clk)
		begin
			case (state) 
			  s_IDLE:
				 begin
					r_busy <= 1'b0;
					r_tready <= 1'b0;
				 end
			  s_START_REQ:
				 begin
					r_busy <= 1'b1;
					r_tready <= 1'b1;
				 end
			  s_LOAD:
				 begin
					if(i_tdata_last)
						r_tready <= 0;
				 end
			  s_SEND:
				 begin
					
				 end
			endcase
	end

	assign o_tready = r_tready;
	assign o_busy = r_busy;
	assign o_data = w_fifo_out;
	assign w_fifo_in = i_tdata;
	assign o_empty = w_empty;
   assign o_enb = w_rdreq && r_rdreq_del;
	assign w_wrreq = i_tdata_valid;
	assign w_rdreq = (state == s_SEND) ? 1'b1: 1'b0;

   always@(posedge i_clk)
		r_rdreq_del <= w_rdreq;

	task_9_input_fifo task_9_input_fifo (
		.clock ( i_clk ),
		.sclr ( i_rst ),
		.data ( w_fifo_in ),
		.rdreq ( w_rdreq ),
		.wrreq ( w_wrreq ),
		.empty ( w_empty),
		.almost_full(),
		.full ( ),
		.q ( w_fifo_out )
	);
endmodule 