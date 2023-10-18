/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_seqr.sv
* Creation Date : 21-07-2023
* Last Modified : 27-07-2023 08:21:41
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_SEQR_SV
`define APB_SLAVE_SEQR_SV

class apb_slave_seqr extends uvm_sequencer #(apb_slave_trans);

    //factory registration
    `uvm_component_utils(apb_slave_seqr)

    //here monitor and slave are in same hierarchy then also using export because we don't want to use the write method
    //which is mandatory while using the implimation port
    uvm_analysis_export #(apb_slave_trans) item_export;
    uvm_tlm_analysis_fifo #(apb_slave_trans) item_collect_fifo;

    //function new
    function new(string name="apb_slave_seqr",uvm_component parent);
        super.new(name,parent);
        item_export = new("item_export",this);
        item_collect_fifo = new("item_collect_fifo",this);
    endfunction

    //connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        item_export.connect(item_collect_fifo.analysis_export);
    endfunction

endclass

`endif
