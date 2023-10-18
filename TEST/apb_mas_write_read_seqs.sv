/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_mas_write_read_seqs.sv
* Creation Date : 02-08-2023
* Last Modified : 11-09-2023 14:56:13
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MAS_WRITE_READ_SEQS_SV
`define APB_MAS_WRITE_READ_SEQS_SV

class apb_mas_write_read_seqs extends uvm_sequence #(apb_master_trans);

    //factory registration
    `uvm_object_utils(apb_mas_write_read_seqs)

    //sequence item
    apb_master_trans req;

    virtual apb_inf vif;            //virtual interface
    
    //function new
    function new(string name="apb_mas_write_read_seqs");
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
    
    repeat(10)                                                              //performing read operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant  
            if(!req.randomize with { pwrite == 1'b0; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")
            send_request(req);                                              //send data
            wait_for_item_done();                                           //waiting for confirmation from driver
       end 

    repeat(10)                                                              //performing write operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant  
            if(!req.randomize with { pwrite == 1'b1; } )                    //randomize
                `uvm_fatal( get_type_name(),"Sequence not randomized")
            send_request(req);                                              //send data
            wait_for_item_done();                                           //waiting for confirmation from driver
       end 
    
    repeat(10)                                                              //performing read operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant  
            if(!req.randomize with { pwrite == 1'b0; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")
            send_request(req);                                              //send data
            wait_for_item_done();                                           //waiting for confirmation from driver
       end

        begin
            `uvm_do_with(req, {pwrite == 1'b1; pwdata == 8'b10101010; } );
        end

        begin
            `uvm_do_with(req, {pwrite == 1'b1; pwdata == 8'b01010101; } );  
        end

    repeat(40)                                                              //performing write operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant  
            if(!req.randomize with { pwrite == 1'b1; } )                    //randomize
                `uvm_fatal( get_type_name(),"Sequence not randomized")
            send_request(req);                                              //send data
            wait_for_item_done();                                           //waiting for confirmation from driver
       end 
    
    repeat(40)                                                              //performing read operation 10 times
       begin 
            req = apb_master_trans::type_id::create("req");
            wait_for_grant();                                               //wait for grant  
            if(!req.randomize with { pwrite == 1'b0; } )                    //randomize
                `uvm_fatal(get_type_name(),"Sequence not randomized")
            send_request(req);                                              //send data
            wait_for_item_done();                                           //waiting for confirmation from driver
       end

        begin
            `uvm_do_with(req, {pwrite == 1'b1; paddr == `ADDR_WIDTH'd15; } );
        end

        begin
            `uvm_do_with(req, {pwrite == 1'b1; pwdata == `ADDR_WIDTH'd15; } );  
        end

   endtask 

   
endclass

`endif
