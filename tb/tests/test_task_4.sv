class test_task_4;
  localparam TIME_DELAY = 200us;

  // Edge direction detector
  localparam TASK_NUM           = 4;
  localparam TOTAL_PAYLOAD_SIZE = 240; 

  environment m_env;

  eth_frame m_eth_frames[$];

  function new(virtual hack_if vif);
    m_env = new(vif);

    m_env.wait_for_output_data = TIME_DELAY;
  endfunction

  task run();
    create_eth_frames();
    m_env.add_eth_frames(m_eth_frames);

    m_env.run();
  endtask

  function void create_eth_frames();
    int       segments_num;
    eth_frame eth_frames_temp;

    int		  packet_payload_size;
    frame_t payload_bytes;

    $display($sformatf("[%0t ps][TEST] Creating Ethernet frames", $realtime));

    segments_num = int'($ceil(real'(TOTAL_PAYLOAD_SIZE)/MAX_PAYLOAD_BYTES));
    $display($sformatf("[%0t ps][TEST] task number: %0d, segments number: %0d", $realtime, TASK_NUM, segments_num));

    for (int j = 0; j < segments_num; j++) begin
      eth_frames_temp = new();

      eth_frames_temp.m_eth_header.dst_mac               = BOARD_MAC;
      eth_frames_temp.m_eth_header.ethertype             = ETHERTYPE_MHP;
      eth_frames_temp.m_mhp_header.ping_pong             = 'b0;
      eth_frames_temp.m_mhp_header.task_number           = TASK_NUM;
      eth_frames_temp.m_mhp_header.segments_number       = segments_num;
      eth_frames_temp.m_mhp_header.segment_index         = j;
      eth_frames_temp.m_mhp_header.cyclic_prefix_enabled = 'h0;
      eth_frames_temp.m_mhp_header.compression_enabled   = 'h0;
      eth_frames_temp.m_mhp_header.scrambling_enabled    = 'h0;
      eth_frames_temp.m_mhp_header.line_code_type        = 'h0;
      eth_frames_temp.m_mhp_header.modulation_type       = 'h0;
      eth_frames_temp.m_mhp_header.scrambling_seed       = 'h0;

      if (segments_num == j+1)
        packet_payload_size = TOTAL_PAYLOAD_SIZE - int'($ceil(real'(TOTAL_PAYLOAD_SIZE)/segments_num))*(segments_num-1);
      else
        packet_payload_size = int'($ceil(real'(TOTAL_PAYLOAD_SIZE)/segments_num));

      payload_bytes = new[packet_payload_size];
      foreach (payload_bytes[i])
        payload_bytes[i] = $urandom();

      eth_frames_temp.set_payload_bytes(payload_bytes);

      m_eth_frames.push_back(eth_frames_temp);
    end
  endfunction

endclass
