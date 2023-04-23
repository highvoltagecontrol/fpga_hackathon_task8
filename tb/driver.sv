class driver;
  virtual hack_if m_vif;

  eth_frame m_eth_frames[];

  int trans_num;

  function new(virtual hack_if vif);
    m_vif = vif;

    trans_num = 0;
  endfunction

  function void add_eth_frames(eth_frame eth_frames[]);
    $display($sformatf("[%0t ps][DRIVER] Adding Ethernet frames", $time));

    m_eth_frames = eth_frames;
  endfunction

  task drive_eth_frames_to_dut;
    frame_t       frame;
    logic_frame_t logic_frame;

    if (m_eth_frames.size() == 0) begin
      $error($sformatf("[%0t ps][DRIVER] Array with Ethernet frames is empty!", $time));
      return;
    end

    $display($sformatf("[%0t ps][DRIVER] Driving Ethernet frames to DUT", $time));

    foreach(m_eth_frames[i]) begin
      $display($sformatf("[%0t ps][DRIVER] Ethernet frame[%0d]:", $time, i));
      m_eth_frames[i].print_frame();
      m_eth_frames[i].get_frame_bytes(frame);

      // cast to logic
      logic_frame = logic_frame_t'(frame);
      m_vif.send_frame(logic_frame);

      #100us;
      trans_num++;
    end
  endtask

  function void get_statistics();
    $display($sformatf("[%0t ps][DRIVER] Total number of transaction: %0d", $time, trans_num));
  endfunction

endclass
