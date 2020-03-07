#!/usr/bin/env python

#/*******************************************************************************
#Author: joohan.kim (https://blog.naver.com/chacagea)
#Associated Filename: run.py
#Purpose: To run simulation
#Revision History: In March 13, 2020 - initial release
#*******************************************************************************/

import os
import argparse

REF_C_RUN = "../../cnn_core/design/ref_c/cnn_core";
CLEAN_CMD = "rm -rf *xe* *xs* *.wdb* *trace* *xv* *we*"
##====================================================================
## Main
##====================================================================
def main() :
	args = parse_args()
	if (args.clean) :
		run_cmd(CLEAN_CMD)
		print ("Clean Done!!")
	else :	
		make_dirs()
		run_sim(args)
		check_result()
		print ("Success Simulation!!")
##====================================================================
## setup_cmdargs
##====================================================================
def parse_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("-waveform"	,dest="waveform"	,action="store_true"	,help="Show waveform using vivado sim")
	parser.add_argument("-clean"	,dest="clean"		,action="store_true"	,help="Clean in Folder")
	args = parser.parse_args()
	return args
##====================================================================
## make dirs
##====================================================================
def make_dirs():
	os.system("rm -rf ./trace")
	dir = ("./trace")
	if not os.path.exists(dir):
		os.mkdir(dir)

##====================================================================
## Run sim
##====================================================================
def run_sim(args):
	run_ref_c()
	run_rtl_v(args)

def run_ref_c():
	run_cmd(REF_C_RUN)

def run_rtl_v(args):
	cmd = "xvlog -f ./listfile.f -i ../design/rtl_v/ ./cnn_core_tb.v"
	run_cmd(cmd)

	cmd = "xelab cnn_core_tb -debug wave -s cnn_core_tb"
	run_cmd(cmd)
	
	if(args.waveform) :
		cmd = "xsim cnn_core_tb -gui -wdb simulate_xsim_cnn_core_tb.wdb"
	else :
		cmd = "xsim cnn_core_tb -R"
	run_cmd(cmd)

##====================================================================
## Check result
##====================================================================
def check_result():
	check_cmd = "diff ./trace/ot_result.txt ./trace/ot_result_rtl.txt"
	run_cmd(check_cmd)
 
def run_cmd(cmd):
	print (cmd)
	if os.system(cmd):
		print ("Error command runned incorrectly...")
		sys.exit(1)
 
if __name__ == "__main__":
	main()
