`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2021 05:08:11 PM
// Design Name: 
// Module Name: inst_ram1
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

module inst_ram1#(
    parameter w=32,
    parameter h=8)(
    clk,
    //read
    pc,
    re,
    inst_data,
    //write
    is_write,
    im_addr,
    im_inst);
 
    input clk;
    input wire[w-1:0] im_addr;
    input wire[w-1:0] im_inst;
    input wire[w-1:0] pc;
    output wire[w-1:0] inst_data;
    input wire is_write;
    input wire re;
    
    

    wire[w-1:0] shifted_addr_pc;
    assign shifted_addr_pc[w-1:0]=pc>>2;

    wire[w-1:0] shifted_addr_load;
    assign shifted_addr_load[w-1:0]=im_addr>>2;

integer i=0;
(* ram_style = "block" *)reg [w-1:0] inst[2**h-1:0];


always@(posedge clk)
begin
    if(is_write)
    begin
        inst[shifted_addr_load][w-1:0]<=im_inst[w-1:0];
        
        $display("%h %h %h %h",shifted_addr_pc[w-1:0],shifted_addr_load[w-1:0],im_inst[w-1:0],inst[shifted_addr_load][w-1:0]);

    end

end
assign inst_data[w-1:0]=(re)?inst[shifted_addr_pc][w-1:0]:2'h00;

endmodule

