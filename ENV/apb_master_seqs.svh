/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_seqs.sv
* Creation Date : 23-07-2023
* Last Modified : 02-08-2023 11:00:58
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_SEQS_SV
`define APB_MASTER_SEQS_SV

class apb_master_base_seqs extends uvm_sequence #(apb_master_trans);

    //factory registration
    `uvm_object_utils(apb_master_base_seqs)

    //sequence item
    apb_master_trans req;

    virtual apb_inf vif;            //virtual interface
    
    //function new
    function new(string name="apb_master_base_seqs");
        super.new(name);
    endfunction

    /*task body();
        //if(!uvm_config_db#(virtual apb_inf)::get(null,"*","inf",vif))
          //  `uvm_fatal("SLV SEQS","Config db not get in master sequence")
    repeat(10)                                                              //performing write operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant  
            if(!req.randomize with { pwrite == 1'b1; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")
            send_request(req);                                              //send data
            wait_for_item_done();                                           //waiting for confirmation from driver
            `uvm_info(get_type_name(),"After wait for item done",UVM_LOW)
       end
    
    repeat(10)                                                              //performing read operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant
            if(!req.randomize with { pwrite == 1'b0; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")       //send data
            send_request(req);
            wait_for_item_done();                                           //waiting for confirmation from driver
            `uvm_info(get_type_name(),"After wait for item done",UVM_LOW)
       end

   */
        /*vif.reset();

    repeat(2)
        begin
            //req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant
            if(!req.randomize with { pwrite == 1'b1; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")       //send data
            send_request(req);
            wait_for_item_done();                                           //waiting for confirmation from driver
            `uvm_info(get_type_name(),"After wait for item done",UVM_LOW)
        end

        vif.reset();
    repeat(2)
        begin
            //req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant
            if(!req.randomize with { pwrite == 1'b0; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")       //send data
            send_request(req);
            wait_for_item_done();                                           //waiting for confirmation from driver
            `uvm_info(get_type_name(),"After wait for item done",UVM_LOW)
        end

    */

   endtask 

   
endclass

`endif
