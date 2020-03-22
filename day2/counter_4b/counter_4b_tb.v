//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: Matbi / Austin
//
// Create Date:
// Design Name: 4 bit counter
// Module Name: counter_4b_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Verifify module counter_4_bit
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module counter_4b_tb;
reg clk , reset_n;
reg i_data_en;
reg [3:0] i_cnt_value;
wire [3:0] o_cnt;
 
// clk gen
always
    #5 clk = ~clk;
 
initial begin
//initialize value
$display("initialize value [%d]", $time);
    reset_n = 1;
    clk     = 0;
	i_cnt_value = 4'hf;
// reset_n gen
$display("Reset! [%d]", $time);
# 100
    reset_n = 0;
# 10
    reset_n = 1;
// start
# 20
$display("Start! [%d]", $time);
i_data_en=1;
# 100
$display("Finish! [%d]", $time);
$finish;
end
 
// Call DUT
counter_4b u_counter_4b(
    .clk (clk),
    .reset_n (reset_n),
	.i_data_en(i_data_en),
	.i_cnt_value(i_cnt_value),
    .o_cnt(o_cnt)    // mapping, Other names are available
    );
endmodule
