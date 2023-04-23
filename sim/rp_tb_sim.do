# HACKATHON ROOT DIR
if {![info exists HRD]} {
	set HRD ../..
}

# TESTBENCH
alog -dbg -quiet \
	"$HRD/tb/hack_if.sv" \
	"$HRD/tb/hack_pkg.sv" \
	"$HRD/tb/tb_top.sv"

# SIMULATION
asim -dbg +access +r \
	-L lpm_ver -L altera_mf_ver -L hackathon -L altera_ver -L sgate_ver  -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver\
	tb_top

do "$HRD/sim/rp_wave.do"
