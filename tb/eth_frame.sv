class eth_frame;
  bit [7:0] m_preamble[8] = '{'h55, 'h55, 'h55, 'h55, 'h55, 'h55, 'h55, /* SFD */ 'hD5};

  eth_header_t m_eth_header;
  mhp_header_t m_mhp_header;

  frame_t m_payload_bytes;

  bit [7:0] m_fcs[CRC_SIZE];

  function void set_eth_header(eth_header_t eth_header);
    m_eth_header = eth_header;
  endfunction

  function void set_mhp_header(mhp_header_t mhp_header);
    m_mhp_header = mhp_header;
  endfunction

  function void set_payload_bytes(frame_t payload_bytes);
    if (payload_bytes.size() > MAX_PAYLOAD_BYTES || payload_bytes.size() == 0) begin
      $error($sformatf("Wrong payload size: %0d (max: %0d)! Payload has not been set",
        payload_bytes.size(), MAX_PAYLOAD_BYTES));
      return;
    end

    m_payload_bytes = payload_bytes;

    m_mhp_header.packet_size_in_bytes = m_payload_bytes.size();

    // padding
    if (m_payload_bytes.size() < MIN_PAYLOAD_BYTES) begin
      int actual_size = m_payload_bytes.size();

      m_payload_bytes = new[MIN_PAYLOAD_BYTES](m_payload_bytes);
      for (int i = actual_size; i < MIN_PAYLOAD_BYTES; i++) begin
        m_payload_bytes[i] = 'h0;
      end
    end
  endfunction

  // RX side (+PREAMBLE)
  function void get_frame_bytes(ref frame_t frame_bytes);
    frame_bytes = new[PREAMBLE_SIZE + ETH_HEADER_SIZE + MHP_HEADER_SIZE + m_payload_bytes.size()];

    for (int i = 0; i < PREAMBLE_SIZE; i++) begin
      frame_bytes[i] = m_preamble[i];
    end

    for (int i = 0; i < ETH_HEADER_SIZE; i++) begin
      frame_bytes[i + PREAMBLE_SIZE] = m_eth_header[(ETH_HEADER_SIZE - i - 1)*8 +: 8];
    end

    for (int i = 0; i < MHP_HEADER_SIZE; i++) begin
      frame_bytes[i + PREAMBLE_SIZE + ETH_HEADER_SIZE] = m_mhp_header[(MHP_HEADER_SIZE - i - 1)*8 +: 8];
    end

    foreach (m_payload_bytes[i]) begin
      frame_bytes[i + PREAMBLE_SIZE + ETH_HEADER_SIZE + MHP_HEADER_SIZE] = m_payload_bytes[i];
    end
  endfunction

  // TX side (+CRC)
  function bit create_frame_from_bytes(frame_t frame_bytes);
    bit result = 'b1;

    int min_size   = ETH_HEADER_SIZE + MHP_HEADER_SIZE + MIN_PAYLOAD_BYTES + CRC_SIZE;
    int max_size   = ETH_HEADER_SIZE + MHP_HEADER_SIZE + MAX_PAYLOAD_BYTES + CRC_SIZE;
    int total_size = frame_bytes.size();
    int payload_size;

    if ((total_size < min_size) || (total_size > max_size)) begin
      $error($sformatf("Size of captured frame is incorrect: %0d (min: %0d, max: %0d)!",
        total_size, min_size, max_size));	  

      result = 'b0;
      return result;
    end

    m_eth_header = {>>{frame_bytes[0 : (ETH_HEADER_SIZE - 1)]}};;
    m_mhp_header = {>>{frame_bytes[ETH_HEADER_SIZE : (ETH_HEADER_SIZE + MHP_HEADER_SIZE - 1)]}};

    payload_size    = total_size - ETH_HEADER_SIZE - MHP_HEADER_SIZE - CRC_SIZE;
    m_payload_bytes = new[payload_size];
    foreach (m_payload_bytes[i]) begin
      m_payload_bytes[i] = frame_bytes[ETH_HEADER_SIZE + MHP_HEADER_SIZE + i];
    end

    if ((m_mhp_header.packet_size_in_bytes >= MIN_PAYLOAD_BYTES) && (m_mhp_header.packet_size_in_bytes != m_payload_bytes.size())) begin
      $error($sformatf("Size of captured payload (%0d) is different than information in the header (%0d)!",
        m_payload_bytes.size(), m_mhp_header.packet_size_in_bytes));
    end

    foreach (m_fcs[i]) begin
      m_fcs[i] = frame_bytes[ETH_HEADER_SIZE + MHP_HEADER_SIZE + payload_size - 1 + i];
    end

    return result;
  endfunction

  function void print_frame();
    $display("ETHERNET HEADER");
    $display($sformatf("dst_mac = 0x%h", m_eth_header.dst_mac));
    $display($sformatf("src_mac = 0x%h", m_eth_header.src_mac));
    $display($sformatf("ethertype = 0x%h", m_eth_header.ethertype));

    $display("MHP HEADER");
    $display($sformatf("cyclic_prefix_enabled = 0x%h", m_mhp_header.cyclic_prefix_enabled));
    $display($sformatf("compression_enabled = 0x%h", m_mhp_header.compression_enabled));
    $display($sformatf("scrambling_enabled = 0x%h", m_mhp_header.scrambling_enabled));
    $display($sformatf("line_code_type = 0x%h", m_mhp_header.line_code_type));
    $display($sformatf("modulation_type = 0x%h", m_mhp_header.modulation_type));
    $display($sformatf("scrambling_seed = 0x%h", m_mhp_header.scrambling_seed));
    $display($sformatf("segments_number = 0x%h", m_mhp_header.segments_number));
    $display($sformatf("segment_index = 0x%h", m_mhp_header.segment_index));
    $display($sformatf("task_number = 0x%h", m_mhp_header.task_number));
    $display($sformatf("packet_size_in_bytes = 0x%h", m_mhp_header.packet_size_in_bytes));
    $display($sformatf("reserved = 0x%h", m_mhp_header.reserved));
    $display($sformatf("ping_pong = 0x%h", m_mhp_header.ping_pong));

    $display($sformatf("PAYLOAD (size: %0d)", m_payload_bytes.size()));
    foreach (m_payload_bytes[i]) begin
      $display($sformatf("payload_bytes[%0d] = 0x%h", i, m_payload_bytes[i]));
    end
  endfunction

endclass
