/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: slv_drv_callback.sv
* Creation Date : 03-08-2023
* Last Modified : 11-09-2023 15:03:17
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

class slv_drv_callback extends uvm_callback;

    //factory registration
    `uvm_object_utils(slv_drv_callback)

    //virtual interface
    virtual apb_inf vif;

    bit flag;
    
    //static int flag=0;

    //function new
    function new(string name="slv_drv_callback");
        super.new(name);
    endfunction

    //virtual task 
    virtual task pready_control;
        if(!uvm_config_db #(virtual apb_inf)::get(null,"*","inf",vif))                //getting config db in callback class
            `uvm_fatal("SLV_DRV_CALLBACK","configDB not get in slv_drv_callback")

           if(flag==0) begin
              @(posedge vif.pclk)
              vif.pready <= 1'b0;
              #95 
              flag = 1;
          end
    endtask

endclass: slv_drv_callback
