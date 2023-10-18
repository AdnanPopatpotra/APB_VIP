/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_seqs.sv
* Creation Date : 23-07-2023
* Last Modified : 25-07-2023 23:15:59
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_RSEQS_SV
`define APB_MASTER_RSEQS_SV

class apb_master_rseqs extends uvm_sequence #(apb_master_trans);

    //factory registration
    `uvm_object_utils(apb_master_rseqs)

    //sequence item
    apb_master_trans req;

    //function new
    function new(string name="apb_master_rseqs");
        super.new(name);
    endfunction

    task body();
    repeat(10)
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();
            if(!req.randomize with { pwrite == 1'b0; } )
              `uvm_fatal(get_type_name(),"Sequence not randomized")
            send_request(req);
            wait_for_item_done();
            `uvm_info(get_type_name(),"After wait for item done",UVM_LOW)
       end
       
    endtask

endclass

`endif
