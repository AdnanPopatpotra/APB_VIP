/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_env.sv
* Creation Date : 21-07-2023
* Last Modified : 07-09-2023 18:30:15
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_ENV_SV
`define APB_ENV_SV

class apb_env extends uvm_env;

    //factory registration
    `uvm_component_utils(apb_env)

    //components instantiation
    apb_master_uvc master_uvc;
    apb_slave_uvc slave_uvc;
    apb_scoreboard apb_sb;
    apb_subscriber apb_subs;

    //function new
    function new(string name="apb_env",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        master_uvc = apb_master_uvc::type_id::create("master_uvc",this);
        slave_uvc = apb_slave_uvc::type_id::create("slave_uvc",this);
        apb_sb = apb_scoreboard::type_id::create("apb_sb",this);
        apb_subs = apb_subscriber::type_id::create("apb_subs",this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        master_uvc.item_req_port_c.connect(apb_sb.mas_item_collect_imp);        //master to scoreboard connection
        slave_uvc.item_req_port.connect(apb_sb.slv_item_collect_imp);           //slave to scoreboard connection
        slave_uvc.s_agt[0].mon_h.item_collect_port.connect(apb_subs.analysis_export);   //slave to subscriber class connection          
        master_uvc.m_agt[0].drv_h.put_port.connect(apb_sb.put_imp);             //driver to scoreboard connection for pwdata
       
        // master_uvc.m_agt[0].mon_h.item_req_port_a.connect(apb_subs.analysis_export);              //master to subscriber class connection          
    endfunction 

endclass: apb_env

`endif
