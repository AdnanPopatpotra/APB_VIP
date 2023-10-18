/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_uvc.sv
* Creation Date : 21-07-2023
* Last Modified : 11-09-2023 14:58:51
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_UVC_SV
`define APB_SLAVE_UVC_SV

class apb_slave_uvc extends uvm_agent;

    //factory registration
    `uvm_component_utils(apb_slave_uvc)

    apb_slave_config m_cnfg;       //master configure file
    apb_slave_agent s_agt[];       //array for creating number of agents

    uvm_analysis_port #(apb_slave_trans) item_req_port;

    //function new
    function new(string name="apb_slave_uvc",uvm_component parent);
        super.new(name,parent);
        item_req_port = new("item_req_port",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_cnfg = apb_slave_config ::type_id::create("m_cnfg",this);            //create master config class
        uvm_config_db #(apb_slave_config)::set(this,"*","m_config",m_cnfg);    //set master config so that to get in agent
    
        s_agt = new[m_cnfg.no_of_agents];                                   //deciding number of agents

        //creating all the agents
        foreach(s_agt[i]) begin s_agt[i] = apb_slave_agent::type_id::create($sformatf("slave_agt[%0d]",i),this);  end     
    endfunction

    function void connect_phase(uvm_phase phase);
        s_agt[0].item_req_port.connect(item_req_port);
    endfunction

endclass

`endif
