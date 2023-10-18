/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_base_test.sv
* Creation Date : 21-07-2023
* Last Modified : 16-08-2023 17:04:05
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_BASE_TEST_SV
`define APB_BASE_TEST_SV

class apb_base_test extends uvm_test;

    //factory registration
    `uvm_component_utils(apb_base_test)

    //files
    apb_env env_h;

    //virtual interface
    virtual apb_inf vif; 

    //function new
    function new(string name="apb_base_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = apb_env::type_id::create("env_h",this);

    endfunction: build_phase   

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    /*
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
            
            //create the sequences
            mseq_h = apb_master_seqs::type_id::create("mseq_h");
            //rseq_h = apb_master_rseqs::type_id::create("rseq_h");
            sseqs_h = apb_slave_base_seqs::type_id::create("sseqs_h");
               

            //start the sequences
            fork
                mseq_h.start(env_h.master_uvc.m_agt[0].seqr_h);
                //rseq_h.start(env_h.master_uvc.m_agt[0].seqr_h);
                sseqs_h.start(env_h.slave_uvc.s_agt[0].seqr_h);
            join_any
        phase.drop_objection(this);
    endtask
    */

endclass: apb_base_test

`endif
