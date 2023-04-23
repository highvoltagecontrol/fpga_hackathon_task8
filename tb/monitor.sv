class monitor;
  virtual hack_if m_vif;

  int trans_num;

  function new(virtual hack_if vif);
    m_vif = vif;

    trans_num = 0;
  endfunction

  task monitor_eth_frames_from_dut();
    eth_frame temp_eth_frame;

    frame_t frame;
    logic_frame_t logic_frame;

    bit result;

    $display($sformatf("[%0t ps][MONITOR] Monitoring Ethernet frames from DUT", $time));

    forever begin
      m_vif.capture_frame(logic_frame);
      // cast to bit
      frame = frame_t'(logic_frame);

      temp_eth_frame = new();
      result = temp_eth_frame.create_frame_from_bytes(frame);
      if (!result) begin
        continue;
      end
      $display($sformatf("[%0t ps][MONITOR] Ethernet frame[%0d]:", $time, trans_num));
      temp_eth_frame.print_frame();

      trans_num++;
    end
  endtask

  function void get_statistics();
    $display($sformatf("[%0t ps][MONITOR] Total number of transaction: %0d", $time, trans_num));
  endfunction

endclass
