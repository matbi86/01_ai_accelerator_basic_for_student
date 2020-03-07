/*******************************************************************************
Author: joohan.kim (https://blog.naver.com/chacagea)
Associated Filename: cnn_core.v
Purpose: verilog code to understand the CNN operation
Revision History: February 13, 2020 - initial release
*******************************************************************************/

`include "timescale.vh"

module cnn_acc_ci (
    // Clock & Reset
    clk             ,
    reset_n         ,
    i_soft_reset    ,
    i_cnn_weight    ,
    i_in_valid      ,
    i_in_fmap       ,
    o_ot_valid      ,
    o_ot_ci_acc              
    );
`include "defines_cnn_core.vh"
localparam LATENCY = 1;

input                               clk         	;
input                               reset_n     	;
input                               i_soft_reset	;
input     [CI*KX*KY*W_BW-1 : 0]  	i_cnn_weight 	;
input                               i_in_valid  	;
input     [CI*KX*KY*I_F_BW-1 : 0]  	i_in_fmap    	;
output                              o_ot_valid  	;
output    [ACI_BW-1 : 0]  			o_ot_ci_acc 	;


//==============================================================================
// Data Enable Signals 
//==============================================================================
wire    [LATENCY-1 : 0] 	ce;
reg     [LATENCY-1 : 0] 	r_valid;
wire    [CI-1 : 0]          w_ot_valid;
always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        r_valid   <= {LATENCY{1'b0}};
    end else if(i_soft_reset) begin
        r_valid   <= {LATENCY{1'b0}};
    end else begin
        r_valid[LATENCY-1]  <= &w_ot_valid;
    end
end

assign	ce = r_valid;
//==============================================================================
// mul_acc kenel instance
//==============================================================================
wire    [CI-1 : 0]              w_in_valid;
wire    [CI*AK_BW-1 : 0]  		w_ot_kernel_acc;
wire    [ACI_BW-1 : 0]  		w_ot_ci_acc;
reg     [ACI_BW-1 : 0]  		r_ot_ci_acc;
reg     [ACI_BW-1 : 0]  		ot_ci_acc;

// TODO Call cnn_kernel Instance


// TODO Accumulation Logic


// TODO F/F

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        r_ot_ci_acc[0 +: ACI_BW] <= {ACI_BW{1'b0}};
    end else if(i_soft_reset) begin
        r_ot_ci_acc[0 +: ACI_BW] <= {ACI_BW{1'b0}};
    end else if(&w_ot_valid)begin
        r_ot_ci_acc[0 +: ACI_BW] <= w_ot_ci_acc[0 +: ACI_BW];
    end
end

assign o_ot_valid = r_valid[LATENCY-1];
assign o_ot_ci_acc = r_ot_ci_acc;

endmodule
