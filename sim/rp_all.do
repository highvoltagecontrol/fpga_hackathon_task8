# HACKATHON ROOT DIR
if {![info exists HRD]} {
	set HRD ../..
}

alib work
adel -all -lib work

do "$HRD/sim/rp_design.do"
do "$HRD/sim/rp_tb_sim.do"
