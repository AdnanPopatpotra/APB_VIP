vlib work
vlog ../TEST/apb_pkg.sv ../TOP/apb_top.sv +incdir+../ENV +incdir+../TEST 
vsim -assertdebug -novopt apb_top +UVM_TESTNAME=$1 
add wave -position insertpoint sim:/apb_top/inf/*
add wave /apb_top/inf/penable_checking /apb_top/inf/penable_other_signal_stable /apb_top/inf/penable_checking1 /apb_top/inf/penable_zero_check /apb_top/inf/reset_assert_check /apb_top/inf/prot_addr_rw_check /apb_top/inf/read_only_addr_Wcheck /apb_top/inf/read_only_addr_Rcheck
config wave -signalnamewidth 1
run -all
wave zoom full
run