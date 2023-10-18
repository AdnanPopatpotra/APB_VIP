/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_ready_wait_tc.sv
* Creation Date : 03-08-2023
* Last Modified : 03-08-2023 15:09:33
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_READY_WAIT_TC_SV
`define APB_READY_WAIT_TC_SV

class apb_ready_wait_tc extends apb_base_test;

    //factory registration
    `uvm_component_utils(apb_ready_wait_tc)
    
    //master sequence
    apb_mas_ready_wait_seqs mseqs_h;

    //slave sequence
    apb_slave_base_seqs sseqs_h; 

    //callback class
    slv_drv_callback drv_call;
    
    //function new
    function new(string name="apb_ready_wait_tc",uvm_component parent);
        super.new(name,parent);
        //drv_call = new("drv_call");
    endfunction

    //build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        drv_call = slv_drv_callback::type_id::create("drv_call",this);

    endfunction

    //run phase
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        //create the sequences
        mseqs_h = apb_mas_ready_wait_seqs::type_id::create("mseqs_h",this);
        sseqs_h = apb_slave_base_seqs::type_id::create("sseqs_h",this);

        //start the sequences
    fork
        begin
            #255
            uvm_callbacks #(apb_slave_drv,slv_drv_callback)::add(env_h.slave_uvc.s_agt[0].drv_h,drv_call);
        end
        fork
            mseqs_h.start(env_h.master_uvc.m_agt[0].seqr_h);
            sseqs_h.start(env_h.slave_uvc.s_agt[0].seqr_h); 
        join_any
    join
        phase.drop_objection(this);
        
    endtask

endclass 

`endif
