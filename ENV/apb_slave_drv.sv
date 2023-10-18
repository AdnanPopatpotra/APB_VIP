/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_drv.sv
* Creation Date : 21-07-2023
* Last Modified : 11-09-2023 14:39:41
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_DRV_SV
`define APB_SLAVE_DRV_SV

class apb_slave_drv extends uvm_driver #(apb_slave_trans);

    //factory registration
    `uvm_component_utils(apb_slave_drv)

    //registering the callbacks
    `uvm_register_cb(apb_slave_drv,slv_drv_callback)

    //function new
    function new(string name="apb_slave_drv",uvm_component parent);
        super.new(name,parent);
        //req = apb_slave_trans::type_id::create("req");
    endfunction
    
    //virtual interface
    virtual apb_inf vif;
    
    //transaction instantiation
    apb_slave_trans req;
    
    //build phase
    function void build_phase(uvm_phase phase);
       super.build_phase(phase); 
    endfunction

    task run_phase(uvm_phase phase);    
        forever
        begin
            
            fork
                begin
                    wait(!vif.presetn);
                end

                forever
                begin
                    wait(vif.slv_drv_cb.psel==1'b1)
                    wait(vif.slv_drv_cb.penable==1'b1)         
                    `uvm_do_callbacks(apb_slave_drv,slv_drv_callback,pready_control);
                    vif.slv_drv_cb.pready <= 1'b1;
                    seq_item_port.get_next_item(req);
                    send_to_dut(req);
                    seq_item_port.item_done();
                end
            join_any
            disable fork;
                vif.pready <= 0;
            wait(vif.presetn==1) begin
                vif.pready <= 0;
            end
        end
        

    endtask

    task send_to_dut(apb_slave_trans req);
            vif.slv_drv_cb.pslverr <= req.pslverr;
        if(req.pwrite == 1'b0) begin
            vif.slv_drv_cb.prdata <= req.prdata;
        end
    endtask
   
endclass

`endif
