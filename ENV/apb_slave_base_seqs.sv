/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_slave_base_seqs.sv
* Creation Date : 27-07-2023
* Last Modified : 11-09-2023 14:45:58
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_SLAVE_BASE_SEQS_SV
`define APB_SLAVE_BASE_SEQS_SV

class apb_slave_base_seqs extends uvm_sequence #(apb_slave_trans);

    //factory registration
    `uvm_object_utils(apb_slave_base_seqs);

    //slave transaction
    apb_slave_trans trans_h;

    virtual apb_inf vif;            //virtual interface
    
    //declaring the p_sequencer
    //apb_slave_seqr p_seqeuencer                           //possible way
    `uvm_declare_p_sequencer(apb_slave_seqr)

    //slave memory
    bit [`DATA_WIDTH-1:0] slv_mem [int]; 

    
    //function new
    function new(string name="apb_slave_base_seqs");
        super.new(name);
    endfunction

    task body();
        if(!$cast(p_sequencer,m_sequencer))
            `uvm_fatal("APB_SLV_BASE_SEQS","Casting not done for p_sequencer")
        if(!uvm_config_db#(virtual apb_inf)::get(null,"*","inf",vif))
            `uvm_fatal("SLV SEQS","Config db not get in slave sequence")
        forever begin
            p_sequencer.item_collect_fifo.get(trans_h);
        fork
            begin
                wait(vif.presetn == 1'b0);
                slv_mem.delete();
                trans_h.pslverr = 1'b0;
                `uvm_send(trans_h)
            end
            begin
            case(trans_h.pwrite)
                1'b1 : begin
                    if(trans_h.paddr inside {0,2}) begin
                        trans_h.pslverr = 1'b1;
                        `uvm_send(trans_h);
                    end
                    else begin
                        slv_mem[trans_h.paddr] = trans_h.pwdata;
                        trans_h.pslverr = 1'b0;
                        `uvm_send(trans_h);
                    end
                end
                1'b0 : begin
                        if(trans_h.paddr inside {0}) begin
                            trans_h.pslverr = 1'b1;
                            trans_h.prdata = 'hff;
                            `uvm_send(trans_h)
                        end
                        else begin 
                            if(slv_mem.exists(trans_h.paddr)) begin         //checking if data exists in memory
                                trans_h.prdata = slv_mem[trans_h.paddr];    //reading the data from memory
                            end
                            else begin
                                    trans_h.prdata = 0;
                            end
                        trans_h.pslverr = 1'b0;
                        `uvm_send(trans_h)
                        end
                end
            endcase
            end
        join_any
        wait(vif.presetn==1'b1);
        end    
    endtask

endclass

`endif
