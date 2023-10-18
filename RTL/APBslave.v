`define ADDRWIDTH 16
`define DATAWIDTH 8

module APB( input PCLK,PRESET,PSEL,PENABLE,PWRITE,
            input [`ADDRWIDTH-1:0] PADDR,
            input [`DATAWIDTH-1:0]PWDATA,
            output reg [`DATAWIDTH-1 :0] PRDATA,
            output reg PREADY,
            output PSLVERR 
            );

//parameter ADDwidth = 16;
//parameter DATAwidth = 8;

reg [`DATAWIDTH-1:0] mem [`ADDRWIDTH-1:0];
reg [1:0] sstate,nstate;
reg error,error_addr,error_read,error_write;

parameter [1:0] idle = 2'b00;
parameter [1:0] setup = 2'b01;
parameter [1:0] access = 2'b10;

integer i;

always @(posedge PCLK or negedge PRESET) begin
    if(PRESET == 0) begin //preset is active LOW signal  
        sstate <= idle;
        PRDATA <= 0;
        PREADY <= 0;
        //PSLVERR <=0;
       //--memory initialization.
        for(i = 0;i <`DATAWIDTH;i=i+1 )begin
            mem[i] <= 0;
        end
    end
    else begin
       sstate<=nstate;
    end
end
  always@(sstate,PSEL,PENABLE) begin
       case(sstate)
            idle : begin
                    //PRDATA <= 0;
                    if(PSEL == 1) begin
                        nstate <= setup;
                    end
                    else begin
                        nstate <= idle;
                    end
            end

            setup : begin
                    //PRDATA <= 0;
                    //if(PSEL == 1 && PENABLE == 1 && transfer == 1 ) begin    //original
                    if( PENABLE==1) begin
                     //  if(PENABLE ==1)                        //modified.
                        nstate <= access;
                    end
                    else begin
                         nstate <= setup;   
                    end
            end
                   
                     
            access :begin 
                     PREADY<=1;
                     if (!PREADY) begin
                       nstate <= access; 
                     end
                  
                     if(PWRITE) begin // 1 to write and 0 to read
                        mem[PADDR] <= PWDATA; 
                        if(PSEL==1 && PENABLE==0) begin
                         nstate<=setup;
                        end
                        if(PSEL==0 && PENABLE==0) begin
                         nstate<=idle;
                        end
                     end
                     else begin
                        PRDATA<= mem[PADDR];
                        if(PSEL==1 && PENABLE==0) begin
                         nstate<=setup;
                        end
                        if(PSEL==0 && PENABLE==0) begin
                         nstate<=idle;
                        end
                     end
                    end
                        
           endcase
            end
        //end
        
//end

// always @(sstate or PREADY or tr ) begin
//     case 
        
//     endcase
// end

assign PSLVERR = error || error_addr || error_read || error_write;

always @(*) begin
    if(!PRESET) begin
        error <= 0;
    end
    else begin
      if((PADDR === 16'dx) && (PSEL) && (PENABLE) && (PREADY))
		  error_addr = 1;
	  else error_addr = 0;
          end
          
	  if((PRDATA === 8'dx) &&(PSEL) && (PENABLE) && (PREADY))
		  error_read = 1;
	  else  error_read = 0;
          begin
          if((PWDATA === 8'dx) && (PSEL) && (PENABLE) && (PREADY))
		   error_write = 1;
          else error_write = 0;
          end   

    end
    

endmodule
//sstate suitation simulation in different different sstates
