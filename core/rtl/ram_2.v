

`timescale 1ns / 1ps
`include "GLOBALS.v"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 09:41:06 PM
// Design Name: 
// Module Name: ram_2
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


//module ram_2 #(
//    parameter w=32,
//    parameter h=8,
//    parameter l=4
//    )(
//    clk,
//    ram_wdat,
//    ram_we,
//    ram_type,
//    ram_addr,
//    ram_re,
//    data_reg,
//    sign
//    );
    

//    input   wire          clk;
//    input   wire   [w-1:0]  ram_wdat;
//    input   wire          ram_we;
//    input   wire  [l-1:0]   ram_type;
//    input   wire   [w-1:0]  ram_addr;
//    input   wire            ram_re;
//    output  wire     [w-1:0] data_reg;
//    input wire sign;
    




////wire unsign=1'b1;

//wire [h-1:0] address1;
//wire [h-1:0] address2;
//wire [h-1:0] address3;
//wire [h-1:0] address4;

 
//(* ram_style = "block" *)reg [h-1:0] Bram [2**h-1:0];
////reg [w-1:0] ram_data={w{1'b0}};
////always@(posedge clk)

//assign address1 = ram_addr+1'b0;
//assign  address2 =ram_addr+1'b1;
//assign address3=ram_addr+2'b10;
//assign address4=ram_addr+2'b11;





//always@(posedge clk)

//begin
//            if(ram_we && ram_type[0])
//                Bram[address1]=ram_wdat[h-1:0];
             
                
//            if(ram_we && ram_type[1])
//                Bram[address2]= ram_wdat[2*h-1:h];
                
           

//            if(ram_we && ram_type[2])
//                Bram[address3]=ram_wdat[3*h-1:2*h];
                
            

//            if(ram_we && ram_type[3])
//                Bram[address4]=ram_wdat[4*h-1:3*h];
                
//            $display("ram2= %h %h %b %b %b %b ",{Bram[address4],Bram[address3],Bram[address2],Bram[address1]},address1,ram_type[3:0],ram_we,ram_re,sign);
           
        

//end


////read
//reg[h-1:0] data1;
//reg[h-1:0] data2;
//reg[h-1:0] data3;
//reg[h-1:0] data4;
//always @(*)
//begin
//data1=Bram[address1];
//data2=Bram[address2];
//data3=Bram[address3];
//data4=Bram[address4];
//end
///////////////////////////////////////////////////////////////////////////////////////////
////byte
//wire [w-1:0]signedbyte;
//wire [w-1:0]unsignedbyte;

////halfword
//wire [w-1:0]signedhalfword;
//wire [w-1:0]unsignedhalfword;

////threequaters
//wire [w-1:0]signedthreequaters;
//wire [w-1:0]unsignedthreequaters;

////fullword
//wire [w-1:0]fullword;

////////////////////////////////////////////////////////////////////////////////////
////sign extension
//assign signedbyte={{24{data1[7]}},data1};
//assign unsignedbyte={24'b0,data1};
//assign signedhalfword={16'b0,data2,data1};
//assign unsignedhalfword={16'b0,data2,data1};
//assign signedthreequaters={{8{data3[7]}},data3,data2,data1};
//assign unsignedthreequaters={8'b0,data3,data2,data1};
//assign fullword={data4,data3,data2,data1};


//assign data_reg=(sign==1 && ram_type==`BYTE && ram_re==1)?signedbyte:
//                (sign==0 && ram_type==`BYTE && ram_re==1)?unsignedbyte:
//                (sign==1 && ram_type==`HALFWORD && ram_re==1)?signedhalfword:
//                (sign==0 && ram_type==`HALFWORD && ram_re==1)?unsignedhalfword:
//                (sign==1 && ram_type==`THREEQUATER && ram_re==1)?unsignedthreequaters:
//                (sign==0 && ram_type==`THREEQUATER && ram_re==1)?signedthreequaters:
//                (sign==0 || sign==1 &&ram_type==`FULLWORD && ram_re==1)?fullword:
//                32'b0;




   
                                                 

           

//endmodule

module ram_2 #(
    parameter w=32,
    parameter h=8,
    parameter l=4
    )(
    clk,
    ram_wdat,
    ram_we,
    ram_type,
    sign,
    ram_addr,
    ram_re,
    data_reg,
    o_memory_address_misaligned
    );
    

    input   wire          clk;
    input   wire   [w-1:0]  ram_wdat;
    input   wire          ram_we;
    input   wire  [l-1:0]   ram_type;
    input wire sign;
    input   wire   [w-1:0]  ram_addr;
    input   wire            ram_re;
    output  wire     [w-1:0] data_reg;
    output  wire o_memory_address_misaligned;
    
    
wire[31:0] ram_word_aligned_addr;
wire[1:0] ram_word__position;
assign ram_word_aligned_addr = {2'b00,ram_addr[31:2]};
assign ram_word__position=ram_addr[1:0];


wire [3 : 0] wea;
wire [31 : 0] dina; 
wire[31:0] data_read ;
blk_mem_gen_0 bram_isnt (
  .clka(clk),    // input wire clk
  .wea(wea),      // input wire [3 : 0] wea
  .addra(ram_word_aligned_addr),  // input wire [31 : 0] addra
  .dina(dina),    // input wire [31 : 0] 
  .douta(data_read)  // wire[31:0] data_read ;
);




//memory_misalignment_exception 
reg memory_address_misaligned ;
always @(*)
begin
if (    (ram_type==`HALFWORD && ram_addr[0] != 1'b0 ) || (ram_type==`FULLWORD && ram_addr[1:0] != 2'b00) ) 
        memory_address_misaligned<= 1'b1;
else 
        memory_address_misaligned<= 1'b0;

end
assign o_memory_address_misaligned = memory_address_misaligned ;



assign wea = memory_address_misaligned==1'b0 && ram_we && ram_type==`FULLWORD ? 4'b1111 :
              memory_address_misaligned==1'b0 &&  ram_we && ram_type==`HALFWORD && ram_word__position==2'b00 ? 4'b0011 :
             memory_address_misaligned==1'b0 &&  ram_we && ram_type==`HALFWORD && ram_word__position==2'b10 ? 4'b1100 :
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b00 ? 4'b0001 : 
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b01 ? 4'b0010 :
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b10 ? 4'b0100 :
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b11 ? 4'b1000 : 4'b0000;
               
assign dina =memory_address_misaligned==1'b0 &&  ram_we && ram_type==`FULLWORD ? ram_wdat :
              memory_address_misaligned==1'b0 &&  ram_we && ram_type==`HALFWORD && ram_word__position==2'b00 ? ram_wdat :
              memory_address_misaligned==1'b0 &&  ram_we && ram_type==`HALFWORD && ram_word__position==2'b10 ? {ram_wdat[2*h-1:0],16'b0} :
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b00 ? {24'b0,ram_wdat[h-1:0]} : 
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b01 ? {16'b0,ram_wdat[h-1:0],8'b0} :
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b10 ?{8'b0,ram_wdat[h-1:0],16'b0} :
              memory_address_misaligned==1'b0 &&  ram_we &&  ram_type==`BYTE && ram_word__position==2'b11 ? {ram_wdat[h-1:0],24'b0} : 32'b0000;             
             
//always @(*)

//begin
//if (memory_address_misaligned==1'b0)
//begin
//            if(ram_we && ram_type==`FULLWORD)
//            begin
//                wea=4'b1111;
//                dina=ram_wdat;
//             end
                
//            else if(ram_we && ram_type==`HALFWORD && ram_word__position==2'b00 )
//            begin
//                wea=4'b0011;
//                dina=ram_wdat;
//            end    
//            else if(ram_we && ram_type==`HALFWORD && ram_word__position==2'b10 )
//            begin    
//                wea=4'b1100;
//                dina[4*h-1:2*h]= ram_wdat[2*h-1:0];    
//           end

//            else if(ram_we &&  ram_type==`BYTE && ram_word__position==2'b00)
//                begin
//                dina[h-1:0]=ram_wdat[h-1:0]; 
//                wea=4'b0001;
//                end              
//            else if(ram_we &&  ram_type==`BYTE && ram_word__position==2'b01)
//            begin
//                dina[2*h-1:h]=ram_wdat[h-1:0];
//                wea=4'b0010;
//            end    
//            else if(ram_we &&  ram_type==`BYTE && ram_word__position==2'b10)
//            begin
//                dina[3*h-1:2*h]=ram_wdat[h-1:0];
//                wea=4'b0100;
//            end
//            else if(ram_we &&  ram_type==`BYTE && ram_word__position==2'b11)
//            begin
//                dina[4*h-1:3*h]=ram_wdat[h-1:0];
//                wea=4'b1000;
//            end
//            else 
//                begin
//                    dina=0;
//                    wea=0;
//                end
//end
//           //$display("ram2= %h %h %b %b %b %b ",{Bram[address4],Bram[address3],Bram[address2],Bram[address1]},address1,ram_type[3:0],ram_we,ram_re,sign);

//end


//read
wire[h-1:0] data1;
wire[h-1:0] data2;
wire[h-1:0] data3;
wire[h-1:0] data4;
//always @(*)
//begin

//end

assign data1 = ram_type==`FULLWORD || (ram_type==`HALFWORD && ram_word__position==2'b00) || (ram_type==`BYTE && ram_word__position==2'b00)  ? data_read[h-1:0] :
               ram_type==`BYTE && ram_word__position==2'b01 ? data_read[2*h-1:h] :
               ram_type==`HALFWORD && ram_word__position==2'b10 || (ram_type==`BYTE && ram_word__position==2'b10)? data_read[3*h-1:2*h] :
               ram_type==`BYTE && ram_word__position==2'b11 ? data_read[4*h-1:3*h]: 8'b00000000;
               
assign data2 =  ram_type==`FULLWORD || (ram_type==`HALFWORD && ram_word__position==2'b00)  ? data_read[2*h-1:h] :
                ram_type==`HALFWORD && ram_word__position==2'b10  ? data_read[4*h-1:3*h] :  8'b00000000;
                
assign data3 =ram_type==`FULLWORD ? data_read[3*h-1:2*h]:8'b00000000;
assign data4 =ram_type==`FULLWORD ? data_read[4*h-1:3*h]:8'b00000000;
///////////////////////////////////////////////////////////////////////////////////////////
//byte
wire [w-1:0]signedbyte;
wire [w-1:0]unsignedbyte;

//halfword
wire [w-1:0]signedhalfword;
wire [w-1:0]unsignedhalfword;

//threequaters
wire [w-1:0]signedthreequaters;
wire [w-1:0]unsignedthreequaters;

//fullword
wire [w-1:0]fullword;

//////////////////////////////////////////////////////////////////////////////////
//sign extension
assign signedbyte={{24{data1[7]}},data1};
assign unsignedbyte={24'b0,data1};
assign signedhalfword={16'b0,data2,data1};
assign unsignedhalfword={16'b0,data2,data1};
assign signedthreequaters={{8{data3[7]}},data3,data2,data1};
assign unsignedthreequaters={8'b0,data3,data2,data1};
assign fullword={data4,data3,data2,data1};


assign data_reg=(memory_address_misaligned==1'b0 && sign==1 && ram_type==`BYTE && ram_re==1 )?signedbyte:
                (memory_address_misaligned==1'b0 && sign==0 && ram_type==`BYTE && ram_re==1)?unsignedbyte:
                (memory_address_misaligned==1'b0 && sign==1 && ram_type==`HALFWORD && ram_re==1)?signedhalfword:
                (memory_address_misaligned==1'b0 && sign==0 && ram_type==`HALFWORD && ram_re==1)?unsignedhalfword:
//                (sign==1 && ram_type==`THREEQUATER && ram_re==1)?unsignedthreequaters:
//                (sign==0 && ram_type==`THREEQUATER && ram_re==1)?signedthreequaters:
                (memory_address_misaligned==1'b0 && ram_type==`FULLWORD && ram_re==1)?fullword:
                 32'b0;






endmodule


