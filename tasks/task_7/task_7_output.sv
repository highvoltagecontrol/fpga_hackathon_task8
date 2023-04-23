//============================================================================================================================
// TASK OUTPUT
//
//============================================================================================================================
module task_7_output(i_clk, i_rst, i_tmanager_ready, i_data, i_data_valid, o_tanswer_ready, o_tdata, o_busy,
 o_full, o_tanswer_data_last, o_packet_size_in_bytes);
  import task_pkg::*;
//-----		INPUTS		------------------------------------------------------------------------------------------------------
  input i_clk;
  input i_rst;
  input i_tmanager_ready;
  input [7:0] i_data;
  input i_data_valid;
//-----		OUTPUTS		------------------------------------------------------------------------------------------------------
  output o_tanswer_ready;
  output [7:0] o_tdata;
  output o_busy;
  output o_full;
  output reg o_tanswer_data_last = 0;
  output [11:0] o_packet_size_in_bytes;
//-----		WIRES			------------------------------------------------------------------------------------------------------
  wire [7:0] w_fifo_in;
  wire [7:0] w_fifo_out;
  wire w_wrreq;
  wire w_rdreq;
  wire w_almost_empty;
  wire w_full;
  wire w_empty;
  wire w_almost_full;
  wire w_tanswer_data_last;
//-----		REGS			------------------------------------------------------------------------------------------------------
  reg r_busy = 0;
  reg r_tanswer_ready = 0;
  reg [11:0] r_packet_size_in_bytes = 0;
//-----     OTHERS      ------------------------------------------------------------------------------------------------------
  typedef enum {s_IDLE, s_START_SEND, s_SEND, s_LOAD} task_output_enum;
  task_output_enum state = s_IDLE;
  task_output_enum next_state = s_IDLE;

//============================================================================================================================
// 		   MODULE CONTENT
//============================================================================================================================


//--------- NEXT STATE LOGIC  ------------------------------------------------------------------------------------------------
  always @(*) begin
    if (i_rst) begin
      next_state = s_IDLE;
    end else begin
      case(state)
        s_IDLE: begin
          if(w_full)
            next_state = s_START_SEND;
          else if (!w_full)
            next_state = s_LOAD;
          else
            next_state = s_IDLE;
        end
        s_START_SEND: begin
          next_state = s_SEND;
        end
        s_SEND: begin
          if(w_empty)
            next_state = s_IDLE;
          else
            next_state = s_SEND;
        end
        s_LOAD: begin
          if(w_full)
            next_state = s_IDLE;
          else
            next_state = s_LOAD;
        end
        default: begin
          next_state = s_IDLE;
        end
      endcase
    end
  end

//--------- UPDATING STATE    ------------------------------------------------------------------------------------------------
	always @(posedge i_clk) begin
		if (i_rst) begin
			state <= s_IDLE;
		end else begin
			state <= next_state;
		end
	end

//--------- OUTPUT LOGIC      ------------------------------------------------------------------------------------------------
  always @(posedge i_clk)
    begin
      case (state)
        s_IDLE: begin
          r_busy <= 1'b0;
          r_tanswer_ready <= 1'b0;
          r_packet_size_in_bytes <= 0;
        end
        s_START_SEND: begin
          r_busy <= 1'b1;
          r_tanswer_ready <= 1'b1;
          r_packet_size_in_bytes <= TASK_7_PKT_SIZE_IN_BYTES;
        end
        s_SEND: begin
          if(o_tanswer_data_last) begin
            r_tanswer_ready <= 0;
            r_packet_size_in_bytes <= 0;
          end
        end
        s_LOAD: begin

        end
      endcase
  end

  assign o_tanswer_ready = r_tanswer_ready;
  assign o_busy = r_busy;
  assign o_tdata = w_fifo_out;
  assign w_fifo_in = i_data;
  assign o_full = w_full;
  assign w_wrreq = (i_data_valid && state == s_LOAD);
  assign w_rdreq = (state == s_START_SEND) ? 1'b1 : (i_tmanager_ready && state == s_SEND);
  assign w_tanswer_data_last = (!w_empty && w_almost_empty && state == s_SEND);
  assign o_packet_size_in_bytes = r_packet_size_in_bytes;

  always @(posedge i_clk)
    o_tanswer_data_last <= w_tanswer_data_last;

  task_7_output_fifo task_7_output_fifo (
    .clock ( i_clk ),
    .data ( w_fifo_in ),
    .rdreq ( w_rdreq ),
    .sclr (i_rst),
    .wrreq ( w_wrreq ),
    .almost_empty ( w_almost_empty ),
    .almost_full ( w_full ),
    .empty ( w_empty ),
    .full (  ),
    .q ( w_fifo_out )
  );
endmodule