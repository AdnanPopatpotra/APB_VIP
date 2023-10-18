/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* Company       : SCALEDGE
* Created By    : MOHAMADADNAN POPATPOTRA
* File Name 	: apb_assert_inf.sv
* Creation Date : 29-08-2023
* Last Modified : 29-08-2023 15:16:03
* Purpose       :  
_._._._._._._._._._._._._._._._._._._._._.*/

`ifndef APB_ASSERT_INF
`define APB_ASSERT_INF

interface apb_assert_inf();

    //signal list
    
    //clock and reset signals
    input logic pclk,presetn;                                 //preset i.e reset and clock signal

    //master signals
    input logic psel;                                         //slave select signal
    input logic penable;                                      //enable signal
    input logic pwrite;                                       //write/read signal
    input logic [`ADDR_WIDTH-1:0] paddr;                      //write/read address 
    input logic [`DATA_WIDTH-1:0] pwdata;                     //write data
    
    //slave signals
    input logic [`DATA_WIDTH-1:0] prdata;                     //read data
    input logic pslverr;                                      //slave error          
    input logic pready;                                       //ready signal for completing the transfer

    //<<<<<<<<<< ASSERTION >>>>>>>>>>
    
    //Idle state sequence
    sequence IDLE;
        psel == 1'b0;
        penable == 1'b0;
    endsequence

    //Setup state sequence
    sequence SETUP;
        psel == 1'b1;
        penable == 1'b0;
    endsequence

    //Access state sequence
    sequence ACCESS;
        psel == 1'b1;
        penable == 1'b1;
    endsequence

    //property for checking idle to setup phase
    property IDLE_SETUP;
        @(posedge pclk)
        IDLE ##1 SETUP;
    endproperty

    //property for checking setup to access phase
    property SETUP_ACCESS;
        @(posedge pclk)
        SETUP ##1 ACCESS;
    endproperty

endinterface

`endif
