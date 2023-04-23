`timescale 1ns/1ns
parameter TASK_PORT_NUMBER = 10;
parameter TASK_DATA_WIDTH = 8;
parameter PACKET_SIZE_WIDTH = 12;

interface task_in_interface ();
  logic                       task_data_request;
  logic                       task_data_valid;
  logic [TASK_DATA_WIDTH-1:0] task_data;
  logic                       task_data_last;

  modport master (input task_data_request,
                  output task_data_valid, task_data, task_data_last);

  modport  slave (input task_data_valid, task_data, task_data_last,
                  output task_data_request);
endinterface

interface task_out_interface ();
  logic                         task_answer_ready;
  logic                         task_manager_ready;
  logic   [TASK_DATA_WIDTH-1:0] task_answer_data;
  logic                         task_answer_data_last;
  logic [PACKET_SIZE_WIDTH-1:0] task_answer_packet_size_in_bytes;

  modport master (input task_answer_ready, task_answer_data, task_answer_data_last, task_answer_packet_size_in_bytes,
                  output task_manager_ready);

  modport  slave (input task_manager_ready,
                  output task_answer_ready, task_answer_data, task_answer_data_last, task_answer_packet_size_in_bytes);
endinterface

module control
  #(
    parameter TASK_PORT_NUMBER = 10,
    parameter TASK_DATA_WIDTH = 8
  ) (
  //  sys
  input           i_clk, i_rst,
  output				o_watchdog_trig,
  //  eth
  input   [7:0]   i_eth_rdata,
  input           i_eth_rready,
  output          o_eth_rreq,
  output  [7:0]   o_eth_wdata,
  input           i_eth_wready,
  output          o_eth_wvalid,
  //  uart rx
  input   [7:0]   i_uart_rdata,
  input           i_uart_rready,
  output          o_uart_rreq,
  //  uart tx
  output  [7:0]   o_uart_wdata,
  input           i_uart_wready,
  output          o_uart_wvalid
  );

task_in_interface tasks_in_interface [TASK_PORT_NUMBER:1] ();
task_out_interface tasks_out_interface [TASK_PORT_NUMBER:1] ();

task_manager #(
  .TASK_PORT_NUMBER (TASK_PORT_NUMBER),
  .TASK_DATA_WIDTH (TASK_DATA_WIDTH),
  .PACKET_SIZE_WIDTH (PACKET_SIZE_WIDTH)
  ) task_manager (
  //  sys
  .i_clk                (i_clk),
  .i_rst                (i_rst),
  .o_watchdog_trig		  (o_watchdog_trig),
  //  eth
  .i_rdata              (i_eth_rdata),
  .i_rready             (i_eth_rready),
  .o_rreq               (o_eth_rreq),
  .o_wdata              (o_eth_wdata),
  .i_wready             (i_eth_wready),
  .o_wvalid             (o_eth_wvalid),
  // task interface
  .tim                  (tasks_in_interface),
  .tom                  (tasks_out_interface),
  // control interface
  .o_modulation_type    (),
  .o_scrambling_enabled (),
  .o_scrambling_seed    (),
  .o_line_code_type     (),  //o2

  .i_modulation_type    (3'd0), //i3
  .i_scrambling_enabled (1'd0), //i1,
  .i_scrambling_seed    (16'd0), //i16
  .i_line_code_type     (2'd0) //i2
  );

wire [7:0] uart_data;
  
genvar task_number;
generate
  for (task_number=1;task_number<=TASK_PORT_NUMBER;task_number++) begin : TASK_MODULE
    if (task_number == 1) begin
      task_1 rgb2gray_u (
        .i_clk (i_clk),
		    .i_rst (i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes),
		  .o_uart_data (uart_data)
      );
    end
	  else if (task_number == 2) begin
      task_2 line_buffer_u (
        .i_clk (i_clk),
		    .i_rst (i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes)
      );
    end
	  else if (task_number == 3) begin
		  task_3 conv_engine_u (
        .i_clk (i_clk),
		    .i_rst (i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes)
      );
	 end
	 else if (task_number == 4) begin
		task_4 dir_detector_u (
        .i_clk (i_clk),
		    .i_rst (i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes)
      );
	 end
   else if (task_number == 5) begin
		task_5 bin2bcd_u (
        .i_clk (i_clk),
		    .i_rst (i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes)
      );
	 end
   else if (task_number == 6) begin
		task_6 enc_3b4b_u (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .tis   (tasks_in_interface[task_number]),
        .tos   (tasks_out_interface[task_number])
        );
	 end
   else if (task_number == 7) begin
		task_7 enc_5b6b_u (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .tis   (tasks_in_interface[task_number]),
        .tos   (tasks_out_interface[task_number])
        );
	 end
   else if (task_number == 8) begin
		task_8 butterfly_u (
        .i_clk (i_clk),
		    .i_rst (i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes)
    );
	 end
   else if (task_number == 9) begin
      task_9 recip_sqrt_u (
        .i_clk (i_clk),
		    .i_rst (i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes)
        );
   end
   else if (task_number == 10) begin
      task_10 demod_16_u (
        .i_clk (i_clk),
        .i_rst(i_rst),
        .i_tmanager_ready (tasks_out_interface[task_number].task_manager_ready),
        .i_tdata_last (tasks_in_interface[task_number].task_data_last),
        .i_tdata_valid (tasks_in_interface[task_number].task_data_valid),
        .i_tdata (tasks_in_interface[task_number].task_data),
        .o_tanswer_ready (tasks_out_interface[task_number].task_answer_ready),
        .o_tanswer_data (tasks_out_interface[task_number].task_answer_data),
        .o_tanswer_data_last (tasks_out_interface[task_number].task_answer_data_last),
        .o_tready (tasks_in_interface[task_number].task_data_request),
        .o_packet_size_in_bytes (tasks_out_interface[task_number].task_answer_packet_size_in_bytes)
        );
    end
	 else begin
      task_module #(
        .TASK_NUMBER (task_number),
        .PACKET_SIZE_WIDTH (PACKET_SIZE_WIDTH)
        ) task_u (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .tis   (tasks_in_interface[task_number]),
        .tos   (tasks_out_interface[task_number])
        );
    end
  end : TASK_MODULE
endgenerate

debug_port debug_port(
  //  sys
  .i_clk    (i_clk),
  .i_rst    (i_rst),
  //  uart rx
  .i_rdata  (i_uart_rdata),
  .i_rready (i_uart_rready),
  .o_rreq   (o_uart_rreq),
  //  uart tx
  .i_wready (1'b1),
  .i_wdata (uart_data),
  .o_wdata  (o_uart_wdata),
  .o_wvalid (o_uart_wvalid)
);

endmodule



