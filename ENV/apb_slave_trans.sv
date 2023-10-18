/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_trans.sv
* Creation Date : 21-07-2023
* Last Modified : 03-08-2023 15:59:58
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_TRANS_SV
`define APB_SLAVE_TRANS_SV

class apb_slave_trans extends uvm_sequence_item;

    //signal list stored by slave
    
    //master signals
    bit pwrite;
    bit [`ADDR_WIDTH-1:0] paddr;
    bit [`DATA_WIDTH-1:0] pwdata;
    bit [`DATA_WIDTH-1:0] prdata;
    bit pslverr;
    

    //factory registration
    `uvm_object_utils_begin(apb_slave_trans)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(prdata, UVM_ALL_ON)
        `uvm_field_int(pslverr, UVM_ALL_ON)
    `uvm_object_utils_end

    //function new
    function new(string name="apb_slave_trans");
        super.new(name);
    endfunction
    

endclass

`endif
