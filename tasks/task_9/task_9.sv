module task_9(i_clk, i_rst, i_tmanager_ready, i_tdata_last, i_tdata_valid, i_tdata,
          o_tanswer_ready, o_tanswer_data, o_tanswer_data_last, o_tready, o_packet_size_in_bytes);


  input i_clk;
  input i_rst;
  input i_tmanager_ready;
  input i_tdata_last;
  input i_tdata_valid;
  input [7:0] i_tdata;

  output o_tanswer_ready;
  output [7:0] o_tanswer_data;
  output o_tanswer_data_last;
  output o_tready;
  output [11:0] o_packet_size_in_bytes;

  wire [7:0] w_data_input;
  wire w_busy_input;
  wire w_empty_input;

  wire [31:0] w_data_output;
  wire [7:0] w_data_serial_output;
  wire w_valid_output;
  wire w_busy_output;
  wire w_full_output;
  wire w_enb_input;
  wire [7:0] w_data_task_output[4];
  wire w_valid_task_output;
  
  wire w_busy;

  task_9_input task_9_input(
    .i_clk(i_clk),
	 .i_rst(i_rst),
    .i_tdata_valid(i_tdata_valid),
    .i_tdata(i_tdata),
    .i_tdata_last(i_tdata_last),
    .o_tready(o_tready),
    .o_data(w_data_input),
    .o_busy(w_busy_input),
    .o_empty(w_empty_input),
    .o_enb(w_enb_input)
  );

  reciprocal_sqrt reciprocal_sqrt(
	.i_clk(i_clk),
	 .i_rst(i_rst),
	.i_enb(w_enb_input),
	.i_data(w_data_input),
	.o_data(w_data_output),
	.o_valid(w_valid_task_output)
  );
  
  assign w_data_task_output[0] = w_data_output[31:24];
  assign w_data_task_output[1] = w_data_output[23:16];
  assign w_data_task_output[2] = w_data_output[15:8];
  assign w_data_task_output[3] = w_data_output[7:0];
  
   serializer_task_9 serializer_task_9(
	 .i_clk(i_clk),
	 .i_rst(i_rst),
	 .i_data(w_data_task_output),
	 .i_enb(w_valid_task_output),
	 .o_data(w_data_serial_output),
	 .o_valid(w_valid_output),
	 .o_busy(w_busy)
	);

  task_9_output task_9_output(
    .i_clk(i_clk),
	 .i_rst(i_rst),
    .i_tmanager_ready(i_tmanager_ready),
    .i_data(w_data_serial_output),
    .i_data_valid(w_valid_output),
    .o_tanswer_ready(o_tanswer_ready),
    .o_tdata(o_tanswer_data),
    .o_busy(w_busy_output),
    .o_full(w_full_output),
    .o_tanswer_data_last(o_tanswer_data_last),
    .o_packet_size_in_bytes(o_packet_size_in_bytes)
  );

endmodule