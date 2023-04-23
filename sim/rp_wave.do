wave -vgroup TOP /tb_top/dut_top/*


wave -vgroup UART WRAPPER /tb_top/dut_top/uart_wrapper/*


wave -expand -vgroup HACK_CONTROL \
	( -vgroup MAC \
		( -vgroup WRAPPER /tb_top/dut_top/mac_wrapper/* ) \
		( -vgroup MAC_RX  /tb_top/dut_top/mac_wrapper/mac_rx/* ) \
		( -vgroup MAC_TX  /tb_top/dut_top/mac_wrapper/mac_tx/* ) \
	) \
	( -vgroup MHP          /tb_top/dut_top/main/task_manager/protocol/* ) \
	( -vgroup CONTROL      /tb_top/dut_top/main/* ) \
	( -vgroup TASK_MANAGER /tb_top/dut_top/main/task_manager/* ) \
	( -vgroup DEBUG_PORT   /tb_top/dut_top/main/debug_port/* )


wave -expand -vgroup TASK_IN_INTERFACES \
	( -vgroup TASK_IN_INTERFACE_1  {/tb_top/dut_top/main/tasks_in_interface[1]/*} ) \
	( -vgroup TASK_IN_INTERFACE_2  {/tb_top/dut_top/main/tasks_in_interface[2]/*} ) \
	( -vgroup TASK_IN_INTERFACE_3  {/tb_top/dut_top/main/tasks_in_interface[3]/*} ) \
	( -vgroup TASK_IN_INTERFACE_4  {/tb_top/dut_top/main/tasks_in_interface[4]/*} ) \
	( -vgroup TASK_IN_INTERFACE_5  {/tb_top/dut_top/main/tasks_in_interface[5]/*} ) \
	( -vgroup TASK_IN_INTERFACE_6  {/tb_top/dut_top/main/tasks_in_interface[6]/*} ) \
	( -vgroup TASK_IN_INTERFACE_7  {/tb_top/dut_top/main/tasks_in_interface[7]/*} ) \
	( -vgroup TASK_IN_INTERFACE_8  {/tb_top/dut_top/main/tasks_in_interface[8]/*} ) \
	( -vgroup TASK_IN_INTERFACE_9  {/tb_top/dut_top/main/tasks_in_interface[9]/*} ) \
	( -vgroup TASK_IN_INTERFACE_10 {/tb_top/dut_top/main/tasks_in_interface[10]/*} )


wave -expand -vgroup TASK_OUT_INTERFACES \
	( -vgroup TASK_OUT_INTERFACE_1  {/tb_top/dut_top/main/tasks_out_interface[1]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_2  {/tb_top/dut_top/main/tasks_out_interface[2]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_3  {/tb_top/dut_top/main/tasks_out_interface[3]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_4  {/tb_top/dut_top/main/tasks_out_interface[4]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_5  {/tb_top/dut_top/main/tasks_out_interface[5]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_6  {/tb_top/dut_top/main/tasks_out_interface[6]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_7  {/tb_top/dut_top/main/tasks_out_interface[7]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_8  {/tb_top/dut_top/main/tasks_out_interface[8]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_9  {/tb_top/dut_top/main/tasks_out_interface[9]/*} ) \
	( -vgroup TASK_OUT_INTERFACE_10 {/tb_top/dut_top/main/tasks_out_interface[10]/*} )


wave -named_row TASK_MODULES

wave -expand -vgroup TASK_MODULE_1 \
	( -vgroup INPUT    {/tb_top/dut_top/main/TASK_MODULE[1]/genblk1/rgb2gray_u/task_1_input/*} ) \
	( -vgroup RGB2GRAY {/tb_top/dut_top/main/TASK_MODULE[1]/genblk1/rgb2gray_u/rgb2gray/*} ) \
	( -vgroup OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[1]/genblk1/rgb2gray_u/task_1_output/*} )

wave -expand -vgroup TASK_MODULE_2 \
	( -vgroup INPUT       {/tb_top/dut_top/main/TASK_MODULE[2]/genblk1/line_buffer_u/task_2_input/*} ) \
	( -vgroup LINE_BUFFER {/tb_top/dut_top/main/TASK_MODULE[2]/genblk1/line_buffer_u/line_buffer/*} ) \
	( -vgroup OUTPUT      {/tb_top/dut_top/main/TASK_MODULE[2]/genblk1/line_buffer_u/task_2_output/*} )

wave -expand -vgroup TASK_MODULE_3 \
	( -vgroup INPUT       {/tb_top/dut_top/main/TASK_MODULE[3]/genblk1/conv_engine_u/task_3_input/*} ) \
	( -vgroup CONV_ENGINE {/tb_top/dut_top/main/TASK_MODULE[3]/genblk1/conv_engine_u/conv_engine/*} ) \
	( -vgroup OUTPUT      {/tb_top/dut_top/main/TASK_MODULE[3]/genblk1/conv_engine_u/task_3_output/*} )

wave -expand -vgroup TASK_MODULE_4 \
	( -vgroup INPUT        {/tb_top/dut_top/main/TASK_MODULE[4]/genblk1/dir_detector_u/task_4_input/*} ) \
	( -vgroup DIR_DETECTOR {/tb_top/dut_top/main/TASK_MODULE[4]/genblk1/dir_detector_u/dir_detector/*} ) \
	( -vgroup OUTPUT       {/tb_top/dut_top/main/TASK_MODULE[4]/genblk1/dir_detector_u/task_4_output/*} )

wave -expand -vgroup TASK_MODULE_5 \
	( -vgroup INPUT   {/tb_top/dut_top/main/TASK_MODULE[5]/genblk1/bin2bcd_u/task_5_input/*} ) \
	( -vgroup BIN2BCD {/tb_top/dut_top/main/TASK_MODULE[5]/genblk1/bin2bcd_u/binary2bcd/*} ) \
	( -vgroup OUTPUT  {/tb_top/dut_top/main/TASK_MODULE[5]/genblk1/bin2bcd_u/task_5_output/*} )

wave -expand -vgroup TASK_MODULE_6 \
	( -vgroup INPUT    {/tb_top/dut_top/main/TASK_MODULE[6]/genblk1/u_task_6/task_6_input/*} ) \
	( -vgroup ENC_3B4B {/tb_top/dut_top/main/TASK_MODULE[6]/genblk1/u_task_6/u_enc_3b4b/*} ) \
	( -vgroup OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[6]/genblk1/u_task_6/task_6_output/*} )

wave -expand -vgroup TASK_MODULE_7 \
	( -vgroup INPUT    {/tb_top/dut_top/main/TASK_MODULE[7]/genblk1/u_task_7/task_7_input/*} ) \
	( -vgroup ENC_5B6B {/tb_top/dut_top/main/TASK_MODULE[7]/genblk1/u_task_7/u_enc_5b6b/*} ) \
	( -vgroup OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[7]/genblk1/u_task_7/task_7_output/*} )

wave -expand -vgroup TASK_MODULE_8 \
	( -vgroup INPUT     {/tb_top/dut_top/main/TASK_MODULE[8]/genblk1/butterfly_u/task_8_input/*} ) \
	( -vgroup BUTTERFLY {/tb_top/dut_top/main/TASK_MODULE[8]/genblk1/butterfly_u/butterfly/*} ) \
	( -vgroup OUTPUT    {/tb_top/dut_top/main/TASK_MODULE[8]/genblk1/butterfly_u/task_8_output/*} )

wave -expand -vgroup TASK_MODULE_9 \
	( -vgroup INPUT      {/tb_top/dut_top/main/TASK_MODULE[9]/genblk1/recip_sqrt_u/task_9_input/*} ) \
	( -vgroup RECIP_SQRT {/tb_top/dut_top/main/TASK_MODULE[9]/genblk1/recip_sqrt_u/reciprocal_sqrt/*} ) \
	( -vgroup OUTPUT     {/tb_top/dut_top/main/TASK_MODULE[9]/genblk1/recip_sqrt_u/task_9_output/*} )

wave -expand -vgroup TASK_MODULE_10 \
	( -vgroup INPUT    {/tb_top/dut_top/main/TASK_MODULE[10]/genblk1/demod_16_u/task_10_input/*} ) \
	( -vgroup DEMOD_16 {/tb_top/dut_top/main/TASK_MODULE[10]/genblk1/demod_16_u/demod16/*} ) \
	( -vgroup OUTPUT   {/tb_top/dut_top/main/TASK_MODULE[10]/genblk1/demod_16_u/task_10_output/*} )


wave -expand -vgroup TB \
	( -vgroup TB_TOP  /tb_top/* ) \
	( -vgroup HACK_IF /tb_top/m_if/* )
