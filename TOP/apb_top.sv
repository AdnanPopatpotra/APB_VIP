/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_top.sv
* Creation Date : 21-07-2023
* Last Modified : 11-09-2023 14:34:07
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_TOP_SV
`define APB_TOP_SV

`include "apb_pkg.sv"
module apb_top();

    import uvm_pkg::*;
    import apb_pkg::*;
    `include "uvm_macros.svh"


    //clock and reset signals
    bit pclk, presetn;

    //interface
    apb_inf inf();

   /* 
    apb_mem DUT(._PRESETn(inf.presetn),
                ._PCLK(inf.pclk),
                ._PSEL1(inf.psel),
                ._PWRITE(inf.pwrite),
                ._PENABLE(inf.penable),
                ._PADDR(inf.paddr),
                ._PWDATA(inf.pwdata),
                ._PRDATA(inf.prdata),
                ._PREADY(inf.pready),
                ._PSLVERR(inf.pslverr));
    
    */

  /* 
    APB DUT(.PRESET(inf.presetn),
                .PCLK(inf.pclk),
                .PSEL(inf.psel),
                .PWRITE(inf.pwrite),
                .PENABLE(inf.penable),
                .PADDR(inf.paddr),
                .PWDATA(inf.pwdata),
                .PRDATA(inf.prdata),
                .PREADY(inf.pready),
                .PSLVERR(inf.pslverr));
    */


    initial begin
        inf.pclk=0;
        forever begin #5 inf.pclk = ~inf.pclk; end
    end
 
    
    initial begin
        uvm_config_db #(virtual apb_inf)::set(null,"*","inf",inf);
         inf.reset();
         //#35;
         //inf.presetn = 1'b0;
         //#20 inf.presetn = 1'b1;
         #150;
         inf.presetn = 1'b0;
         #15 inf.presetn = 1'b1;
         //#305  inf.presetn = 1'b0;
         //#10  inf.presetn = 1'b1;
    end

       
    //set config_db & run the test 
    initial begin
        run_test("");
    end

endmodule


`endif
