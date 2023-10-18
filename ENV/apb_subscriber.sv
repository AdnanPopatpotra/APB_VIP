/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_subscriber.sv
* Creation Date : 09-08-2023
* Last Modified : 11-09-2023 15:03:51
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

class apb_subscriber extends uvm_subscriber #(apb_slave_trans);

    //factory registration
    `uvm_component_utils(apb_subscriber)

    //virtual interface
    virtual apb_inf vif;

    apb_slave_trans trans_h;

    //covergroup
    covergroup  apb_cov with function sample(apb_slave_trans trans_h , virtual apb_inf vif);
        option.comment = "<<<<<<<<<< APB COVERAGE >>>>>>>>>>";

        //coverpoint for checking the mode of pwrite
        TRANS_KIND : coverpoint trans_h.pwrite iff(vif.presetn){
            option.comment = "mode of operation";
            bins mode[] = {0,1};
            bins trans_wr_rd = ( 1'b1 => 1'b0 );            //write to read operation
            bins trans_rd_wr = ( 1'b0 => 1'b1 );            //read to write operation
        }     
 
        //coverpoint for checking that whether all the addresses are covered or not
        ADDR : coverpoint trans_h.paddr iff(vif.presetn){
                option.comment = "addr transition check";
            bins addr[] = {[0:2**`ADDR_WIDTH]};
        }

        //coverpoint for checking that whether my protected addresses are covered or not
        PROT_ADDR : coverpoint trans_h.paddr iff(vif.presetn){
                option.comment = "Protected address coverage";
            bins prot_addr = {0};
        }

        //coverpoint for checking that whether my read only addresses are covered or not
        READ_ONLY_ADDR : coverpoint trans_h.paddr iff(vif.presetn){
                option.comment = "Read only addresses coverage";
            bins read_only_addr = {2};
        }

        //cross coverage for checking whether the protected addresses getting write and read
        PROTXWR : cross PROT_ADDR, TRANS_KIND iff(vif.presetn){
                ignore_bins t = binsof(TRANS_KIND.trans_wr_rd) || binsof(TRANS_KIND.trans_rd_wr);
                //trans_h.pwrite.trans_wr_rd;   //binsof(trans_h.pwrite) intersect {  trans_wr_rd, trans_rd_wr  };
        }

        //cross coverage for checking whether the read only addresses getting write and read
        READXWR : cross READ_ONLY_ADDR, trans_h.pwrite iff(vif.presetn);
        
    endgroup

    //function new
    function new(string name="apb_subscriber",uvm_component parent);
        super.new(name,parent);
        apb_cov = new;                                       //creating the covergroup
    endfunction

    //build phase
    function void build_phase(uvm_phase phase);
        trans_h = apb_slave_trans::type_id::create("trans_h");
        if(!uvm_config_db #(virtual apb_inf)::get(this,"*","inf",vif))
            `uvm_fatal("APB_SUBSCRIBER","config db not get in subscriber class");
    endfunction

    //extract phase
    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        $display("<<<<<<<<<< COVERAGE >>>>>>>>>>");
        $display("Overall Coverage for apb_cov is %f",apb_cov.get_coverage());
    endfunction

    //analysis port write method 
    function void write(apb_slave_trans t);
        //$display("Inside Subscriber write method");
        apb_cov.sample(t,vif);
    endfunction

endclass: apb_subscriber
