/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_drv.sv
* Creation Date : 20-07-2023
* Last Modified : 11-09-2023 14:38:20
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_DRV_SV
`define APB_MASTER_DRV_SV

class apb_master_drv extends uvm_driver #(apb_master_trans);

    //factory registration
    `uvm_component_utils(apb_master_drv)

    //TLM port for sending data to scoreboard
    uvm_blocking_put_port #(apb_master_trans) put_port;

    //function new
    function new(string name="apb_master_drv",uvm_component parent);
        super.new(name,parent);
        put_port = new("put_port",this);
    endfunction
    
    //virtual interface's Driver Modport
    virtual apb_inf vif;
    
    //transaction instantiation
    apb_master_trans req;

    bit try;

    //build phase
    function void build_phase(uvm_phase phase);
       super.build_phase(phase); 
    endfunction
   
    //run phase
    task run_phase(uvm_phase phase);
        forever  
        begin

          fork
            
            begin 
                wait(!vif.presetn);                         //for checking reset;
            end            
            
            forever 
            begin 
                seq_item_port.try_next_item(req);           //trying to get the data
                try = 1;
                if(req != null) begin                       
                    send_to_dut(req);                       //send to dut task
                    seq_item_port.item_done();              //item done call
                end
                else begin                                  //scenario when no transaction occur
                    vif.mas_drv_cb.psel <= 1'b0;
                    vif.mas_drv_cb.penable <= 1'b0;
                end
            end
        
          join_any
        disable fork;
        reset_assert();                                     //reset asserted
        wait(vif.presetn);
        @(vif.mas_drv_cb)
        if(vif.mas_drv_cb.pready)
            vif.mas_drv_cb.penable<=1'b0;

        
        if(try == 1) begin
            try = 0;
            send_to_dut(req);                               //continuing to send the data again after the reset
            seq_item_port.item_done();                      //item done call after sending the data
        end
        end
    endtask
   
    task send_to_dut(apb_master_trans req);
        if(!vif.psel) 
        begin
            @(vif.mas_drv_cb)                               //first posedge of clock
            vif.mas_drv_cb.psel <= 1'b1;                    //sending the select signal
        end
        write_data();                                       //task to perform write operation to dut
        
        @(vif.mas_drv_cb)                                   //second posedge of clock
        vif.mas_drv_cb.penable <= 1'b1;                     //sending the enable signal
        wait(vif.pready);
        
        @(vif.mas_drv_cb)
        vif.mas_drv_cb.penable <= 1'b0;


   endtask
    
    task write_data();                                      //task for sending the data
        if(req.pwrite == 1'b1)
        begin
            vif.mas_drv_cb.pwrite  <= req.pwrite;
            vif.mas_drv_cb.paddr   <= req.paddr;
            vif.mas_drv_cb.pwdata  <= req.pwdata;
            if(try==1)
                put_port.put(req);
        end
        if(req.pwrite == 1'b0) 
        begin
            vif.mas_drv_cb.pwrite  <= req.pwrite;
            vif.mas_drv_cb.paddr <= req.paddr;
        end
    endtask

    task reset_assert();                                    //reset asserting task
        vif.psel    <= 1'b0;
        vif.penable <= 1'b0;
    endtask



endclass

`endif

