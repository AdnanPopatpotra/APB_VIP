/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_inf.sv
* Creation Date : 20-07-2023
* Last Modified : 12-09-2023 14:23:21
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_INF_SV
`define APB_INF_SV

`include "apb_defines.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;

interface apb_inf();

    //signal list
    
    //clock and reset signals
    logic pclk,presetn;                                 //preset i.e reset and clock signal

    //master signals
    logic psel;                                         //slave select signal
    logic penable;                                      //enable signal
    logic pwrite;                                       //write/read signal
    logic [`ADDR_WIDTH-1:0] paddr;                      //write/read address 
    logic [`DATA_WIDTH-1:0] pwdata;                     //write data
    
    //slave signals
    logic [`DATA_WIDTH-1:0] prdata;                     //read data
    logic pslverr;                                      //slave error          
    logic pready;                                       //ready signal for completing the transfer

    //int TIMEOUT;

    //master driver clocking block
    clocking mas_drv_cb@(posedge pclk);
        default input #1 output #0;
        input presetn, pready;
        output psel, penable, pwrite;
        output paddr, pwdata;
    endclocking

    //master monitor clocking block
    clocking mas_mon_cb@(posedge pclk);
        default input #1 output #0;
        input psel, penable, pwrite, pslverr;
        input paddr, pwdata, prdata;
    endclocking
    
    //slave driver clocking block
    clocking slv_drv_cb@(posedge pclk);
        default input #1 output #0;
        output pready, pslverr, prdata;
        //output pwrite;                      //temporary
        input presetn, psel, penable;
    endclocking

    //slave monitor clocking block
    clocking slv_mon_cb@(posedge pclk);
        default input #1 output #0;
        input psel, penable, pwrite, pready, pslverr;
        input paddr, pwdata, prdata;
    endclocking

    //master driver modport
    modport MDRV_MP(clocking mas_drv_cb,pready);

    //master monitor modport
    modport MMON_MP(clocking mas_mon_cb);

    //slave driver modport
    modport SDRV_MP(clocking slv_drv_cb);

    //slave monitor modport
    modport SMON_MP(clocking slv_mon_cb);

    //reset task
    task reset();
        presetn = 1'b0;
        psel    = 1'b0;
        penable = 1'b0;
        pready  = 1'b0;
        pwrite  = 1'b0;
        pslverr = 1'b0;
        #5 presetn = 1'b1;
    endtask


    //--------------------------------------------------------------------------------------
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ASSERTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //--------------------------------------------------------------------------------------
    


    //Assertion for checking penable becomes 1'b1 1 clock cycle after psel
    property penable_check;
        @(posedge pclk) $rose(psel) |=> penable;
    endproperty

    penable_checking : assert property(penable_check)
    else `uvm_error("ASSERTION","penable checking assertion failed");
   
    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------

    //Assertion for checking whether sel,write,addr,data are stable or not when penable comes
    property psel_stable;
        @(posedge pclk) 
        disable iff(!presetn)
        (penable) |-> ($stable(psel) || $stable(pwrite) && $stable(paddr) && $stable(prdata));
    endproperty
    
    penable_other_signal_stable : assert property(psel_stable)
    else `uvm_error("ASSERTION","penable high at that time other signals not stable");

    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------
    
    //Assertion for checking penable is zero next clock cycle after psel
    property penable_check1;
        @(posedge pclk)
        disable iff(!presetn)
        $fell(penable) |-> $stable(psel);
        
        //(penable==1'b0) |-> $stable(psel);
    endproperty

    penable_checking1 : assert property(penable_check1)
    else `uvm_error("ASSERTION","penable_checking assertion failed");
    
    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------
    
    //Assertion for checking penable becomes zero one clock cycle after pready becomes 1'b1
    property penable_zero;
        @(posedge pclk)
        disable iff(!presetn)
        //here using $fell for penable instead of penable==0 because we don't want to check when reset occurs. Due to reset pready will not be 1'b1 one clock cycle before penable
        $fell(penable) |-> ($past(pready,1) == 1'b1);        
        
        //(penable == 1'b0) |-> ($past(pready,1) == 1'b1);
        //(penable == 1'b0) && (psel==1'b1) |-> (pready == 1'b1);
        //(penable == 1'b0)&&(psel == 1'b1) |-> ($past(1,pready) == 1'b1);
    endproperty
    
    penable_zero_check : assert property(penable_zero)
    else `uvm_error("ASSERTION","penable zero check assertion failed");

    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------
    
    //Assertion for reset assert check
    property reset_assert;
        @(negedge presetn)
        1'b1 |=> @(posedge pclk) (psel==1'b0) && (penable==1'b0) && (pready==1'b0) && (pslverr==1'b0);
    endproperty

    reset_assert_check : assert property(reset_assert)
    else `uvm_error("ASSERTION","reset assert check assertion failed");


    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------
    
    //Assertion for checking pslverr becomes in case of protected address
    property prot_addr_rw;
        @(posedge pclk)
        disable iff(!presetn)
        (paddr==`ADDR_WIDTH'd0) |=> (pslverr==1'b1);
    endproperty

    prot_addr_rw_check : assert property(prot_addr_rw)
    else `uvm_error("ASSERTION","protected address assertion failed");

    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------

    
    //Assertion for checking when read only address used during write operation then slave error should assert
    property read_only_addr;
        //@(posedge pslverr)
        @(posedge pclk)
        disable iff(!presetn)
        //1'b1 |-> (paddr==`ADDR_WIDTH'd2) && (pwrite==1'b0);
        (paddr==`ADDR_WIDTH'd2) && (pwrite==1'b1) |=> (pslverr==1'b1); 
    endproperty

    read_only_addr_Wcheck : assert property(read_only_addr)
    else `uvm_error("ASSERTION","read only address write assertion failed");

    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------

    
    //Assertion for checking when read only address used during read operation then slave error should not assert
    property read_only_addr1;
        @(posedge pclk)
        disable iff(!presetn)
        (paddr==`ADDR_WIDTH'd2) && (pwrite==1'b0) |-> (pslverr==1'b0);
    endproperty

    read_only_addr_Rcheck : assert property(read_only_addr1)
    else `uvm_error("ASSERTION","read only address read assertion failed");

    //----------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------


endinterface

`endif
