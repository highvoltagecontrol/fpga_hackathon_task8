class environment;
  virtual hack_if m_vif;

  driver  m_drv;
  monitor m_mon;

  time wait_for_output_data = 200us;

  function new(virtual hack_if vif);
    m_vif = vif;

    m_drv = new(m_vif);
    m_mon = new(m_vif);
  endfunction

  task pre_test();
    $display($sformatf("[%0t ps][ENVIRONMENT] pre_test", $time));

  endtask

  task test();
    $display($sformatf("[%0t ps][ENVIRONMENT] test", $time));

    fork
      m_mon.monitor_eth_frames_from_dut();
      m_drv.drive_eth_frames_to_dut();
    join_any
  endtask

  task post_test();
    $display($sformatf("[%0t ps][ENVIRONMENT] post_test", $time));

    m_drv.get_statistics();
    m_mon.get_statistics();
  endtask

  task run;
    pre_test();

    test();
    #wait_for_output_data;

    post_test();
  endtask

  task add_eth_frames(eth_frame eth_frames[]);
    m_drv.add_eth_frames(eth_frames);
  endtask

endclass
