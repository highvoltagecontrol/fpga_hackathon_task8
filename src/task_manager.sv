module task_manager
  #(parameter TASK_PORT_NUMBER  = 10, // MAXIMUM number 32!
    parameter TASK_DATA_WIDTH   = 8,
    parameter PACKET_SIZE_WIDTH = 12 // minimum 11 and maximum 18
    ) (
  //  sys
  input           i_clk,      i_rst,
  output reg      o_watchdog_trig,
  //  eth
  input   [7:0]   i_rdata,
  input           i_rready,
  output          o_rreq,
  output  [7:0]   o_wdata,
  input           i_wready,
  output          o_wvalid,
  // task interface
  task_in_interface.master tim [TASK_PORT_NUMBER:1],
  task_out_interface.master tom [TASK_PORT_NUMBER:1],
  // control interface
  output  [2:0] o_modulation_type,
  output        o_scrambling_enabled,
  output [15:0] o_scrambling_seed,
  output  [1:0] o_line_code_type,
  input   [2:0] i_modulation_type,
  input         i_scrambling_enabled,
  input  [15:0] i_scrambling_seed,
  input   [1:0] i_line_code_type
  );

typedef enum bit [2:0] {
    IDLE             = 3'd0,
    READ_PING_FRAME  = 3'd1,
    READ_TASK_DATA   = 3'd2,
    SEND_REQUEST     = 3'd3,
    SEND_PONG        = 3'd4,
    SEND_TASK_ANSWER = 3'd5,
    WAIT_FOR_MHP     = 3'd6
} state_enum;

//  fsm
state_enum state;
state_enum next_state;

localparam ACTIVE     = 1'd1;
localparam INACTIVE   = 1'd0;
localparam DATA_WIDTH = 8;

reg   [31:0]  watchdog  = 0;

`ifdef SIMULATION
  localparam  _TIME_5s   = 32'h00003000;
`else
  localparam  _TIME_5s   = 32'h0EE6B27F;
`endif

typedef struct packed {
    logic task32;
    logic task31;
    logic task30;
    logic task29;
    logic task28;
    logic task27;
    logic task26;
    logic task25;

    logic task24;
    logic task23;
    logic task22;
    logic task21;
    logic task20;
    logic task19;
    logic task18;
    logic task17;

    logic task16;
    logic task15;
    logic task14;
    logic task13;
    logic task12;
    logic task11;
    logic task10;
    logic task9;

    logic task8;
    logic task7;
    logic task6;
    logic task5;
    logic task4;
    logic task3;
    logic task2;
    logic task1;
} task_enabler;

localparam task_enabler enable = '{
                                  task1 :  1'd0, //RGB2GRAY
                                  task2 :  1'd0, //Pixel Buffer
                                  task3 :  1'd0, //Convolution
                                  task4 :  1'd0, //Edge direction detector
                                  task5 :  1'd0, //Bin2BCD
                                  task6 :  1'd0, //Encoder 3b/4b
                                  task7 :  1'd0, //Encoder 5b/6b
                                  task8 :  1'd1, //Butterfly Unit FLP

                                  task9 :  1'd0, //sqrt(x)
                                  task10 : 1'd0, //Demod QAM16
                                  task11 : 1'd0,
                                  task12 : 1'd0,
                                  task13 : 1'd0,
                                  task14 : 1'd0,
                                  task15 : 1'd0,
                                  task16 : 1'd0,

                                  task17 : 1'd0,
                                  task18 : 1'd0,
                                  task19 : 1'd0,
                                  task20 : 1'd0,
                                  task21 : 1'd0,
                                  task22 : 1'd0,
                                  task23 : 1'd0,
                                  task24 : 1'd0,

                                  task25 : 1'd0,
                                  task26 : 1'd0,
                                  task27 : 1'd0,
                                  task28 : 1'd0,
                                  task29 : 1'd0,
                                  task30 : 1'd0,
                                  task31 : 1'd0,
                                  task32 : 1'd0
};

logic [3:0] [7:0] enabled_tasks;

typedef struct packed {
  logic        cyclic_prefix_enabled;  // bez outputu
  logic        compression_enabled;  // bez outputu
  logic        scrambling_enabled;
  logic  [1:0] line_code_type;  // bez outputu
  logic  [2:0] modulation_type;
  logic [15:0] scrambling_seed;
  logic  [7:0] segments_number;
  logic  [7:0] segment_index;
  logic  [7:0] task_number;
  logic [10:0] packet_size_in_bytes;
  logic  [3:0] reserved;
  logic        ping_pong;
} header_elements;

header_elements task_header;
header_elements mhp_tx_header;

logic mhp_tx_valid;
logic [7:0] mhp_tx_data;
logic mhp_tx_data_ack;
logic [10:0] counter;
logic controller_busy;
logic mhp_tx_busy;
logic rx_mhp_valid;
logic task_manager_ready;
logic mhp_header_sent;
logic task_data_last;
logic [DATA_WIDTH-1:0] rx_mhp_data;
logic task_answer_ready;
logic [DATA_WIDTH-1:0] task_answer_data;
//logic task_answer_data_last;
logic task_data_request;
logic [PACKET_SIZE_WIDTH-1:0] task_answer_packet_size_in_bytes;
logic [7:0] granted_task_number;
logic [7:0] task_answer_data_buffer;
//logic task_answer_data_buffer_valid;

logic [TASK_PORT_NUMBER:1][DATA_WIDTH-1:0] task_data_demux;
logic                 [TASK_PORT_NUMBER:1] task_data_valid_demux;
logic                 [TASK_PORT_NUMBER:1] task_data_last_demux;
logic                 [TASK_PORT_NUMBER:1] task_manager_ready_demux;

logic                         [TASK_PORT_NUMBER:1] tom_task_answer_ready;
logic                   [TASK_PORT_NUMBER:1] [7:0] tom_task_answer_data;
//logic                         [TASK_PORT_NUMBER:1] tom_task_answer_data_last;
logic [TASK_PORT_NUMBER:1] [PACKET_SIZE_WIDTH-1:0] tom_task_answer_packet_size_in_bytes;
logic                 [TASK_PORT_NUMBER:1]  tim_task_data_request;

logic [PACKET_SIZE_WIDTH-1:0] task_answer_packet_size_in_bytes_minus_1;
logic                         payload_bigger_than_1024;
logic                         update_done;

assign task_answer_packet_size_in_bytes_minus_1 = task_answer_packet_size_in_bytes - {{(PACKET_SIZE_WIDTH-1){1'b0}},1'b1};
assign payload_bigger_than_1024 = |task_answer_packet_size_in_bytes_minus_1[PACKET_SIZE_WIDTH-1:10];

assign o_modulation_type    = task_header.modulation_type;
assign o_scrambling_enabled = task_header.scrambling_enabled;
assign o_scrambling_seed    = task_header.scrambling_seed;
assign o_line_code_type     = task_header.line_code_type;

assign task_answer_ready                = tom_task_answer_ready[granted_task_number];
assign task_answer_data                 = tom_task_answer_data[granted_task_number];
//assign task_answer_data_last            = tom_task_answer_data_last[granted_task_number];
assign task_answer_packet_size_in_bytes = tom_task_answer_packet_size_in_bytes[granted_task_number];
assign task_data_request                = tim_task_data_request[task_header.task_number];

//assign o_cyclic_prefix_enabled = task_header.cyclic_prefix_enabled;
//assign o_segments_number = task_header.segments_number;
//assign o_segment_index = task_header.segment_index;
//assign o_compression_enabled = task_header.compression_enabled;
//assign mhp_tx_header.compression_enabled = i_compression_enabled;

assign enabled_tasks = enable;

always_comb begin
  integer i;
  for (i = 1; i <= TASK_PORT_NUMBER; i++) begin
    task_data_demux[i] = {DATA_WIDTH{1'b0}};
  end
  task_data_demux[task_header.task_number] = rx_mhp_data;
end

always_comb begin
  integer i;
  for (i = 1; i <= TASK_PORT_NUMBER; i++) begin
    task_data_valid_demux[i] = INACTIVE;
  end
  if (task_header.ping_pong == INACTIVE)
    // send data to task only in state READ_TASK_DATA
    task_data_valid_demux[task_header.task_number] = (next_state == READ_TASK_DATA || state == READ_TASK_DATA) ? rx_mhp_valid : INACTIVE;
end

always_comb begin
  integer i;
  for (i = 1; i <= TASK_PORT_NUMBER; i++) begin
    task_data_last_demux[i] = INACTIVE;
  end
  task_data_last_demux[task_header.task_number] = task_data_last;
end

always_comb begin
  integer i;
  for (i = 1; i <= TASK_PORT_NUMBER; i++) begin
      task_manager_ready_demux[i] = INACTIVE;
  end
  task_manager_ready_demux[granted_task_number] = task_manager_ready;
end

always_ff @(posedge i_clk) begin
  if (i_rst) begin
    granted_task_number <= 8'd1;
  end
  else begin
    if (state == IDLE && task_answer_ready == INACTIVE) begin
      if (granted_task_number == (TASK_PORT_NUMBER))
        granted_task_number <= 8'd1;
      else
        granted_task_number <= granted_task_number + 8'd1;
    end
  end
end

genvar i;
generate
  for (i=1; i <= TASK_PORT_NUMBER; i++) begin : TIM
    always_comb begin
      tom_task_answer_ready[i]                = tom[i].task_answer_ready;
      tom_task_answer_data[i]                 = tom[i].task_answer_data;
      //tom_task_answer_data_last[i]            = tom[i].task_answer_data_last;
      tom_task_answer_packet_size_in_bytes[i] = tom[i].task_answer_packet_size_in_bytes;
      tim_task_data_request[i]                = tim[i].task_data_request;
    end
    always_ff @(posedge i_clk) begin
      if (i_rst) begin
        tim[i].task_data <= {DATA_WIDTH{1'b0}};
      end
      else begin
        tim[i].task_data <= task_data_demux[i];
      end
    end

    always_ff @(posedge i_clk) begin
      if (i_rst) begin
        tim[i].task_data_valid <= INACTIVE;
      end
      else begin
        tim[i].task_data_valid <= task_data_valid_demux[i];
      end
    end

    always_ff @(posedge i_clk) begin
      if (i_rst) begin
        tim[i].task_data_last <= INACTIVE;
      end
      else begin
        tim[i].task_data_last <= task_data_last_demux[i];
      end
    end

    assign tom[i].task_manager_ready = task_manager_ready_demux[i];
  end : TIM
endgenerate

always_ff @(posedge i_clk) begin
  if (i_rst)
    task_data_last <= INACTIVE;
  else begin
    if (state == READ_TASK_DATA && rx_mhp_valid == ACTIVE && counter[10:0] == task_header.packet_size_in_bytes-2 &&
        task_header.segment_index == task_header.segments_number - 1) begin
      task_data_last <= ACTIVE;
    end
    else begin
      if (state == IDLE);
        task_data_last <= INACTIVE;
    end
  end
end

always_ff @(posedge i_clk) begin
  if (i_rst)
    task_manager_ready <= INACTIVE;
  else begin
    case(state)
      IDLE, WAIT_FOR_MHP: begin
        if (next_state == SEND_REQUEST)
          task_manager_ready <= ACTIVE;
        else
          task_manager_ready <= INACTIVE;
      end
      SEND_REQUEST: begin
        if (next_state == SEND_TASK_ANSWER)
          task_manager_ready <= ACTIVE;
        else
          task_manager_ready <= INACTIVE;
      end
      SEND_TASK_ANSWER: begin
        if (next_state == IDLE || next_state == WAIT_FOR_MHP)
          task_manager_ready <= INACTIVE;
      end
    endcase
  end
end

always_ff @(posedge i_clk) begin
  if (i_rst)
    mhp_tx_valid <= INACTIVE;
  else begin
    if (state == SEND_REQUEST || state == SEND_PONG || state == SEND_TASK_ANSWER)
      mhp_tx_valid <= ACTIVE;
    else
      mhp_tx_valid <= INACTIVE;
  end
end

always_ff @(posedge i_clk) begin
  if (i_rst)
    mhp_tx_data <= 8'd0;
  else begin
    case (state)
      IDLE,SEND_PONG: begin
        mhp_tx_data <= enabled_tasks[counter[1:0]];
      end
      SEND_REQUEST:
          if (next_state == SEND_TASK_ANSWER)
            mhp_tx_data <= task_answer_data_buffer;
      SEND_TASK_ANSWER:
        mhp_tx_data <= task_answer_data;
//      default:
//        mhp_tx_data <= 8'd0;
    endcase
  end
end

always_ff @(posedge i_clk) begin
  if (i_rst)
    task_answer_data_buffer <= 8'd0;
  else begin
    if (mhp_tx_data_ack == ACTIVE)
      task_answer_data_buffer <= 8'd0;
    else
      if (task_manager_ready == ACTIVE)
        task_answer_data_buffer <= task_answer_data;
  end
end

//always_ff @(posedge i_clk) begin
//  if (i_rst)
//    task_answer_data_buffer_valid <= INACTIVE;
//  else begin
//    if (mhp_tx_data_ack == ACTIVE)
//      task_answer_data_buffer_valid <= INACTIVE;
//    else
//      if (task_answer_ready == ACTIVE)
//        task_answer_data_buffer_valid <= ACTIVE;
//  end
//end

always_ff @(posedge i_clk) begin
  if (i_rst)
    counter <= 11'd0;
  else begin
    case (state)
      IDLE: begin
        counter <= 11'd0;
        if (mhp_tx_busy == INACTIVE && rx_mhp_valid == ACTIVE)
          counter <= counter + 11'd1;
      end
      SEND_REQUEST: begin
        if (mhp_tx_valid == 1'd0 && task_header.ping_pong == INACTIVE)
          counter <= counter +11'd1;
      end
      SEND_PONG: begin
        if (mhp_tx_data_ack == 1'd1)
          counter <= counter + 11'd1;
      end
      SEND_TASK_ANSWER:
        counter <= counter + 11'd1;
      READ_TASK_DATA:
        if (rx_mhp_valid == ACTIVE)
          counter <= counter + 11'd1;
      WAIT_FOR_MHP: begin
        if (next_state == SEND_REQUEST)
          counter <= 11'd0;
      end
//      default:
//        counter <= 11'd0;
    endcase
  end
end

always_ff @(posedge i_clk) begin
  if (i_rst) begin
    mhp_tx_header <= 'd0;
  end
  else begin
    case(state)
      IDLE: begin
        mhp_tx_header.ping_pong             <= INACTIVE;
        mhp_tx_header.compression_enabled   <= INACTIVE;
        mhp_tx_header.cyclic_prefix_enabled <= INACTIVE;
        mhp_tx_header.line_code_type        <= 0;
        mhp_tx_header.modulation_type       <= 0;
        mhp_tx_header.packet_size_in_bytes  <= task_answer_packet_size_in_bytes[10:0];
        mhp_tx_header.reserved              <= 4'd0;
        mhp_tx_header.scrambling_enabled    <= INACTIVE;
        mhp_tx_header.scrambling_seed       <= 0;
        mhp_tx_header.segment_index         <= 8'd0;
        mhp_tx_header.segments_number       <= 8'd1;
        mhp_tx_header.task_number           <= granted_task_number;
      end
      READ_PING_FRAME: begin
        mhp_tx_header.ping_pong            <= ACTIVE;
        mhp_tx_header.task_number          <= 8'd0;
        mhp_tx_header.packet_size_in_bytes <= 11'd4;
      end
      SEND_REQUEST: begin
        if (mhp_tx_header.ping_pong == INACTIVE) begin
  //        mhp_tx_header.line_code_type <= i_line_code_type;
          mhp_tx_header.modulation_type <= i_modulation_type;
          if (payload_bigger_than_1024 == ACTIVE) begin
            if (update_done == INACTIVE) begin
              mhp_tx_header.packet_size_in_bytes <= 11'd1024;
              mhp_tx_header.segment_index        <= 8'd0;
            end
          end
          else begin
            mhp_tx_header.packet_size_in_bytes <= task_answer_packet_size_in_bytes[10:0];
          end
          mhp_tx_header.reserved           <= 4'd0;
          mhp_tx_header.scrambling_enabled <= i_scrambling_enabled;
          mhp_tx_header.scrambling_seed    <= i_scrambling_seed;
          mhp_tx_header.segments_number    <= {{8-(PACKET_SIZE_WIDTH-10){1'b0}}, task_answer_packet_size_in_bytes[PACKET_SIZE_WIDTH-1:10] + {7'd0, |task_answer_packet_size_in_bytes[9:0]}};
          mhp_tx_header.task_number        <= granted_task_number;
        end
      end
      WAIT_FOR_MHP: begin
        if (next_state == SEND_REQUEST) begin
          mhp_tx_header.segment_index <= mhp_tx_header.segment_index + 8'd1;
          if (mhp_tx_header.segment_index + 8'd2 == mhp_tx_header.segments_number) begin
            if (task_answer_packet_size_in_bytes[9:0] != 10'h0) begin
              mhp_tx_header.packet_size_in_bytes <= {1'b0, task_answer_packet_size_in_bytes[9:0]};
            end
          end
        end
      end
    endcase
  end
end

always_ff @(posedge i_clk) begin
  if (i_rst) begin
    update_done <= INACTIVE;
  end
  else begin
    case (state)
      WAIT_FOR_MHP: begin
        if (next_state == SEND_REQUEST) begin
          update_done <= ACTIVE;
        end
      end

      IDLE: begin
        update_done <= INACTIVE;
      end

      default:
        update_done <= update_done;
    endcase
  end
end

always_comb
  case(state)
    IDLE: begin
      if (mhp_tx_busy == INACTIVE) begin
        if (rx_mhp_valid == ACTIVE && counter == 11'd0) begin  // MHP is sending new data
          if (task_header.ping_pong == ACTIVE) begin
            next_state = READ_PING_FRAME;
          end
          else begin
            if (task_data_request == ACTIVE)
              next_state = READ_TASK_DATA;
            else begin
              next_state = state;
            end
          end
        end
        else begin
          if (task_answer_ready == ACTIVE) begin
            next_state = SEND_REQUEST;
          end
          else begin
            next_state = state;
          end
        end
      end
      else begin
        next_state = state;
      end
    end

    READ_PING_FRAME: begin
      if (rx_mhp_valid == INACTIVE) begin
        next_state = SEND_REQUEST;
      end
      else begin
        next_state = state;
      end
    end

    SEND_REQUEST: begin
      if (mhp_header_sent == ACTIVE) begin
        if (task_header.ping_pong == ACTIVE) begin
          next_state = SEND_PONG;
        end
        else begin
          next_state = SEND_TASK_ANSWER;
        end
      end
      else begin
        next_state = state;
      end
    end

    SEND_PONG: begin
      if (counter == 11'd3) begin
        next_state = IDLE;
      end
      else begin
        next_state = state;
      end
    end

    READ_TASK_DATA: begin
      if (counter[10:0] == task_header.packet_size_in_bytes-1 && rx_mhp_valid == ACTIVE) begin
        next_state = IDLE;
      end
      else begin
        next_state = state;
      end
    end
    SEND_TASK_ANSWER: begin
      if (mhp_tx_header.segments_number-1 == mhp_tx_header.segment_index) begin
        if (counter[10:0] == mhp_tx_header.packet_size_in_bytes-1 && task_answer_ready == ACTIVE) begin
          next_state = IDLE;
        end
        else begin
          next_state = state;
        end
      end
      else begin
        if (task_answer_ready == ACTIVE && counter[10:0] == 11'd1024 - 11'd1)
          next_state = WAIT_FOR_MHP;
        else
          next_state = SEND_TASK_ANSWER;
      end
    end
    WAIT_FOR_MHP: begin
      if (mhp_tx_busy == INACTIVE)
        next_state = SEND_REQUEST;
      else
        next_state = WAIT_FOR_MHP;
    end
    default: next_state = IDLE;
  endcase

always_ff @(posedge i_clk) begin
  if (i_rst)
    state <= IDLE;
  else
    state <= next_state;
end

always_ff @(posedge i_clk) begin
  if (watchdog == 0)
    o_watchdog_trig <= 1'b1;
  else
    o_watchdog_trig <= 1'b0;
end

always_ff @(posedge i_clk) begin
  if (i_rst) begin
    controller_busy <= INACTIVE;
    watchdog <= _TIME_5s;
  end
  else begin
    if (state == IDLE) begin
     watchdog <= _TIME_5s;
      controller_busy <= INACTIVE;
      if (mhp_tx_busy == INACTIVE && (rx_mhp_valid == ACTIVE || task_answer_ready == ACTIVE)) begin
        controller_busy  <= ACTIVE;
      end
    end
   else if (watchdog != 0) begin // states other than IDLE
     watchdog <= watchdog - 1;
   end
  end
end

mhp protocol(
  //  sys
  .i_clk    (i_clk),
  .i_rst    (i_rst),
  //  eth
  .i_rdata           (i_rdata),
  .i_rready          (i_rready),
  .o_rreq            (o_rreq),
  .o_wdata           (o_wdata),
  .i_wready          (i_wready),
  .o_wvalid          (o_wvalid),

  .o_header          (task_header),
  .o_rx_mhp_valid    (rx_mhp_valid),
  .o_rx_mhp_data     (rx_mhp_data),
  .i_controller_busy (controller_busy),
  .i_mhp_tx_header   (mhp_tx_header),
  .i_mhp_tx_valid    (mhp_tx_valid),
  .i_mhp_tx_data     (mhp_tx_data),
  .o_mhp_tx_data_ack (mhp_tx_data_ack),
  .o_mhp_tx_busy     (mhp_tx_busy),
  .o_mhp_header_sent (mhp_header_sent)
  );

endmodule
