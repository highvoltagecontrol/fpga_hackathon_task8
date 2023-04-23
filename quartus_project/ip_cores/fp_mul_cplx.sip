set_global_assignment -entity "fp_mul_cplx" -library "lib_fp_mul_cplx" -name IP_TOOL_NAME "altera_fp_functions"
set_global_assignment -entity "fp_mul_cplx" -library "lib_fp_mul_cplx" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "fp_mul_cplx" -library "lib_fp_mul_cplx" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_fp_mul_cplx" -name SPD_FILE [file join $::quartus(sip_path) "fp_mul_cplx.spd"]

set_global_assignment -library "lib_fp_mul_cplx" -name MISC_FILE [file join $::quartus(sip_path) "fp_mul_cplx_sim/fp_mul_cplx.vo"]
