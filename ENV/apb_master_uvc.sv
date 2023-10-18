/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_uvc.sv
* Creation Date : 21-07-2023
* Last Modified : 11-09-2023 14:58:27
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_UVC_SV
`define APB_MASTER_UVC_SV

class apb_master_uvc extends uvm_agent;

    //factory registration
    `uvm_component_utils(apb_master_uvc)

    apb_master_config m_cnfg;       //master configure file
    apb_master_agent m_agt[];       //array for creating number of agents

    uvm_analysis_port #(apb_master_trans) item_req_port_c;

    //function new
    function new(string name="apb_master_uvc",uvm_component parent);
        super.new(name,parent);
        item_req_port_c = new("item_req_port_c",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_cnfg = apb_master_config ::type_id::create("m_cnfg",this);            //create master config class
        uvm_config_db #(apb_master_config)::set(this,"*","m_config",m_cnfg);    //set master config so that to get in agent
    
        m_agt = new[m_cnfg.no_of_agents];                                   //deciding number of agents

        //creating all the agents
        foreach(m_agt[i]) begin m_agt[i] = apb_master_agent::type_id::create($sformatf("master_agt[%0d]",i),this);  end      
    endfunction

    function void connect_phase(uvm_phase phase);
        m_agt[0].item_req_port_b.connect(item_req_port_c);
    endfunction

endclass

`endif
