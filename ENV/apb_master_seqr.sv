/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_master_seqr.sv
* Creation Date : 20-07-2023
* Last Modified : 21-07-2023 16:24:38
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_MASTER_SEQR_SV
`define APB_MASTER_SEQR_SV

class apb_master_seqr extends uvm_sequencer #(apb_master_trans);

    //factory registration
    `uvm_component_utils(apb_master_seqr)

    //function new
    function new(string name="apb_master_seqr",uvm_component parent);
        super.new(name,parent);
    endfunction

endclass

`endif
