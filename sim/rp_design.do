# HACKATHON ROOT DIR
if {![info exists HRD]} {
	set HRD ..
}

# TASKS
alog -dbg -quiet \
	"$HRD/tasks/task_pkg.sv"

alog -dbg -l altera_mf_ver \
	"$HRD/tasks/task_1/rgb2gray.sv" \
	"$HRD/tasks/task_1/task_1_input_fifo.v" \
	"$HRD/tasks/task_1/task_1_input.sv" \
	"$HRD/tasks/task_1/task_1_output_fifo.v" \
	"$HRD/tasks/task_1/task_1_output.sv" \
	"$HRD/tasks/task_1/task_1.sv"

alog -dbg -l lpm_ver -l altera_mf_ver \
	"$HRD/tasks/task_2/line_buffer.sv" \
	"$HRD/tasks/task_2/serializer_fifo.v" \
	"$HRD/tasks/task_2/one_hot.v" \
	"$HRD/tasks/task_2/serializer.sv" \
	"$HRD/tasks/task_2/task_2_input_fifo.v" \
	"$HRD/tasks/task_2/task_2_input.sv" \
	"$HRD/tasks/task_2/task_2_output_fifo.v" \
	"$HRD/tasks/task_2/task_2_output.sv" \
	"$HRD/tasks/task_2/task_2.sv"

alog -dbg -l lpm_ver -l altera_mf_ver \
	"$HRD/tasks/task_3/div.v" \
	"$HRD/tasks/task_3/conv_engine.sv" \
	"$HRD/tasks/task_3/task_3_input_fifo.v" \
	"$HRD/tasks/task_3/task_3_input.sv" \
	"$HRD/tasks/task_3/task_3_output_fifo.v" \
	"$HRD/tasks/task_3/task_3_output.sv" \
	"$HRD/tasks/task_3/task_3.sv"

alog -dbg -l altera_mf_ver \
	"$HRD/tasks/task_4/dir_detector.sv" \
	"$HRD/tasks/task_4/task_4_input_fifo.v" \
	"$HRD/tasks/task_4/task_4_input.sv" \
	"$HRD/tasks/task_4/task_4_output_fifo.v" \
	"$HRD/tasks/task_4/task_4_output.sv" \
	"$HRD/tasks/task_4/task_4.sv"

alog -dbg -l altera_mf_ver \
	"$HRD/tasks/task_5/binary_2_bcd.sv" \
	"$HRD/tasks/task_5/task_5_input_fifo.v" \
	"$HRD/tasks/task_5/task_5_input.sv" \
	"$HRD/tasks/task_5/task_5_output_fifo.v" \
	"$HRD/tasks/task_5/task_5_output.sv" \
	"$HRD/tasks/task_5/task_5.sv"

alog -dbg -l altera_mf_ver \
	"$HRD/tasks/task_6/encoder_3b4b.sv" \
	"$HRD/tasks/task_6/task_6_input_fifo.v" \
	"$HRD/tasks/task_6/task_6_input.sv" \
	"$HRD/tasks/task_6/task_6_output_fifo.v" \
	"$HRD/tasks/task_6/task_6_output.sv" \
	"$HRD/tasks/task_6/task_6.sv"

alog -dbg -l altera_mf_ver \
	"$HRD/tasks/task_7/encoder_5b6b.sv" \
	"$HRD/tasks/task_7/task_7_input_fifo.v" \
	"$HRD/tasks/task_7/task_7_input.sv" \
	"$HRD/tasks/task_7/task_7_output_fifo.v" \
	"$HRD/tasks/task_7/task_7_output.sv" \
	"$HRD/tasks/task_7/task_7.sv"

alog -dbg -l lpm_ver -l altera_mf_ver \
	"$HRD/tasks/task_8/butterfly.sv" \
	"$HRD/tasks/task_8/serializer_fifo_task_8.v" \
	"$HRD/tasks/task_8/one_hot_task_8.v" \
	"$HRD/tasks/task_8/task_8_serializer.sv" \
	"$HRD/tasks/task_8/task_8_input_fifo.v" \
	"$HRD/tasks/task_8/task_8_input.sv" \
	"$HRD/tasks/task_8/task_8_output_fifo.v" \
	"$HRD/tasks/task_8/task_8_output.sv" \
	"$HRD/tasks/task_8/task_8.sv"

alog -dbg -l lpm_ver -l altera_mf_ver \
	"$HRD/tasks/task_9/reciprocal_sqrt.sv" \
	"$HRD/tasks/task_9/serializer_fifo_task_9.v" \
	"$HRD/tasks/task_9/one_hot_task_9.v" \
	"$HRD/tasks/task_9/serializer.sv" \
	"$HRD/tasks/task_9/task_9_input_fifo.v" \
	"$HRD/tasks/task_9/task_9_input.sv" \
	"$HRD/tasks/task_9/task_9_output_fifo.v" \
	"$HRD/tasks/task_9/task_9_output.sv" \
	"$HRD/tasks/task_9/task_9.sv"

alog -dbg \
	"$HRD/tasks/task_10/demod16.sv" \
	"$HRD/tasks/task_10/task_10_input_fifo.v" \
	"$HRD/tasks/task_10/task_10_input.sv" \
	"$HRD/tasks/task_10/task_10_output_fifo.v" \
	"$HRD/tasks/task_10/task_10_output.sv" \
	"$HRD/tasks/task_10/task_10.sv"

# DESIGN
alog -dbg -quiet -l altera_mf_ver \
	"$HRD/src/uart_counter.sv" \
	"$HRD/src/uart_rx.sv" \
	"$HRD/src/uart_tx.sv" \
	"$HRD/src/uart_fifo.v" \
	"$HRD/src/uart_wrapper.sv" \
	"$HRD/src/crc.sv" \
	"$HRD/src/mac_rx.sv" \
	"$HRD/src/mac_tx.sv" \
	"$HRD/src/eth_fifo.v" \
	"$HRD/src/mac_wrapper.sv"

alog -dbg -quiet \
	"$HRD/src/reset_release.sv" \
	"$HRD/src/cdc_pipeline.sv" \
	"$HRD/src/mhp.sv" \
	"$HRD/src/task_manager.sv" \
	"$HRD/src/debug_port.v" \
	"$HRD/src/task_module.sv" \
	"$HRD/src/control.sv" \
	"$HRD/src/top.v"
