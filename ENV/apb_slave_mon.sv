/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_mon.sv
* Creation Date : 21-07-2023
* Last Modified : 11-09-2023 14:40:36
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_MON_SV
`define APB_SLAVE_MON_SV

class apb_slave_mon extends uvm_monitor;

    //factory registration
    `uvm_component_utils(apb_slave_mon)

    virtual apb_inf vif;

    //slave transaction
    apb_slave_trans trans_h;

    //analysis export for sending data to sequencer
    uvm_analysis_port #(apb_slave_trans) item_collect_port;         //for sending data to sequencer
    uvm_analysis_port #(apb_slave_trans) item_req_port;             //for sending data to scoreboard

    //function new
    function new(string name="apb_slave_mon",uvm_component this_parent);
        super.new(name,this_parent);
        trans_h = apb_slave_trans::type_id::create("trans_h");
        item_collect_port = new("item_collect_port",this);
        item_req_port = new("item_req_port",this);
    endfunction

    //run phase
    task run_phase(uvm_phase phase);
    forever @(posedge vif.penable == 1'b1)    //why doesn't @(posedge vif.slv_drv_cb.penable) works???? find out. 
        begin
                monitor_apb_data();                                     //sampling task
        end
        
    endtask
    
    task monitor_apb_data(); 
        begin
            case(vif.slv_mon_cb.pwrite)                             
            1'b1: begin
                    trans_h.pwrite = vif.slv_mon_cb.pwrite;         //in case of write sample write/read signal, address, write data
                    trans_h.paddr  = vif.slv_mon_cb.paddr;
                    trans_h.pwdata = vif.slv_mon_cb.pwdata;
                    item_collect_port.write(trans_h);
                  end
            
            1'b0: begin                                             //in case of write sample write/read signal, address
                    trans_h.pwrite = vif.slv_mon_cb.pwrite;             
                    trans_h.paddr  = vif.slv_mon_cb.paddr;
                    trans_h.prdata  = vif.slv_mon_cb.prdata;
                    trans_h.pslverr = vif.slv_mon_cb.pslverr;
                    item_collect_port.write(trans_h);
                    #1;
                    item_req_port.write(trans_h);

                    
                  end
            endcase
        end
    endtask

endclass

`endif
