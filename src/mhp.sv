`timescale 1ns/1ns

parameter DATA_WIDTH = 8;

module mhp(
  //  sys
  input                     i_clk, i_rst,
  //  ctrl
//  input                     i_send,
//  output                    o_done,
  //  eth
  input   [DATA_WIDTH-1:0]  i_rdata,
  input                     i_rready,
  output                    o_rreq,
  output reg  [DATA_WIDTH-1:0]  o_wdata,
  input                     i_wready,
  output reg                o_wvalid,
  output [DATA_WIDTH*8-1:0] o_header,
  output                    o_rx_mhp_valid,
  output   [DATA_WIDTH-1:0] o_rx_mhp_data,
  input                     i_controller_busy,
  input  [DATA_WIDTH*8-1:0] i_mhp_tx_header,
  input                     i_mhp_tx_valid,
  input    [DATA_WIDTH-1:0] i_mhp_tx_data,
  output           reg      o_mhp_tx_data_ack,
  output               reg  o_mhp_tx_busy,
  output                    o_mhp_header_sent
);

typedef enum bit [2:0] {
    IDLE            = 3'd0,
    READ_HEADER     = 3'd1,
    READ_PAYLOAD    = 3'd2,
    SEND_HEADER     = 3'd3,
    WRITE_PAYLOAD   = 3'd4,
    ERROR           = 3'd5
  } state_enum;
//  fsm
state_enum state;

typedef struct packed {
  logic        cyclic_prefix_enabled;
  logic        compression_enabled;
  logic        scrambling_enabled;
  logic  [1:0] line_code_type;
  logic  [2:0] modulation_type;
  logic [15:0] scrambling_seed;
  logic  [7:0] segments_number;
  logic  [7:0] segment_index;
  logic  [7:0] task_number;
  logic [10:0] packet_size_in_bytes;
  logic  [3:0] reserved;
  logic        ping_pong;
} header_elements;



localparam  MPH_HEADER_SIZE = 64/DATA_WIDTH;
localparam ACTIVE = 1'b1;
localparam INACTIVE = 1'b0;

//  local regs
//  read regs
reg                       r_req   = 0;
//  write regs
//reg                 [7:0] w_data  = 0;
reg                       w_valid = 0;

reg [7:0][DATA_WIDTH-1:0] task_header;

reg              [10:0] data_counter;
reg                     header_byte_write;

logic                   rdata_valid_w;
logic                   rdata_valid;
logic  [DATA_WIDTH-1:0] rx_mhp_data;
logic                   w_error; // write error found
logic             [7:0] w_error_cnt;
logic                   rd_error; // write error found
logic             [7:0] rd_error_cnt;
logic                   mhp_header_sent;
logic        [7:0][7:0] tx_header;
logic                   data_counter_less_then_8;
logic rx_mhp_valid;

assign w_error = (w_valid == 1'd1 && i_wready == 1'd0);
assign rd_error = (i_rready == 1'd0 && state == READ_HEADER);
assign rdata_valid_w = i_rready == 1'd1 && r_req == 1'd1;

genvar i;
generate
  for (i=0; i < 8; i++) begin : tx_header_byte
    assign tx_header[7-i] = i_mhp_tx_header[((i*8+8)-1):(i*8)];
  end : tx_header_byte
endgenerate

assign o_rreq   = r_req;
assign o_header = task_header;
assign o_rx_mhp_data = rx_mhp_data;
assign o_rx_mhp_valid = rx_mhp_valid;
assign o_mhp_header_sent = mhp_header_sent;

always_ff @(posedge i_clk)
  if (i_rst==1)
    rdata_valid <= 1'd0;
  else
    rdata_valid <= rdata_valid_w;

always_ff @(posedge i_clk)
    if (i_rst==1) begin
      state <= IDLE;
      data_counter <= 11'd0;
    end
    else
      case(state)
        IDLE: begin
          data_counter <= 11'd0;
          if (i_mhp_tx_valid == 1'd1 && o_mhp_tx_busy == INACTIVE)begin
            //if (tx_header.ping_pong == 1'd1)
              state <= SEND_HEADER;
          end
          else
            if (i_rready == 1 && i_controller_busy == 1'd0) begin
              state <= READ_HEADER;
            end
        end
        READ_HEADER:
          if (i_rready == 1'd1) begin
            if (r_req == 1'd1) begin
              if (data_counter == MPH_HEADER_SIZE)
                state <= READ_PAYLOAD;
              else
                data_counter <= data_counter + 11'd1;
            end
          end
          else
            state <= ERROR;
        READ_PAYLOAD:
          if (i_rready == 1'd0) begin
            state <= IDLE;
            data_counter <= 11'd0;
          end
//          else
//            if (i_wready == 1'd0)
//              state <= ERROR;
        SEND_HEADER: begin
          data_counter <= data_counter + 11'd1;
          if (mhp_header_sent == 1'd1)
            state <= WRITE_PAYLOAD;
        end
        WRITE_PAYLOAD:
          if (i_mhp_tx_valid == 1'd0) begin
            state <= IDLE;
            data_counter <= 11'd0;
          end
        default: begin
          state <= IDLE;
          data_counter <= 11'd0;
        end
      endcase


always_ff @(posedge i_clk)
  if (i_rst==1)
    o_mhp_tx_data_ack <= 1'd0;
  else
    begin
      case(state)
        SEND_HEADER: begin
          o_mhp_tx_data_ack <= mhp_header_sent;
        end
        WRITE_PAYLOAD: begin
          if (i_mhp_tx_valid == 1'd1)
            o_mhp_tx_data_ack <= 1'd1;
          else
            o_mhp_tx_data_ack <= 1'd0;
        end
      endcase
    end

always_ff @(posedge i_clk)
  if (i_rst==1)
    o_wdata <= {DATA_WIDTH{1'd0}};
  else
    begin
      //if (((i_mhp_tx_valid == 1'd1 && state == SEND_HEADER) || state == WRITE_PAYLOAD) && i_wready == 1'd)
      case(state)
        SEND_HEADER: begin
          o_wdata <= tx_header[data_counter[2:0]];
        end
        WRITE_PAYLOAD: begin
          o_wdata <= i_mhp_tx_data;
        end
      endcase
    end

always_ff @(posedge i_clk)
  if (i_rst==1)
    o_wvalid <= 1'd0;
  else
    begin
      if (i_mhp_tx_valid == 1'd1 && (state == SEND_HEADER || state == WRITE_PAYLOAD))
        o_wvalid <= 1'd1;
      else
        o_wvalid <= 1'd0;
    end

always_ff @(posedge i_clk)
  if (i_rst==1)
    o_mhp_tx_busy <= 1'd0;
  else
    if (state == IDLE) begin
      if (i_wready == ACTIVE) begin
        if (o_mhp_tx_busy == ACTIVE) begin
          o_mhp_tx_busy <= INACTIVE;
        end
        else begin
          if (i_mhp_tx_valid == ACTIVE) begin
            o_mhp_tx_busy <= ACTIVE;
          end
        end
      end
    end

assign data_counter_less_then_8 = ~data_counter[3];

always_ff @(posedge i_clk)
  if (i_rst==1)
    mhp_header_sent <= 1'd0;
  else
    if (state == SEND_HEADER && data_counter == 11'd6)
      mhp_header_sent <= 1'd1;
    else
      mhp_header_sent <= 1'd0;

always_ff @(posedge i_clk)
  if (i_rst==1)
    header_byte_write <= 1'd0;
  else
    if (state == READ_HEADER && rdata_valid_w == 1'd1 && data_counter_less_then_8 == ACTIVE)
      header_byte_write <= 1'd1;
    else
      header_byte_write <= 1'd0;

always_ff @(posedge i_clk)
  if (i_rst==1)
    task_header <= {8{{DATA_WIDTH{1'b0}}}};
//  task_header <= {DATA_WIDTH{8'd0}};
  else
    if (header_byte_write == 1'd1)
      task_header <= {task_header[6:0], i_rdata};

always_ff @(posedge i_clk)
  if (i_rst) begin
    rx_mhp_data  <= 'd0;
    rx_mhp_valid <= 1'd0;
  end
  else begin
    if (rdata_valid == 1'd1 && state == READ_PAYLOAD) begin
      rx_mhp_data <= i_rdata;
      rx_mhp_valid <= 1'd1;
    end
    else begin
      rx_mhp_data  <= 'd0;
      rx_mhp_valid <= 1'd0;
    end
  end

 always_ff @(posedge i_clk)
  if (i_rst)
    w_error_cnt  <= 8'd0;
  else begin
    if (w_error == 1'd1 && w_error_cnt != 8'hFF)
      w_error_cnt <= w_error_cnt + 8'd1;
  end

always_ff @(posedge i_clk)
  if (i_rst)
    rd_error_cnt  <= 8'd0;
  else begin
    if (rd_error == 1'd1 && rd_error_cnt != 8'hFF)
      rd_error_cnt <= rd_error_cnt + 8'd1;
  end

always_ff @(posedge i_clk)
  if (i_rst)
    r_req <= 1'd0;
  else
    if (((state == IDLE  && i_controller_busy == 1'd0) || state == READ_HEADER || state == READ_PAYLOAD ) && i_rready == 1'd1)
      r_req <= 1'd1;
    else
      r_req <= 1'd0;

endmodule
