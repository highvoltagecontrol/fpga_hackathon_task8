package hack_pkg;
  typedef struct packed {
    bit        cyclic_prefix_enabled;
    bit        compression_enabled;
    bit        scrambling_enabled;
    bit [ 1:0] line_code_type;
    bit [ 2:0] modulation_type;
    bit [15:0] scrambling_seed;
    bit [ 7:0] segments_number;
    bit [ 7:0] segment_index;
    bit [ 7:0] task_number;
    bit [10:0] packet_size_in_bytes;
    bit  [3:0] reserved;
    bit        ping_pong;
  } mhp_header_t; // 8 bytes header

  typedef struct packed {
    bit [47:0] dst_mac; // 6 bytes
    bit [47:0] src_mac; // 6 bytes
    bit [15:0] ethertype; // 2 bytes
  } eth_header_t; // 14 bytes header

  parameter MAX_PAYLOAD_BYTES = 1492; // 1500 - 8 (MHP)
  parameter MIN_PAYLOAD_BYTES = 38;   // 46 - 8 (MHP)

  parameter PREAMBLE_SIZE   = 8;
  parameter ETH_HEADER_SIZE = 14;
  parameter MHP_HEADER_SIZE = 8;
  parameter CRC_SIZE        = 4;

  parameter ETHERTYPE_MHP  = 'h88b5;

  // TODO Place your assigned MAC address here
  //MAC ADDRESS:  26:73:1b:c9:11:0c
  parameter BOARD_MAC = {8'h26, 8'h73, 8'h1b, 8'hc9, 8'h11, 8'h0c};

  typedef bit [7:0] 	frame_t[];
  typedef logic [7:0] logic_frame_t[];

  `include "eth_frame.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "environment.sv"

  `include "tests/test_ping_pong.sv"
  `include "tests/test_task_1.sv"
  `include "tests/test_task_2.sv"
  `include "tests/test_task_3.sv"
  `include "tests/test_task_4.sv"
  `include "tests/test_task_5.sv"
  `include "tests/test_task_6.sv"
  `include "tests/test_task_7.sv"
  `include "tests/test_task_8.sv"
  `include "tests/test_task_9.sv"
  `include "tests/test_task_10.sv"

endpackage
