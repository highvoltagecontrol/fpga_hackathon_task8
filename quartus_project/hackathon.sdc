create_clock -period 50MHz [get_ports {CLK_50}]
create_clock -period 50MHz [get_ports {L1_OSC}]


set_clock_groups -asynchronous -group [get_clocks {CLK_50}] \
-group [get_clocks {L1_OSC}]
set_false_path -from [get_ports {L1_OSC L1_RX0 L1_RX1 L1_CRS_DV}]
set_false_path -to [get_ports {UART_TX L1_TX0 L1_TX1 L1_TX_EN}]

