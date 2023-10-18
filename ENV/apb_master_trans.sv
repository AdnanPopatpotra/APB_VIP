/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_trans.sv
* Creation Date : 19-07-2023
* Last Modified : 11-09-2023 14:57:39
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_TRANS_SV
`define APB_MASTER_TRANS_SV

class apb_master_trans extends uvm_sequence_item;

    //signal list driven by master
    
    //master signals
    rand bit pwrite;
    rand bit [`ADDR_WIDTH-1:0] paddr;
    rand bit [`DATA_WIDTH-1:0] pwdata;
    bit [`DATA_WIDTH-1:0] prdata;
   
    //slave signals for monitoring in the scoreboard
    bit pslverr;

    //factory registration
    `uvm_object_utils_begin(apb_master_trans)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(pslverr, UVM_ALL_ON)
    `uvm_object_utils_end

    //function new
    function new(string name="apb_master_trans");
        super.new(name);
    endfunction
       
endclass

`endif
