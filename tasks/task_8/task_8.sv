module task_8(i_clk, i_rst, i_tmanager_ready, i_tdata_last, i_tdata_valid, i_tdata,
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

  wire [7:0] w_data_output;
  wire w_valid_output;
  wire w_busy_output;
  wire w_full_output;
  wire w_enb_input;
  wire [7:0] w_data_task_output[16];
  wire w_valid_task_output;
  
  wire [31:0] w_A_re;
  wire [31:0] w_A_im;
  wire [31:0] w_B_re;
  wire [31:0] w_B_im;
  
  wire w_busy;

  task_8_input task_8_input(
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

  butterfly butterfly(
	.i_clk(i_clk),
	 .i_rst(i_rst),
	.i_enb(w_enb_input),
	.i_data(w_data_input),
	.o_valid(w_valid_task_output),
	.o_A_re(w_A_re),
	.o_A_im(w_A_im),
	.o_B_re(w_B_re),
	.o_B_im(w_B_im)
  );
  
  assign w_data_task_output[0] = w_A_re[31:24];
  assign w_data_task_output[1] = w_A_re[23:16];
  assign w_data_task_output[2] = w_A_re[15:8];
  assign w_data_task_output[3] = w_A_re[7:0];
  
  assign w_data_task_output[4] = w_A_im[31:24];
  assign w_data_task_output[5] = w_A_im[23:16];
  assign w_data_task_output[6] = w_A_im[15:8];
  assign w_data_task_output[7] = w_A_im[7:0];
  
  assign w_data_task_output[8] = w_B_re[31:24];
  assign w_data_task_output[9] = w_B_re[23:16];
  assign w_data_task_output[10] = w_B_re[15:8];
  assign w_data_task_output[11] = w_B_re[7:0];
  
  assign w_data_task_output[12] = w_B_im[31:24];
  assign w_data_task_output[13] = w_B_im[23:16];
  assign w_data_task_output[14] = w_B_im[15:8];
  assign w_data_task_output[15] = w_B_im[7:0];
  
  
  	task_8_serializer task_8_serializer(
	 .i_clk(i_clk),
	 .i_rst(i_rst),
	 .i_data(w_data_task_output),
	 .i_enb(w_valid_task_output),
	 .o_data(w_data_output),
	 .o_valid(w_valid_output),
	 .o_busy(w_busy)
	);

  task_8_output task_8_output(
    .i_clk(i_clk),
	 .i_rst(i_rst),
    .i_tmanager_ready(i_tmanager_ready),
    .i_data(w_data_output),
    .i_data_valid(w_valid_output),
    .o_tanswer_ready(o_tanswer_ready),
    .o_tdata(o_tanswer_data),
    .o_busy(w_busy_output),
    .o_full(w_full_output),
    .o_tanswer_data_last(o_tanswer_data_last),
    .o_packet_size_in_bytes(o_packet_size_in_bytes)
  );

endmodule