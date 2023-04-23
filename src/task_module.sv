`timescale 1ns/1ns

module task_module #(
  parameter int TASK_NUMBER       = 1,
  parameter int PACKET_SIZE_WIDTH = 1
  ) (
  input i_clk,
  input i_rst,

  task_in_interface  tis,
  task_out_interface tos
);

initial begin
  tis.task_data_request <= 'b0;

  tos.task_answer_ready                <= 'b0;
  tos.task_answer_data                 <= 'h0;
  tos.task_answer_data_last            <= 'b0;
  tos.task_answer_packet_size_in_bytes <= 'd0;
end

endmodule
