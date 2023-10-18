/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_pkg.sv
* Creation Date : 21-07-2023
* Last Modified : 06-09-2023 10:23:02
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

//interface
`include "apb_inf.sv"
//`include "apb_assert_inf.sv"

package apb_pkg;

    //`include "uvm_macros.svh"
    import uvm_pkg::*;
  
    //define file
    `include "apb_defines.sv"
   
    //callback for error injection
    `include "slv_drv_callback.sv"

    //sequence item/transaction 
    `include "apb_master_trans.sv"
    `include "apb_slave_trans.sv"
    
    //sequencers
    `include "apb_master_seqr.sv"
    `include "apb_slave_seqr.sv"

    //drivers
    `include "apb_master_drv.sv"
    `include "apb_slave_drv.sv"

    //monitors
    `include "apb_master_mon.sv"
    `include "apb_slave_mon.sv"

    //config files
    `include "apb_master_config.sv"
    `include "apb_slave_config.sv"

    //agents
    `include "apb_master_agent.sv"
    `include "apb_slave_agent.sv"

    //UVC files
    `include "apb_master_uvc.sv"
    `include "apb_slave_uvc.sv"
    
    //scoreboard
    `include "apb_scoreboard.sv"

    //subscriber -> coverage collector
    `include "apb_subscriber.sv"
    
    //environment
    `include "apb_env.sv"

    //sequences
    `include "apb_mas_simple_write_seqs.sv"         //just write seqs
    `include "apb_mas_simple_read_seqs.sv"          //just read seqs
    `include "apb_mas_write_read_seqs.sv"           //write then read seqs
    `include "apb_mas_sim_wr_rd_seqs.sv"            //back to back write read
    `include "apb_slave_base_seqs.sv"               //slave seqs containing memory
    `include "apb_mas_ready_wait_seqs.sv"           //wait for ready scenario


    //testcases
    `include "apb_base_test.sv"
    `include "apb_simple_wr_tc.sv"
    `include "apb_simple_rd_tc.sv"
    `include "apb_write_read_tc.sv"
    `include "apb_sim_wr_rd_tc.sv"
    `include "apb_ready_wait_tc.sv"

endpackage


