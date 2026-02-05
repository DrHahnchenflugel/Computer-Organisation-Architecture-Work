onerror {quit -f}
vlib work
vlog -work work lab3a.vo
vlog -work work lab3a.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.ALU_vlg_vec_tst
vcd file -direction lab3a.msim.vcd
vcd add -internal ALU_vlg_vec_tst/*
vcd add -internal ALU_vlg_vec_tst/i1/*
add wave /*
run -all
