/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_scoreboard.sv
* Creation Date : 28-07-2023
* Last Modified : 12-09-2023 23:55:06
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

    //analysis imports for master and slave
    uvm_analysis_imp_mas#(apb_master_trans,apb_scoreboard) mas_item_collect_imp;
    uvm_analysis_imp_slv#(apb_slave_trans,apb_scoreboard) slv_item_collect_imp;

    //for storing pwdata coming from master driver
    apb_master_trans exp_pwdata_trans;
    bit [`DATA_WIDTH-1:0] exp_pwdata[$];
    bit [`DATA_WIDTH-1:0] act_pwdata[$];

    //uvm blocking port for getting pwdata from master driver
    uvm_blocking_put_imp #(apb_master_trans,apb_scoreboard) put_imp; 

    //virtual interface
    virtual apb_inf vif;

    //for printing the data 
    bit [`DATA_WIDTH-1:0] print_actpwdata; 
    bit [`DATA_WIDTH-1:0] print_exppwdata; 
    
    //queues for storing the data
    apb_slave_trans exp_data_q [$];         //expected data queue
    apb_slave_trans act_data_q [$];         //actual data queue to save data coming from slave monitor
    apb_slave_trans act_data;               //actual data transaction for storing data from act_data_q
    apb_slave_trans exp_data;               //exp data transaction for storing data from exp_data_q

    //reference memory
    bit [`DATA_WIDTH-1:0] ref_mem [int];

    int pslverr_count;

    //function new
    function new(string name="apb_scoreboard",uvm_component parent);
        super.new(name,parent);
        mas_item_collect_imp = new("mas_item_collect_imp",this);
        slv_item_collect_imp = new("slv_item_collect_imp",this);
        put_imp = new("put_imp",this);
    endfunction

    //build phase
    function void build_phase(uvm_phase phase);
        mas_trans = apb_master_trans::type_id::create("mas_trans");                     //creating the master transaction
        slv_trans = apb_slave_trans::type_id::create("slv_trans");                      //creating the slave  transaction

        exp_pwdata_trans = apb_master_trans::type_id::create("exp_pwdata_trans");       //transaction for storing pwdata

        if(!uvm_config_db #(virtual apb_inf)::get(this,"*","inf",vif))                  //getting the virtual interface
            `uvm_fatal("SCOREBOARD","Interface not get in scoreboard")
    endfunction

    //slave monitor write method
    function void write_slv(apb_slave_trans slv_trans);
        act_data_q.push_back(slv_trans);
        begin
            if(slv_trans.pwrite == 1'b0 && ref_mem.exists(slv_trans.paddr))
                slv_trans.prdata = ref_mem[slv_trans.paddr];
            else 
                slv_trans.prdata = 0;
        end
        exp_data_q.push_back(slv_trans);


    endfunction

    function void write_mas(apb_master_trans mas_trans);
         this.mas_trans = mas_trans;
           begin
            if(mas_trans.paddr != `DATA_WIDTH'd2) begin
                if(mas_trans.pwrite == 1'b1) begin
                    ref_mem[mas_trans.paddr] = mas_trans.pwdata;
                    act_pwdata.push_back(mas_trans.pwdata);
                end
            end
            else begin
                ref_mem[mas_trans.paddr] = '0;
                act_pwdata.push_back(mas_trans.pwdata);
            end
        end
        

        print_actpwdata = act_pwdata[0];
        print_exppwdata = exp_pwdata[0];
        
        if(vif.pslverr != 1) begin
            if(mas_trans.paddr == exp_pwdata_trans.paddr) begin
                if(act_pwdata.pop_front() == exp_pwdata.pop_front()) begin
                    `uvm_info("SCOREBOARD",$sformatf("-----PWDATA MATCH PASS------ exp_pwdata = %0d || act_pwdata = %0d",print_actpwdata,print_exppwdata),UVM_NONE)
                end
                else
                    `uvm_info("SCOREBOARD",$sformatf("-----PWDATA MATCH FAIL----- exp_pwdata = %0d || act_pwdata = %0d",print_actpwdata,print_exppwdata),UVM_NONE) 
            end       
        end
        else begin
                pslverr_count = pslverr_count + 1;
            if((mas_trans.paddr inside {0,2} ) && (exp_pwdata_trans.paddr inside {0,2} )) begin
                `uvm_info("SCOREBOARD",$sformatf("-----WRITE PSLVERR PASS----- mas_trans.paddr = %0d || exp_pwdata_trans.paddr = %0d",mas_trans.paddr,exp_pwdata_trans.paddr),UVM_NONE)
            end
            else begin
                `uvm_info("SCOREBOARD",$sformatf("******WRITE PSLVERR FAIL****** mas_trans.paddr = %0d || exp_pwdata_trans.paddr = %0d",mas_trans.paddr,exp_pwdata_trans.paddr),UVM_NONE)
            end
        end
    endfunction

    //run phase used for comparing the read data
    task run_phase(uvm_phase phase);
        forever 
        begin
            fork
                    begin
                        wait(!vif.presetn);
                        ref_mem.delete();
                    end
                    begin
                        wait((act_data_q.size == 1) && (exp_data_q.size == 1))
                        begin
                        //`uvm_info("SCOREBOARD",$sformatf("act_data queue : %p",act_data_q),UVM_NONE)
                        //`uvm_info("SCOREBOARD",$sformatf("exp_data queue : %p",exp_data_q),UVM_NONE)
                        act_data = act_data_q.pop_front();
                        exp_data = exp_data_q.pop_front();
                        //`uvm_info("SCOREBOARD",$sformatf("act_data : %0d",act_data.prdata),UVM_NONE)
                        //`uvm_info("SCOREBOARD",$sformatf("exp_data : %0p",exp_data),UVM_NONE)
                        if(act_data.pslverr != 1) begin
                            if(act_data.prdata == exp_data.prdata) 
                                begin
                                    `uvm_info("SCOREBOARD",$sformatf("-----PRDATA PASS-----  ||  actual prdata = %0d | expected prdata = %0d ",act_data.prdata,exp_data.prdata),UVM_NONE);
                                end
                            else 
                                begin
                                `uvm_info("SCOREBOARD",$sformatf("*****PRDATA FAIL*****  ||  actual prdata = %0d | expected prdata = %0d ",act_data.prdata,exp_data.prdata),UVM_NONE);
                            end
                        end
                        else begin
                                pslverr_count = pslverr_count + 1;      //counting the slave error
                            if((act_data.paddr inside {0}) && (exp_data.paddr inside {0})) begin
                                `uvm_info("SCOREBOARD",$sformatf("-----READ PSLVERR PASS----- act_data.paddr = %0d || exp_data.paddr = %0d",act_data.paddr,exp_data.paddr),UVM_NONE)
                            end
                            else 
                                `uvm_info("SCOREBOARD",$sformatf("*****READ PSLVERR FAIL***** act_data.paddr = %0d || exp_data.paddr = %0d",act_data.paddr,exp_data.paddr),UVM_NONE)

                        end
                        end
                    end
            join_any
            //disable fork;
            wait(vif.presetn);
        end

    endtask
   
    //task for getting pwdata from master driver
    task put(apb_master_trans exp_pwdata_trans);
        this.exp_pwdata_trans = exp_pwdata_trans;
        exp_pwdata.push_back(exp_pwdata_trans.pwdata);
    endtask

    function void extract_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD",$sformatf("TOTAL NUMBER OF PSLVERR OCCURED ARE = %0d",pslverr_count),UVM_NONE)
    endfunction


endclass

























/*
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

    //driver to scoreboard pwdata trans and queue
    apb_master_trans exp_pwdata_trans;
    bit [`DATA_WIDTH-1:0] exp_pwdata [$];       //stores driver pwdata
    bit [`DATA_WIDTH-1:0] act_pwdata [$];       //stores slave monitor pwdata

    //TLM put imp port for getting transaction directly from driver
    uvm_blocking_put_imp #(apb_master_trans,apb_scoreboard) put_imp;
   
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
    bit [`DATA_WIDTH-1:0] exp_data_q [$];         //expected data queue

    //reference memory
    bit [`DATA_WIDTH-1:0] ref_mem [int];

    //function new
    function new(string name="apb_scoreboard",uvm_component parent);
        super.new(name,parent);
        mas_item_collect_imp = new("mas_item_collect_imp",this);
        slv_item_collect_imp = new("slv_item_collect_imp",this);
        put_imp = new("put_imp",this);
    endfunction

    function void build_phase(uvm_phase phase);
        mas_trans = apb_master_trans::type_id::create("mas_trans");
        slv_trans = apb_slave_trans::type_id::create("slv_trans");
        exp_trans = apb_master_trans::type_id::create("exp_trans");

        exp_pwdata_trans = apb_master_trans::type_id::create("exp_pwdata_trans");
        
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
        //`uvm_info("SCOREBOARD",$sformatf("mas exp read_data = %0p",exp_data_q),UVM_NONE);
    
        act_pwdata.push_back(slv_trans.pwdata);
        //`uvm_info("SCOREBOARD",$sformatf("act_pwdata : %p",act_pwdata),UVM_NONE)

        print_actual = act_data[0];             //stored actual data for printing
        print_expected = exp_data_q[0];           //stored expected data for printing

        //$display("slv_pwrite : %0d",slv_trans.pwrite); 
        if(slv_trans.pwrite == 1'b0) begin
            if(act_data.pop_front == exp_data_q.pop_front) 
            begin
                `uvm_info("SCOREBOARD",$sformatf("-----PRDATA PASS-----  ||  actual prdata = %0d | expected prdata = %0d ",print_actual,print_expected),UVM_NONE);
            end
            else 
            begin
                `uvm_info("SCOREBOARD",$sformatf("*****PRDATA FAIL*****  ||  actual prdata = %0d | expected prdata = %0d ",print_actual,print_expected),UVM_NONE);
            end
        end
       
       /* 
        else begin
            if(exp_pwdata.pop_front ==  act_pwdata.pop_front) 
                begin
                    `uvm_info("SCOREBOARD","PWDATA PASS",UVM_NONE)
                end
            else
                begin
                    `uvm_info("SCOREBOARD","PWDATA FAIL",UVM_NONE)
                end
        end
       */
/*

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
        exp_data_q.push_back(exp_trans.prdata);
    endfunction

    task put(apb_master_trans exp_pwdata_trans);
        exp_pwdata.push_back(exp_pwdata_trans.pwdata); 
        //$write($time);
        //`uvm_info("SCOREBOARD",$sformatf("put task transaction queue: %p",exp_pwdata),UVM_LOW)
        //`uvm_info("SCOREBOARD",$sformatf("exp_pwdata: %p",exp_pwdata),UVM_LOW)
        //$display("slv_pwrite : %0d",slv_trans.pwrite);
        //if(slv_trans.pwrite == 1'b1) begin
            if(exp_pwdata.pop_front ==  act_pwdata.pop_front) 
                begin
                    `uvm_info("SCOREBOARD","PWDATA PASS",UVM_NONE)
                end
            else
                begin
                    `uvm_info("SCOREBOARD","PWDATA FAIL",UVM_NONE)
                end
        //end
    endtask

endclass
*/
