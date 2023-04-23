class test_ping_pong;
  localparam TIME_DELAY = 100us;

  environment m_env;

  eth_frame m_eth_frames[$];

  function new(virtual hack_if vif);
    m_env = new(vif);

    m_env.wait_for_output_data = TIME_DELAY;
  endfunction

  task run();
    create_eth_frame();
    m_env.add_eth_frames(m_eth_frames);

    m_env.run();
  endtask

  function void create_eth_frame();
    eth_frame eth_frames_temp;

    int		  packet_payload_size = 4;
    frame_t payload_bytes;

    eth_frames_temp = new();
    eth_frames_temp.m_eth_header.dst_mac               = BOARD_MAC;
    eth_frames_temp.m_eth_header.ethertype             = ETHERTYPE_MHP;
    eth_frames_temp.m_mhp_header.ping_pong             = 'b1;
    eth_frames_temp.m_mhp_header.segments_number       = 'b1;
    eth_frames_temp.m_mhp_header.segment_index         = 'b0;
    eth_frames_temp.m_mhp_header.cyclic_prefix_enabled = 'h0;
    eth_frames_temp.m_mhp_header.compression_enabled   = 'h0;
    eth_frames_temp.m_mhp_header.scrambling_enabled    = 'h0;
    eth_frames_temp.m_mhp_header.line_code_type        = 'h0;
    eth_frames_temp.m_mhp_header.modulation_type       = 'h0;
    eth_frames_temp.m_mhp_header.scrambling_seed       = 'h0;

    payload_bytes = new[packet_payload_size];
    foreach (payload_bytes[i])
      payload_bytes[i] = $urandom();

    eth_frames_temp.set_payload_bytes(payload_bytes);

    m_eth_frames.push_back(eth_frames_temp);
  endfunction

endclass
