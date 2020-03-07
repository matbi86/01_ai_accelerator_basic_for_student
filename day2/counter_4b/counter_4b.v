//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: Matbi / Austin
//
// Create Date:
// Design Name: 4 bit counter
// Module Name: counter_4b
// Project Name:
// Target Devices:
// Tool Versions:
// Description: when posedge clk and assert data_en is high, 
//				counted value of '1'. overflow ver.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
 
`timescale 1ns / 1ps
module counter_4b(
    input clk,
    input reset_n,
	input i_data_en,
	input [3:0] i_cnt_value,
    output reg [3:0] o_cnt,
	output reg o_result
    );

// TODO 





endmodule
