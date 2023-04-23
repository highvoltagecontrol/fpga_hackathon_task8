`timescale 1ns/1ns

import hack_pkg::*;

module tb_top;
  logic clk_50  = 0;
  logic clk_phy = 1;

  logic uart_tx;
  logic uart_rx = 1;

  hack_if m_if(clk_50, clk_phy, dut_top.reset);

  // TODO Choose suitable test case
  // test_ping_pong m_test;
  // test_task_1 m_test;
  // test_task_2 m_test;
  // test_task_3 m_test;
  // test_task_4 m_test;
  // test_task_5 m_test;
  // test_task_6 m_test;
  // test_task_7 m_test;
   test_task_8 m_test;
  // test_task_9 m_test;
  // test_task_10 m_test;

  top dut_top(
    .CLK_50(clk_50),
    //  RGMII
    .L1_OSC(clk_phy),
    .L1_TX0(m_if.tx0),
    .L1_TX1(m_if.tx1),
    .L1_TX_EN(m_if.tx_en),
    .L1_RX0(m_if.rx0),
    .L1_RX1(m_if.rx1),
    .L1_CRS_DV(m_if.rx_en),
    //  UART
    .UART_TX(uart_tx),
    .UART_RX(uart_rx)
  );

  initial begin
    forever begin
      #10 clk_50 = ~clk_50;
    end
  end

  initial begin
    #5
    forever begin
      #10 clk_phy = ~clk_phy;
    end
  end

  initial begin
    #10us;

    m_test = new(m_if);
    m_test.run();

    #10us;
    $finish;
  end
endmodule
