/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_config.sv
* Creation Date : 21-07-2023
* Last Modified : 10-08-2023 11:07:02
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_CONFIG_SV
`define APB_MASTER_CONFIG_SV

class apb_master_config extends uvm_object;

    //enum for controlling the agent type
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    //number of agents
    int no_of_agents=1;

    //factory registration
    `uvm_object_utils_begin(apb_master_config)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
        `uvm_field_int(no_of_agents, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="apb_master_config");
        super.new(name);
    endfunction

endclass

`endif
