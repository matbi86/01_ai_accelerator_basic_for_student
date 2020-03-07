/*******************************************************************************
Author: joohan.kim (https://blog.naver.com/chacagea)
Associated Filename: cnn_core.v
Purpose: verilog code to understand the CNN operation
Revision History: February 13, 2020 - initial release
*******************************************************************************/

`include "timescale.vh"
module cnn_kernel (
    // Clock & Reset
    clk             ,
    reset_n         ,
    i_soft_reset    ,
    i_cnn_weight    ,
    i_in_valid      ,
    i_in_fmap       ,
    o_ot_valid      ,
    o_ot_kernel_acc              
    );
`include "defines_cnn_core.vh"
localparam LATENCY = 2;

input                               clk         	;
input                               reset_n     	;
input                               i_soft_reset	;
input     [KX*KY*W_BW-1 : 0]  		i_cnn_weight 	;
input                               i_in_valid  	;
input     [KX*KY*I_F_BW-1 : 0]  	i_in_fmap    	;
output                              o_ot_valid  	;
output    [AK_BW-1 : 0]  			o_ot_kernel_acc ;


//==============================================================================
// Data Enable Signals 
//==============================================================================
wire    [LATENCY-1 : 0] 	ce;
reg     [LATENCY-1 : 0] 	r_valid;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        r_valid   <= {LATENCY{1'b0}};
    end else if(i_soft_reset) begin
        r_valid   <= {LATENCY{1'b0}};
    end else begin
        r_valid[LATENCY-2]  <= i_in_valid;
        r_valid[LATENCY-1]  <= r_valid[LATENCY-2];
    end
end

assign	ce = r_valid;

//==============================================================================
// mul = fmap * weight
//==============================================================================

wire      [KY*KX*M_BW-1 : 0]    mul  ;
reg       [KY*KX*M_BW-1 : 0]    r_mul;

// TODO Multiply each of Kernels

reg       [AK_BW-1 : 0]    acc_kernel 	;
reg       [AK_BW-1 : 0]    r_acc_kernel   ;

// TODO Accumulate to generate 1 point. if use generate, you can use the template below 
//integer acc_idx;
//generate
//	// TODO Logic
//
//
//	// TODO F/F
//endgenerate

assign o_ot_valid = r_valid[LATENCY-1];
assign o_ot_kernel_acc = r_acc_kernel;

endmodule
