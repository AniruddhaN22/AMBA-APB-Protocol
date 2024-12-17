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

module tb_apb;

    reg pclk;
    reg presetn;
    reg pselx;
    reg penable;
    reg pwrite;
    reg [31:0] paddr;
    reg [31:0] pwdata;

    wire pready;
    wire [31:0] prdata;
    wire pslverr;

    apb dut (
        .pclk(pclk),
        .presetn(presetn),
        .paddr(paddr),
        .pselx(pselx),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .pready(pready),
        .prdata(prdata),
        .pslverr(pslverr)
    );

    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

    initial begin
        presetn = 0;
        pselx = 0;
        penable = 0;
        pwrite = 0;
        paddr = 0;
        pwdata = 0;

        #10 presetn = 1;
        $display("Reset completed.");

        // Write Operation
        paddr = 32'h10;   
        pwdata = 32'hA5A5A5A5; 
        #10;
        pselx = 1;        
        penable = 0;      
        #10
        pwrite = 1;    
        
        
        $display("Starting Write Operation: Address = %h, Data = %h", paddr, pwdata);
        #10 penable = 1;  // Access phase
        #10 penable = 0;  // Complete write
        pselx = 0;
        
        #10
        pselx = 1; 
        penable = 0;
        pwrite = 0; // Read Operation
        #10
        paddr = 32'h10;
        $display("Read Data: %h", prdata);
        #20;
        $display("Test Completed.");
        $stop;
    end

endmodule
