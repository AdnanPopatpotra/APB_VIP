/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_mon.sv
* Creation Date : 21-07-2023
* Last Modified : 11-09-2023 14:41:06
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_MON_SV
`define APB_MASTER_MON_SV

class apb_master_mon extends uvm_monitor;

    //factory registration
    `uvm_component_utils(apb_master_mon)

    //virtual interface
    virtual apb_inf vif;

    //transaction packet
    apb_master_trans req;

    uvm_analysis_port #(apb_master_trans) item_req_port_a;

    //function new
    function new(string name="apb_master_mon",uvm_component parent);
        super.new(name,parent);
        item_req_port_a = new("item_req_port_a",this);
    endfunction

    //build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        req = apb_master_trans::type_id::create("req");
    endfunction

    //run phase
    task run_phase(uvm_phase phase);
        forever @(posedge vif.penable == 1'b1) begin
            if(vif.pwrite==1'b1) begin
                #1;
                req.pwrite = vif.mas_mon_cb.pwrite;
                req.paddr  = vif.mas_mon_cb.paddr;
                req.pwdata = vif.mas_mon_cb.pwdata;
                item_req_port_a.write(req);
            end
        end
    endtask

endclass

`endif













/*
`ifndef APB_MASTER_MON_SV
`define APB_MASTER_MON_SV

class apb_master_mon extends uvm_monitor;

    //factory registration
    `uvm_component_utils(apb_master_mon)

    //virtual interface
    virtual apb_inf vif;

    //transaction packet
    apb_master_trans req;

    uvm_analysis_port #(apb_master_trans) item_req_port_a;

    //function new
    function new(string name="apb_master_mon",uvm_component parent);
        super.new(name,parent);
        item_req_port_a = new("item_req_port_a",this);
    endfunction

    //build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        req = apb_master_trans::type_id::create("req");
    endfunction

    //run phase
    task run_phase(uvm_phase phase);
        forever @(vif.mas_mon_cb) begin
            if(vif.pwrite==1'b1) begin
            req.pwrite = vif.mas_mon_cb.pwrite;
            req.paddr  = vif.mas_mon_cb.paddr;
            req.pwdata = vif.mas_mon_cb.pwdata;
            //req.prdata = vif.mas_mon_cb.prdata;
            item_req_port_a.write(req);
        end
        end
    endtask

endclass

`endif
*/
