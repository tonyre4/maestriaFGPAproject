//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2020 07:05:47 PM
// Design Name: 
// Module Name: fbh
// Project Name: 
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


module fbh(
    input wire clk,rst,en,vsync,roiend,
    input wire[7:0] val,
    output wire[7:0] valo,
    output wire [13:0] bin0,
    output wire [13:0] ct0,
    output wire [49:0] pixcnt);
    
    reg [49:0] cnt;
    reg [13:0] c0;
    reg [7:0] vall;
        
    initial cnt = 0;
    assign pixcnt = cnt;
    assign ct0 = c0;
    assign valo = val;
    
    always @(posedge clk, posedge rst , posedge vsync) begin   
        if (rst || vsync) begin
            cnt <= 0;
        end
        else
            if (clk && en) begin
                cnt<= cnt+1;
            end
    end
    
//    always @(posedge clk) begin
//        if (clk)
//            vall = val;
//    end

    
    always @(posedge clk, posedge rst , posedge vsync) begin
       if (rst || vsync) begin
            c0 <= 0;
        end
        else
           if (clk) begin
                if (en)
                    if (val < 51)
                        c0<=c0+1;
           end 
    end
    
endmodule
