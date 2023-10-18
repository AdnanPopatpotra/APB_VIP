/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_scoreboard.sv
* Creation Date : 28-07-2023
* Last Modified : 06-09-2023 12:19:06
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/


class apb_scoreboard extends uvm_scoreboard;

    //factory registration
    `uvm_component_utils(apb_scoreboard)

    //`uvm_analysis_imp_decl(_mas)
    `uvm_analysis_imp_decl(_mas)
    `uvm_analysis_imp_decl(_slv)

    //transaction
    apb_master_trans mas_trans;
    apb_slave_trans slv_trans;

    //expected data storing transaction
    apb_master_trans exp_trans;

    //analysis imports for master and slave
    uvm_analysis_imp_mas#(apb_master_trans,apb_scoreboard) mas_item_collect_imp;
    uvm_analysis_imp_slv#(apb_slave_trans,apb_scoreboard) slv_item_collect_imp;

    //virtual interface
    virtual apb_inf vif;

    //for printing the data 
    bit [`DATA_WIDTH-1:0] print_actual; 
    bit [`DATA_WIDTH-1:0] print_expected; 
    
    //queues for storing the data
    bit [`DATA_WIDTH-1:0] act_data [$];         //actual data queue to save data coming from slave monitor
    bit [`DATA_WIDTH-1:0] exp_data [$];         //expected data queue

    //reference memory
    bit [`DATA_WIDTH-1:0] ref_mem [int];

    //function new
    function new(string name="apb_scoreboard",uvm_component parent);
        super.new(name,parent);
        mas_item_collect_imp = new("mas_item_collect_imp",this);
        slv_item_collect_imp = new("slv_item_collect_imp",this);
    endfunction

    function void build_phase(uvm_phase phase);
        mas_trans = apb_master_trans::type_id::create("mas_trans");
        slv_trans = apb_slave_trans::type_id::create("slv_trans");
        exp_trans = apb_master_trans::type_id::create("exp_trans");

        if(!uvm_config_db #(virtual apb_inf)::get(this,"*","inf",vif))
            `uvm_fatal("SCOREBOARD","Interface not get in scoreboard")
    endfunction

    function void write_slv(apb_slave_trans slv_trans);
        //$display($time);
        //$display("----------In Scoreboard----------");
        //slv_trans.print();
        //$display;
        act_data.push_back(slv_trans.prdata);
        //`uvm_info("SCOREBOARD",$sformatf("slv read_data = %0p",act_data),UVM_NONE);

        exp_mem_read(mas_trans,exp_trans);
        //$display("mas trans addr inside read task = %0d",mas_trans);
        //`uvm_info("SCOREBOARD",$sformatf("mas exp read_data = %0p",exp_data),UVM_NONE);
    
        print_actual = act_data[0];             //stored actual data for printing
        print_expected = exp_data[0];           //stored expected data for printing

       
        if(act_data.pop_front == exp_data.pop_front) 
        begin
            `uvm_info("SCOREBOARD",$sformatf("-----PASS-----  ||  actual prdata = %0d | expected prdata = %0d ",print_actual,print_expected),UVM_NONE);
        end
        else 
        begin
            `uvm_info("SCOREBOARD",$sformatf("*****FAIL*****  ||  actual prdata = %0d | expected prdata = %0d ",print_actual,print_expected),UVM_NONE);
        end


    endfunction

    function void write_mas(apb_master_trans mas_trans);
        //$display("------------In Scoreboard---------");
        //mas_trans.print();
        //$display;
        this.mas_trans = mas_trans;
        exp_mem_write(mas_trans);
        //$display("mas trans addr = %0d",mas_trans);
    endfunction

    //function to write in expected memory
    function void exp_mem_write(apb_master_trans mas_trans);
        if(!vif.presetn) begin 
            ref_mem.delete();
        end
        else begin
            if(mas_trans.pwrite == 1'b1)
                ref_mem[mas_trans.paddr] = mas_trans.pwdata;
        end
        //$display("write fn paddr : %0d",mas_trans.paddr);
        //$display("ref_mem[mas_trans.paddr] = %0d",ref_mem[mas_trans.paddr]);
        //$display("ref_mem : %p",ref_mem);
    endfunction

    //function to read from expected memory
    function void exp_mem_read(apb_master_trans mas_trans,exp_trans);
    //function void exp_mem_read(apb_slave_trans slv_trans, apb_master_trans exp_trans);
        //mas_trans.print();
        if(!vif.presetn) begin
            ref_mem.delete();
            exp_trans.prdata = 0;
        end
        else begin
            if(mas_trans.pwrite == 1'b0 & ref_mem.exists(mas_trans.paddr))
                exp_trans.prdata = ref_mem[mas_trans.paddr];
            else 
                exp_trans.prdata = 0;
        end
        //$display("paddr : %0d",mas_trans.paddr);
        //$display("ref_mem : %p",ref_mem);
        exp_data.push_back(exp_trans.prdata);
    endfunction

endclass
