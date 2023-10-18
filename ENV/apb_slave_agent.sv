/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_agent.sv
* Creation Date : 21-07-2023
* Last Modified : 28-07-2023 11:59:44
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_AGENT_SV
`define APB_SLAVE_AGENT_SV

class apb_slave_agent extends uvm_agent;

    //factory registration
    `uvm_component_utils(apb_slave_agent)

    uvm_analysis_port #(apb_slave_trans) item_req_port;

    function new(string name="apb_slave_agent",uvm_component parent);
        super.new(name,parent);
        item_req_port = new("item_req_port",this);
    endfunction

    //virtual interface
    virtual apb_inf vif;            //virtual interface
    apb_slave_config m_cnfg;       //master configure file
    
    //file instantiation
    apb_slave_drv drv_h;
    apb_slave_mon mon_h;
    apb_slave_seqr seqr_h;

    //build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    
        //getting the configuration file
        if(!uvm_config_db #(apb_slave_config)::get(this,"*","m_config",m_cnfg))
            `uvm_fatal(get_type_name,"slave config file not get in slave agent")
        
        //getting the interface from top
        if(!uvm_config_db #(virtual apb_inf)::get(this,"*","inf",vif))
            `uvm_fatal(get_type_name(),"config db file not get in slave agent")

        //if slave agent active, creating the driver and sequencer also
        if(m_cnfg.is_active == UVM_ACTIVE)
          begin  
            drv_h = apb_slave_drv::type_id::create("drv_h",this);
            seqr_h = apb_slave_seqr::type_id::create("seqr_h",this);
          end

          mon_h = apb_slave_mon::type_id::create("mon_h",this);
    endfunction:build_phase


    //connect phase
    function void connect_phase(uvm_phase phase);
        if(m_cnfg.is_active == UVM_ACTIVE)
          begin
            drv_h.seq_item_port.connect(seqr_h.seq_item_export);
            drv_h.vif = vif;
            mon_h.item_collect_port.connect(seqr_h.item_export);
          end
          mon_h.item_req_port.connect(item_req_port);
          mon_h.vif = vif;
    endfunction: connect_phase

endclass: apb_slave_agent

`endif
