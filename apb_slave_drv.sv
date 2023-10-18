/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_drv.sv
* Creation Date : 21-07-2023
* Last Modified : 31-07-2023 18:21:20
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_DRV_SV
`define APB_SLAVE_DRV_SV

class apb_slave_drv extends uvm_driver #(apb_slave_trans);

    //factory registration
    `uvm_component_utils(apb_slave_drv)

    //function new
    function new(string name="apb_slave_drv",uvm_component parent);
        super.new(name,parent);
        //req = apb_slave_trans::type_id::create("req");
    endfunction
    
    //virtual interface
    virtual apb_inf vif;
    //transaction instantiation
    apb_slave_trans req;
    
    bit count;

    //build phase
    function void build_phase(uvm_phase phase);
       super.build_phase(phase); 
    endfunction

    task run_phase(uvm_phase phase);
        //forever begin
          fork
            begin
                vif.slv_drv_cb.pready <= 1'b1;
                #290;
                vif.slv_drv_cb.pready <= 1'b0;              //driving the pready signal
                #30;
                vif.slv_drv_cb.pready <= 1'b1;
            end
            
            begin
                wait(!vif.slv_drv_cb.presetn);
            end
            forever begin
                //vif.slv_drv_cb.pready <= 1'b1;
                //if(vif.slv_drv_cb.psel==1'b1) 
                  //  @(vif.slv_drv_cb)
                    //wait(vif.slv_drv_cb.penable==1'b1)  
                wait(vif.pready==1); 
                seq_item_port.get_next_item(req);           //waiting for transaction

                if(req != null) begin                       //condition for checking in case of no transaction
                    count = 1;
                    send_to_dut(req);                       //responding back to master
                    seq_item_port.item_done();              //item done call
                end
            
            end
          join_any;
            wait(!vif.slv_drv_cb.presetn) begin
                if(count) begin
                    if(req.pwrite==0)
                        vif.slv_drv_cb.pready <= 1'b0;
                end
            end

            wait(vif.slv_drv_cb.presetn) begin
                if(count) begin
                    if(req.pwrite==0)
                        vif.slv_drv_cb.pready <= 1'b1;
                end
            end
            
        //end
    endtask

    task send_to_dut(apb_slave_trans req);
             wait(vif.slv_drv_cb.pready);
             vif.slv_drv_cb.prdata <= req.prdata;       //sending the required data to master
    endtask
   
endclass

`endif
