#makefile

PKG     = ..\TEST\apb_pkg.sv
INCLUDE = +incdir+..\ENV +incdir+..\TEST
TOP     = ..\TOP\apb_top.sv
TOP_N   = apb_top
#RTL     = ..\RTL\apb_mem.sv

#To make a work file
lib:
	vlib work
	
#To compoile the code
comp:
	vlog $(PKG) $(TOP) $(INCLUDE)
	
#To run the simulation in questasim
sim_write:
	vsim -assertdebug -novopt $(TOP_N) -do "do runsim.do apb_simple_wr_tc" 

#To run the simulation in commandprompt
sim_c_write:
	vsim -assertdebug -novopt $(TOP_N) -c -do "run -all; exit" +UVM_TESTNAME=apb_simple_wr_tc
	
#To run the simulation in questasim
sim_read:
	vsim -assertdebug -novopt $(TOP_N) -do "do runsim.do apb_simple_rd_tc" 

#To run the simulation in commandprompt
sim_c_read:
	vsim -assertdebug -novopt $(TOP_N) -c -do "run -all; exit" +UVM_TESTNAME=apb_simple_rd_tc

#To run the simulation in questasim
sim_write_read:
	vsim -assertdebug -novopt $(TOP_N) -do "do runsim.do apb_write_read_tc" 

#To run the simulation in commandprompt
sim_c_write_read:
	vsim -assertdebug -novopt $(TOP_N) -c -do "run -all; exit" +UVM_TESTNAME=apb_write_read_tc
	
#To run the simulation in questasim
sim_sim_wr_rd:
	vsim -assertdebug -novopt $(TOP_N) -do "do runsim.do apb_sim_wr_rd_tc" 

#To run the simulation in commandprompt
sim_c_sim_wr_rd:
	vsim -assertdebug -novopt $(TOP_N) -c -do "run -all; exit" +UVM_TESTNAME=apb_sim_wr_rd_tc
	
#To run the simulation in questasim
sim_ready_wait:
	vsim -assertdebug -novopt $(TOP_N) -do "do runsim.do apb_ready_wait_tc" 

#To run the simulation in commandprompt
sim_c_ready_wait:
	vsim -assertdebug -novopt $(TOP_N) -c -do "run -all; exit" +UVM_TESTNAME=apb_ready_wait_tc