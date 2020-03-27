/*******************************************************************************
Author: joohan.kim (https://blog.naver.com/chacagea)
Associated Filename: defines_cnn_core.vh
Purpose: c code to understand the CNN operation
Revision History: February 13, 2020 - initial release
*******************************************************************************/

parameter   CNN_PIPE    = 5;  // no used, to use ctrl latency
parameter   CI          = 3;  // Number of Channel Input 
parameter   CO          = 16; // Number of Channel Output
parameter	KX			= 3;  // Number of Kernel X
parameter	KY			= 3;  // Number of Kernel Y

parameter   I_F_BW      = 8;  // Bit Width of Input Feature
parameter   W_BW        = 8;  // BW of weight parameter
parameter   B_BW        = 8;  // BW of bias parameter

parameter   M_BW        = 16; // I_F_BW * W_BW
parameter   AK_BW       = 20; // M_BW + log(KY*KX) Accum Kernel 
parameter   ACI_BW		= 22; // AK_BW + log (CI) Accum Channel Input
parameter   AB_BW       = 23; // ACI_BW + bias (#1). 
parameter   O_F_BW      = 23; // No Activation, So O_F_BW == AB_BW

parameter   O_F_ACC_BW  = 27; // for demo, O_F_BW + log (CO)
