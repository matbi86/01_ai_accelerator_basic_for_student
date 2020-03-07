/*******************************************************************************
Author: joohan.kim (https://blog.naver.com/chacagea)
Associated Filename: cnn_core_tb.v
Purpose: Verification for cnn_core
Revision History: February 13, 2020 - initial release
*******************************************************************************/

`include "timescale.vh"

`define TRACE_IN_FMAP 	"./trace/in_fmap.txt" 
`define TRACE_IN_WEIGHT "./trace/in_weight.txt"
`define TRACE_IN_BIAS 	"./trace/in_bias.txt"
`define TRACE_OT_RESULT "./trace/ot_result_rtl.txt"

//`define USE_CHECKER

module cnn_core_tb ();
`include "defines_cnn_core.vh"

integer fp_f, fp_w, fp_b, fp_result;
integer kx, ky; 					// Kernel
integer ich, och; 					// in / ouput channel

reg clk , reset_n, soft_reset;

reg     [CO*CI*KX*KY*W_BW-1 : 0] 	cnn_weight 	;
reg     [CO*B_BW-1    : 0]  		cnn_bias   	;
reg                               	in_valid  	;
reg     [CI*KX*KY*I_F_BW-1 : 0]  	in_fmap    	;
wire                              	w_ot_valid  ;
wire    [CO*O_F_BW-1 : 0]  			w_ot_fmap   ;

// clk gen
always
    #5 clk = ~clk;

initial begin
//initialize value
$display("initialize value [%d]", $time);
    reset_n 	= 1;
    clk     	= 0;
	soft_reset  = 0;
	cnn_weight 	= 0;
	cnn_bias   	= 0;
	in_valid  	= 0;
	in_fmap    	= 0;
// reset_n gen
$display("Reset! [%d]", $time);
# 10
   reset_n = 0;
# 10
   reset_n = 1;
// start
$display("Read Input! [%d]", $time);
read_trace(cnn_weight, cnn_bias, in_fmap);
$display("Start! [%d]", $time);
@(posedge clk);
	in_valid = 1;

`ifdef USE_CHECKER
wait(w_ot_valid);
@(negedge clk);
$display("Write Output! [%d]", $time);
write_result(w_ot_fmap);
in_valid =0;
`endif

# 1000
$display("Finish! [%d]", $time);
$finish;
end
 
// Call DUT
cnn_core u_cnn_core(
    // Clock & Reset
    .clk             (clk         	),
    .reset_n         (reset_n     	),
    .i_soft_reset    (soft_reset	),
    .i_cnn_weight    (cnn_weight	),
    .i_cnn_bias      (cnn_bias  	),
    .i_in_valid      (in_valid  	),
    .i_in_fmap       (in_fmap   	),
    .o_ot_valid      (w_ot_valid  	),
    .o_ot_fmap       (w_ot_fmap   	)      
    );

// $fscanf return the number of successful assignments performed.
task read_trace;
	output     [CO*CI*KX*KY*W_BW-1 : 0] 	cnn_weight 	;
	output     [CO*B_BW-1    : 0]  			cnn_bias   	;
	output     [CI*KX*KY*I_F_BW-1 : 0]  	in_fmap    	;
	reg		   [7:0]						fmap, weight, bias;
	integer									read_och,read_ich, result,temp;
	reg 									fcheck;
	begin
		fp_f = $fopen(`TRACE_IN_FMAP, "r");
		fp_w = $fopen(`TRACE_IN_WEIGHT, "r");
		fp_b = $fopen(`TRACE_IN_BIAS, "r");
		fcheck = fp_f && fp_w && fp_b;
		if(fcheck)
			$display("success file open");
   		else 
			$finish;
		for (och = 0 ; och < CO; och = och+1)begin
			for(ich = 0; ich < CI; ich = ich+1)begin
				if(och == 0) begin
					result = $fscanf(fp_f,"(%d,%d) ", read_och, read_ich); 
					if(och != read_och) begin $finish; end
					if(ich != read_ich) begin $finish; end
				end
				result = $fscanf(fp_w,"(%d,%d) ", read_och, read_ich);
				if(och != read_och) begin $finish; end
				if(ich != read_ich) begin $finish; end

				for(ky = 0; ky < KY; ky = ky+1)begin
					for(kx = 0; kx < KX; kx = kx+1)begin
						if(och == 0) begin
							result = $fscanf(fp_f,"%d ", fmap);
							in_fmap[(och*CI*KY*KX+ ich*KY*KX+ ky*KX + kx)*I_F_BW +: I_F_BW] = fmap;
						end
						result = $fscanf(fp_w,"%d ", weight);
						cnn_weight[(och*CI*KY*KX+ ich*KY*KX+ ky*KX + kx)*W_BW +: W_BW] = weight;
					end
				end
				if(och == 0)
					result = $fscanf(fp_f,"\n",temp);
				result = $fscanf(fp_w,"\n",temp);
			end
			result = $fscanf(fp_b,"(%d,0) %d\n", read_och, bias);
//			$display("(%d,0) %d", read_och, bias);
			if(och != read_och) begin $finish; end
			cnn_bias[och*B_BW +: B_BW] = bias;
			result = $fscanf(fp_w,"\n",temp);
		end
		$fclose(fp_f);
		$fclose(fp_w);
		$fclose(fp_b);
	end
endtask

task write_result;
	input    [CO*O_F_BW-1 : 0]  			i_ot_fmap   ;
	integer									read_och,read_ich, result,temp;
	reg [O_F_BW-1 : 0]	ot_fmap;
	begin
		fp_result = $fopen(`TRACE_OT_RESULT, "w");
		for (och = 0 ; och < CO; och = och+1)begin
			ot_fmap = i_ot_fmap[och*O_F_BW +: O_F_BW];
			$fdisplay(fp_result,"(%0d,0) %0d", och, ot_fmap);
			$display("(%0d,0) %d", och, ot_fmap);
		end
		$fclose(fp_result);
	end
endtask

endmodule
