/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_sim_wr_rd_tc.sv
* Creation Date : 02-08-2023
* Last Modified : 02-08-2023 18:55:16
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SIM_WR_RD_TC_SV
`define APB_SIM_WR_RD_TC_SV

class apb_sim_wr_rd_tc extends apb_base_test;

    //factory registration
    `uvm_component_utils(apb_sim_wr_rd_tc)
    
    //master sequence
    apb_mas_sim_wr_rd_seqs mseqs_h;

    //slave sequence
    apb_slave_base_seqs sseqs_h; 

    //function new
    function new(string name="apb_sim_wr_rd_tc",uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        //create the sequences
        mseqs_h = apb_mas_sim_wr_rd_seqs::type_id::create("mseqs_h",this);
        sseqs_h = apb_slave_base_seqs::type_id::create("sseqs_h",this);

        //start the sequences
        fork
            mseqs_h.start(env_h.master_uvc.m_agt[0].seqr_h);
            sseqs_h.start(env_h.slave_uvc.s_agt[0].seqr_h); 
        join_any

        phase.drop_objection(this);
        
    endtask

endclass 

`endif
