module task_6 #(
  parameter int TASK_NUMBER       = 7,
  parameter int PACKET_SIZE_WIDTH = 50
  ) (
  input i_clk,
  input i_rst,

  task_in_interface  tis,
  task_out_interface tos
);

  wire [7:0] w_data_input;
  wire w_busy_input;
  wire o_valid;

  wire [7:0] w_data_output;
  wire w_valid_output;
  wire w_busy_output;
  wire w_full_output;

  wire new_data_stream, rd_out;
  wire [3:0] enc_data_out;
  reg task_data_valid_prev;

  task_6_input task_6_input(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_tdata_valid(tis.task_data_valid),
    .i_tdata(tis.task_data),
    .i_tdata_last(tis.task_data_last),
    .o_tready(tis.task_data_request),
    .o_data(w_data_input),
    .o_busy(),
    .o_empty(),
    .o_valid(o_valid)
  );

  always @(posedge i_clk)
    task_data_valid_prev <= tis.task_data_valid;

  assign new_data_stream = (!task_data_valid_prev & tis.task_data_valid /*& tos.task_manager_ready*/);

  encoder_3b4b u_enc_3b4b (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data_in(w_data_input[2:0]),
    .i_rd_in( new_data_stream ? 1'b0 : rd_out ),
    .i_enb(o_valid),
    .o_data_out(enc_data_out),
    .o_rd_out(rd_out),
    .o_valid(w_valid_output)
  );

  assign w_data_output = {4'b0, enc_data_out};

  task_6_output task_6_output(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_tmanager_ready(tos.task_manager_ready),
    .i_data(w_data_output),
    .i_data_valid(w_valid_output),
    .o_tanswer_ready(tos.task_answer_ready),
    .o_tdata(tos.task_answer_data),
    .o_busy(),
    .o_full(),
    .o_tanswer_data_last(tos.task_answer_data_last),
    .o_packet_size_in_bytes(tos.task_answer_packet_size_in_bytes)
  );

endmodule