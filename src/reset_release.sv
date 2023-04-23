`timescale 1ns/1ns

module reset_release #(
  parameter N = 8
)(
  input  i_clk,
  input  i_rst_trig,
  output o_rst
);

logic         reset = 0;
logic [N-1:0] reset_cnt = '1;

always_ff@(posedge i_clk) begin
  if(reset_cnt > 0)
    reset_cnt <= reset_cnt - 1'd1;
  if(i_rst_trig)
    reset_cnt <= {N{1'b1}};
end

always_ff@(posedge i_clk)
  reset <= |reset_cnt;

assign  o_rst = reset;

endmodule
