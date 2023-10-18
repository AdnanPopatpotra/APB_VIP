/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_agent.sv
* Creation Date : 21-07-2023
* Last Modified : 11-09-2023 14:58:04
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_AGENT_SV
`define APB_MASTER_AGENT_SV

class apb_master_agent extends uvm_agent;

    //factory registration
    `uvm_component_utils(apb_master_agent)

    uvm_analysis_port #(apb_master_trans) item_req_port_b;
    
    function new(string name="apb_master_agent",uvm_component parent);
        super.new(name,parent);
        item_req_port_b = new("item_req_port_b",this);
    endfunction

    //virtual interface
    virtual apb_inf vif;            //virtual interface
    apb_master_config m_cnfg;       //master configure file
    
    //file instantiation
    apb_master_drv drv_h;
    apb_master_mon mon_h;
    apb_master_seqr seqr_h;

    //build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   
        //getting the configuration file
        if(!uvm_config_db #(apb_master_config)::get(this,"*","m_config",m_cnfg))
            `uvm_fatal("MASTER_AGENT","master config file not get in master agent")
        
        //getting the interface from top
        if(!uvm_config_db #(virtual apb_inf)::get(this,"*","inf",vif))
            `uvm_fatal("MASTER_AGENT","config db file not get in master agent")

        //if master agent active, creating the driver and sequencer also
        if(m_cnfg.is_active == UVM_ACTIVE)
          begin  
            drv_h = apb_master_drv::type_id::create("drv_h",this);
            seqr_h = apb_master_seqr::type_id::create("seqr_h",this);
          end

          mon_h = apb_master_mon::type_id::create("mon_h",this);
    endfunction:build_phase

    //connect phase
    function void connect_phase(uvm_phase phase);
        if(m_cnfg.is_active == UVM_ACTIVE)
          begin
            drv_h.seq_item_port.connect(seqr_h.seq_item_export);
            drv_h.vif = vif;
          end
         
          mon_h.item_req_port_a.connect(item_req_port_b);
          mon_h.vif = vif;
    endfunction: connect_phase

endclass: apb_master_agent


`endif
