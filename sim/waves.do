onerror {resume}
quietly WaveActivateNextPane {} 0

TreeUpdate [SetDefaultTree]
quietly wave cursor active 0
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update

add wave -noupdate -divider TOP
add wave -noupdate -expand -group TOP /tb_top/dut_top/*

add wave -noupdate -divider UART
add wave -noupdate -expand -group UART -group WRAPPER /tb_top/dut_top/uart_wrapper/*

add wave -noupdate -divider HACK_CONTROL
add wave -noupdate -group HACK_CONTROL -expand -group MAC          -group WRAPPER /tb_top/dut_top/mac_wrapper/*
add wave -noupdate -group HACK_CONTROL -expand -group MAC          -group MAC_RX /tb_top/dut_top/mac_wrapper/mac_rx/*
add wave -noupdate -group HACK_CONTROL -expand -group MAC          -group MAC_TX /tb_top/dut_top/mac_wrapper/mac_tx/*
add wave -noupdate -group HACK_CONTROL -expand -group MHP          -group TOP /tb_top/dut_top/main/task_manager/protocol/*
add wave -noupdate -group HACK_CONTROL -expand -group CONTROL      -group TOP /tb_top/dut_top/main/*
add wave -noupdate -group HACK_CONTROL -expand -group TASK_MANAGER -group TOP /tb_top/dut_top/main/task_manager/*
add wave -noupdate -group HACK_CONTROL -expand -group DEBUG_PORT   -group TOP /tb_top/dut_top/main/debug_port/*

add wave -noupdate -divider TASK_IN_INTERFACES
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_1 {/tb_top/dut_top/main/tasks_in_interface[1]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_2 {/tb_top/dut_top/main/tasks_in_interface[2]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_3 {/tb_top/dut_top/main/tasks_in_interface[3]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_4 {/tb_top/dut_top/main/tasks_in_interface[4]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_5 {/tb_top/dut_top/main/tasks_in_interface[5]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_6 {/tb_top/dut_top/main/tasks_in_interface[6]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_7 {/tb_top/dut_top/main/tasks_in_interface[7]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_8 {/tb_top/dut_top/main/tasks_in_interface[8]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_9 {/tb_top/dut_top/main/tasks_in_interface[9]/*}
add wave -noupdate -group TASK_IN_INTERFACES -group TASK_IN_INTERFACE_10 {/tb_top/dut_top/main/tasks_in_interface[10]/*}

add wave -noupdate -divider TASK_OUT_INTERFACES
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_1 {/tb_top/dut_top/main/tasks_out_interface[1]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_2 {/tb_top/dut_top/main/tasks_out_interface[2]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_3 {/tb_top/dut_top/main/tasks_out_interface[3]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_4 {/tb_top/dut_top/main/tasks_out_interface[4]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_5 {/tb_top/dut_top/main/tasks_out_interface[5]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_6 {/tb_top/dut_top/main/tasks_out_interface[6]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_7 {/tb_top/dut_top/main/tasks_out_interface[7]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_8 {/tb_top/dut_top/main/tasks_out_interface[8]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_9 {/tb_top/dut_top/main/tasks_out_interface[9]/*}
add wave -noupdate -group TASK_OUT_INTERFACES -group TASK_OUT_INTERFACE_10 {/tb_top/dut_top/main/tasks_out_interface[10]/*}

add wave -noupdate -divider TASK_MODULES
add wave -noupdate -expand -group TASK_MODULE_1 -group INPUT    {/tb_top/dut_top/main/TASK_MODULE[1]/genblk1/rgb2gray_u/task_1_input/*}
add wave -noupdate -expand -group TASK_MODULE_1 -group RGB2GRAY {/tb_top/dut_top/main/TASK_MODULE[1]/genblk1/rgb2gray_u/rgb2gray/*}
add wave -noupdate -expand -group TASK_MODULE_1 -group OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[1]/genblk1/rgb2gray_u/task_1_output/*}

add wave -noupdate -expand -group TASK_MODULE_2 -group INPUT       {/tb_top/dut_top/main/TASK_MODULE[2]/genblk1/line_buffer_u/task_2_input/*}
add wave -noupdate -expand -group TASK_MODULE_2 -group LINE_BUFFER {/tb_top/dut_top/main/TASK_MODULE[2]/genblk1/line_buffer_u/line_buffer/*}
add wave -noupdate -expand -group TASK_MODULE_2 -group OUTPUT      {/tb_top/dut_top/main/TASK_MODULE[2]/genblk1/line_buffer_u/task_2_output/*}

add wave -noupdate -expand -group TASK_MODULE_3 -group INPUT       {/tb_top/dut_top/main/TASK_MODULE[3]/genblk1/conv_engine_u/task_3_input/*}
add wave -noupdate -expand -group TASK_MODULE_3 -group CONV_ENGINE {/tb_top/dut_top/main/TASK_MODULE[3]/genblk1/conv_engine_u/conv_engine/*}
add wave -noupdate -expand -group TASK_MODULE_3 -group OUTPUT      {/tb_top/dut_top/main/TASK_MODULE[3]/genblk1/conv_engine_u/task_3_output/*}

add wave -noupdate -expand -group TASK_MODULE_4 -group INPUT        {/tb_top/dut_top/main/TASK_MODULE[4]/genblk1/dir_detector_u/task_4_input/*}
add wave -noupdate -expand -group TASK_MODULE_4 -group DIR_DETECTOR {/tb_top/dut_top/main/TASK_MODULE[4]/genblk1/dir_detector_u/dir_detector/*}
add wave -noupdate -expand -group TASK_MODULE_4 -group OUTPUT       {/tb_top/dut_top/main/TASK_MODULE[4]/genblk1/dir_detector_u/task_4_output/*}

add wave -noupdate -expand -group TASK_MODULE_5 -group INPUT   {/tb_top/dut_top/main/TASK_MODULE[5]/genblk1/bin2bcd_u/task_5_input/*}
add wave -noupdate -expand -group TASK_MODULE_5 -group BIN2BCD {/tb_top/dut_top/main/TASK_MODULE[5]/genblk1/bin2bcd_u/binary2bcd/*}
add wave -noupdate -expand -group TASK_MODULE_5 -group OUTPUT  {/tb_top/dut_top/main/TASK_MODULE[5]/genblk1/bin2bcd_u/task_5_output/*}

add wave -noupdate -expand -group TASK_MODULE_6 -group INPUT    {/tb_top/dut_top/main/TASK_MODULE[6]/genblk1/enc_3b4b_u/task_6_input/*}
add wave -noupdate -expand -group TASK_MODULE_6 -group ENC_3B4B {/tb_top/dut_top/main/TASK_MODULE[6]/genblk1/enc_3b4b_u/u_enc_3b4b/*}
add wave -noupdate -expand -group TASK_MODULE_6 -group OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[6]/genblk1/enc_3b4b_u/task_6_output/*}

add wave -noupdate -expand -group TASK_MODULE_7 -group INPUT    {/tb_top/dut_top/main/TASK_MODULE[7]/genblk1/enc_5b6b_u/task_7_input/*}
add wave -noupdate -expand -group TASK_MODULE_7 -group ENC_5B6B {/tb_top/dut_top/main/TASK_MODULE[7]/genblk1/enc_5b6b_u/u_enc_5b6b/*}
add wave -noupdate -expand -group TASK_MODULE_7 -group OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[7]/genblk1/enc_5b6b_u/task_7_output/*}

add wave -noupdate -expand -group TASK_MODULE_8 -group INPUT     {/tb_top/dut_top/main/TASK_MODULE[8]/genblk1/butterfly_u/task_8_input/*}
add wave -noupdate -expand -group TASK_MODULE_8 -group BUTTERFLY {/tb_top/dut_top/main/TASK_MODULE[8]/genblk1/butterfly_u/butterfly/*}
add wave -noupdate -expand -group TASK_MODULE_8 -group OUTPUT    {/tb_top/dut_top/main/TASK_MODULE[8]/genblk1/butterfly_u/task_8_output/*}

add wave -noupdate -expand -group TASK_MODULE_9 -group INPUT      {/tb_top/dut_top/main/TASK_MODULE[9]/genblk1/recip_sqrt_u/task_9_input/*}
add wave -noupdate -expand -group TASK_MODULE_9 -group RECIP_SQRT {/tb_top/dut_top/main/TASK_MODULE[9]/genblk1/recip_sqrt_u/reciprocal_sqrt/*}
add wave -noupdate -expand -group TASK_MODULE_9 -group OUTPUT     {/tb_top/dut_top/main/TASK_MODULE[9]/genblk1/recip_sqrt_u/task_9_output/*}

add wave -noupdate -expand -group TASK_MODULE_10 -group INPUT    {/tb_top/dut_top/main/TASK_MODULE[10]/genblk1/demod_16_u/task_10_input/*}
add wave -noupdate -expand -group TASK_MODULE_10 -group DEMOD_16 {/tb_top/dut_top/main/TASK_MODULE[10]/genblk1/demod_16_u/demod16/*}
add wave -noupdate -expand -group TASK_MODULE_10 -group OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[10]/genblk1/demod_16_u/task_10_output/*}

add wave -noupdate -divider TB
add wave -noupdate -group -expand TB -group TB_TOP /tb_top/*
add wave -noupdate -group -expand TB -group HACK_IF /tb_top/m_if/*
