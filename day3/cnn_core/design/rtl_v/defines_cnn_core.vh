/*******************************************************************************
Author: joohan.kim (https://blog.naver.com/chacagea)
Associated Filename: defines_cnn_core.vh
Purpose: c code to understand the CNN operation
Revision History: February 13, 2020 - initial release
*******************************************************************************/

parameter   CNN_PIPE    = 5;
parameter   CI          = 3;
parameter   CO          = 16;
parameter	KX			= 3;
parameter	KY			= 3;

parameter   I_F_BW      = 8;
parameter   W_BW        = 8; // Weight BW
parameter   B_BW        = 8; // Bias BW

parameter   M_BW        = 16; 
parameter   AK_BW       = 20; // M_BW + log(KY*KX) accum kernel 
parameter   ACI_BW		= 22; // AK_BW + log (CI)
parameter   AB_BW       = 23;
parameter   O_F_BW      = 23; // No Activation, So O_F_BW == AB_BW

parameter   O_F_ACC_BW  = 27; // for demo
