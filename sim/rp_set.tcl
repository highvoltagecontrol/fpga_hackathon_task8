set_global_assignment -name EDA_SIMULATION_TOOL "Riviera-PRO (Verilog)"
set_global_assignment -name EDA_USER_COMPILED_SIMULATION_LIBRARY_DIRECTORY "/home/Aldec/Riviera-PRO-2022.10-x64/vlib" -section_id eda_simulation
set_global_assignment -name EDA_NETLIST_WRITER_OUTPUT_DIR ../sim/rivierapro -section_id eda_simulation
set_global_assignment -name EDA_SIMULATION_RUN_SCRIPT ../sim/rp_tb_sim.do -section_id eda_simulation
set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS COMMAND_MACRO_MODE -section_id eda_simulation
set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH tb_top -section_id eda_simulation
set_global_assignment -name EDA_TEST_BENCH_NAME tb_top -section_id eda_simulation
set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id tb_top
set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME tb_top -section_id tb_top
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top
