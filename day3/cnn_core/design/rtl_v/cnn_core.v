/*******************************************************************************
Author: joohan.kim (https://blog.naver.com/chacagea)
Associated Filename: cnn_core.v
Purpose: verilog code to understand the CNN operation
Revision History: February 13, 2020 - initial release
*******************************************************************************/

`include "timescale.vh"

module cnn_core (
    // Clock & Reset
    clk             ,
    reset_n         ,
    i_soft_reset    ,
    i_cnn_weight    ,
    i_cnn_bias      ,
    i_in_valid      ,
    i_in_fmap       ,
    o_ot_valid      ,
    o_ot_fmap             
    );
`include "defines_cnn_core.vh"

localparam LATENCY = 1;
//==============================================================================
// Input/Output declaration
//==============================================================================
input                               clk         	;
input                               reset_n     	;
input                               i_soft_reset	;
input     [CO*CI*KX*KY*W_BW-1 : 0]  i_cnn_weight 	;
input     [CO*B_BW-1    : 0]  		i_cnn_bias   	;
input                               i_in_valid  	;
input     [CI*KX*KY*I_F_BW-1 : 0]  	i_in_fmap    	;
output                              o_ot_valid  	;
output    [CO*O_F_BW-1 : 0]  		o_ot_fmap    	;

//==============================================================================
// Data Enable Signals 
//==============================================================================
wire    [LATENCY-1 : 0] 	ce;
reg     [LATENCY-1 : 0] 	r_valid;
wire    [CO-1 : 0]          w_ot_valid;
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
// acc ci instance
//==============================================================================

wire    [CO-1 : 0]              w_in_valid;
wire    [CO*(ACI_BW)-1 : 0]  	w_ot_ci_acc;

// TODO Call cnn_acc_ci Instance



//==============================================================================
// add_bias = acc + bias
//==============================================================================
wire      [CO*AB_BW-1 : 0]   add_bias  ;
reg       [CO*AB_BW-1 : 0]   r_add_bias;

// TODO add bias


//==============================================================================
// No Activation
//==============================================================================
assign o_ot_valid = r_valid[LATENCY-1];
assign o_ot_fmap  = r_add_bias;

endmodule

