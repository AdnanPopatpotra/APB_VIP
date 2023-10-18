/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_mas_simple_write_seqs.sv
* Creation Date : 23-07-2023
* Last Modified : 11-09-2023 14:57:22
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MAS_SIMPLE_WRITE_SEQS_SV
`define APB_MAS_SIMPLE_WRITE_SEQS_SV

class apb_mas_simple_write_seqs extends uvm_sequence #(apb_master_trans);

    //factory registration
    `uvm_object_utils(apb_mas_simple_write_seqs)

    //sequence item
    apb_master_trans req;

    virtual apb_inf vif;            //virtual interface
    
    //function new
    function new(string name="apb_mas_simple_write_seqs");
        super.new(name);
    endfunction

    task body();
    repeat(10)                                                              //performing write operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant  
            if(!req.randomize with { pwrite == 1'b1; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")
            send_request(req);                                              //send data
            wait_for_item_done();                                           //waiting for confirmation from driver
       end 

   endtask 

   
endclass

`endif
