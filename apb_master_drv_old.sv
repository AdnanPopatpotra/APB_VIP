/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_drv.sv
* Creation Date : 20-07-2023
* Last Modified : 26-07-2023 11:03:42
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_DRV_SV
`define APB_MASTER_DRV_SV

class apb_master_drv extends uvm_driver #(apb_master_trans);

    //factory registration
    `uvm_component_utils(apb_master_drv)

    //function new
    function new(string name="apb_master_drv",uvm_component parent);
        super.new(name,parent);
    endfunction
    
    //virtual interface's Driver Modport
    virtual apb_inf.MDRV_MP vif;
    
    //transaction instantiation
    apb_master_trans req;

        
    //build phase
    function void build_phase(uvm_phase phase);
       super.build_phase(phase); 
    endfunction
    
    task run_phase(uvm_phase phase);
        forever 
        begin

          fork
            
            begin 
                wait(!vif.mas_drv_cb.presetn);          //for checking reset;
            end            
            
            forever begin 
                seq_item_port.get_next_item(req);       //waiting to get the data
                send_to_dut(req);                       //send to dut task
                seq_item_port.item_done();              //item done call
            end
        
          join_any
        disable fork;
        reset_assert();
        wait(vif.mas_drv_cb.presetn == 1'b1);

        send_to_dut(req);
        seq_item_port.item_done();                      //item done call
        end
    endtask
   
    task send_to_dut(apb_master_trans req);
        req.print();
        if(vif.mas_drv_cb.psel !== 1) 
        begin
            @(vif.mas_drv_cb)                            //first posedge of clock
            vif.mas_drv_cb.psel <= 1'b1; 
            write_data();                               //task to perform write operation to dut 
        end
        write_data();
        @(vif.mas_drv_cb)                               //second posedge of clock
        vif.mas_drv_cb.penable <= 1'b1;
        wait(vif.mas_drv_cb.pready == 1'b1);
        
        if(vif.mas_drv_cb.psel == 1'b1) 
        begin
            @(vif.mas_drv_cb)
            vif.mas_drv_cb.penable <= 1'b0;
            write_data();                               //task to perform write operation to dut
        end
                    
        else
        begin
            @(vif.mas_drv_cb) 
            vif.mas_drv_cb.penable <= 1'b0;
            vif.mas_drv_cb.psel    <= 1'b0;
        end
    endtask
    
    task write_data();                                  //task for sending data
        if(req.pwrite == 1'b1)
        begin
            vif.mas_drv_cb.pwrite  <= req.pwrite;
            vif.mas_drv_cb.paddr   <= req.paddr;
            vif.mas_drv_cb.pwdata  <= req.pwdata;
        end
        else 
        begin
            vif.mas_drv_cb.paddr <= req.paddr;
        end
    endtask

    task reset_assert();                                //reset asserting task
        vif.mas_drv_cb.penable <= 1'b0;
        vif.mas_drv_cb.pwrite  <= 1'b0;
        vif.mas_drv_cb.psel    <= 1'b0;
    endtask



endclass

`endif

