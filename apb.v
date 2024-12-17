`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aniruddha N
// 
// Create Date: 12/16/2024 07:36:50 PM
// Design Name: 
// Module Name: apb
// Project Name: AMBA APB Protocol
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module apb(
pclk,presetn,paddr,pselx,penable,pwrite,pwdata,pready,prdata,pslverr
);
    input pclk, presetn, penable, pwrite, pselx;
    input [31:0] paddr,pwdata; 
    output reg pready;
    output reg [31:0] prdata;
    output reg pslverr;
    
    reg [31:0] memory [1023:0];
    
    parameter IDLE = 2'b00,
              SETUP = 2'b01,
              ACCESS = 2'b10;
    
    reg [2:0] curr_state,n_state;
              
    always @(posedge pclk) begin
        if (!presetn) begin
            curr_state <= IDLE;
        end
        else begin
            curr_state <= n_state;
        end
    end
    
    always @(*)begin
    
        case(curr_state)
            IDLE: begin
                if ((pselx == 1'b1) & (penable == 1'b0)) begin
                    n_state = SETUP;
                end
            end
            SETUP: begin
                if ((pselx == 1'b1) & (penable == 1'b1)) begin
                    n_state = ACCESS;
                end
                
                if (pwrite == 1) begin
                    memory[paddr] = pwdata;
                    pslverr = 1'b0;
                    pready = 1'b1;
                end
                
                else begin
                    prdata = memory[paddr];
                    pready = 1'b1;
                end
            end   
            ACCESS: begin
                if ((pselx == 1'b1) & (penable == 1'b0)) begin
                    n_state = SETUP;
                end
                
                else if ((pselx == 1'b0) & (penable == 1'b0)) begin
                    n_state = IDLE;
                    pready = 1'b1;
                end
                
                else begin
                    pready = 0;
                end
                 
            end
            
            default : n_state = IDLE;
            
        endcase
    end
endmodule
