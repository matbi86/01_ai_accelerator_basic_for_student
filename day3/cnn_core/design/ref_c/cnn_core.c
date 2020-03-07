/*******************************************************************************
Author: joohan.kim (https://blog.naver.com/chacagea)
Associated Filename: cnn_core.c
Purpose: c code to understand the CNN operation
Revision History: February 13, 2020 - initial release
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define KX 3
#define KY 3
#define ICH 3
#define OCH 16

#define IN_FMAP 	"./trace/in_fmap.txt"
#define IN_WEIGHT 	"./trace/in_weight.txt"
#define IN_BIAS 	"./trace/in_bias.txt"
#define OT_RESULT 	"./trace/ot_result.txt"

int main(){
	int time_val = time(NULL);
	printf("==== AI Basic, CNN Core. seed_num %d ====\n",time_val);
	srand(time_val);

	unsigned int kx, ky; 					// Kernel
	unsigned int ich, och; 					// in / ouput channel

	unsigned int fmap [ICH][KY][KX]; 		// 8b
	unsigned int weight[OCH][ICH][KY][KX]; 	// 8b
	unsigned int bias [OCH]; 				// 8b
	unsigned int mac_result[OCH]; 			// 22b = 16 bit + 4bit ( log (KY*KX 9) ) + 2 bit ( log (ICH 3) )
	unsigned int result[OCH]; 				// 23b = 22 bit + 1bit (bias)
	unsigned int result_for_demo=0; 		// 27b = 23 bit + 4 b ( log (OCH 16) )
	
	FILE *fp_f, *fp_w, *fp_b, *fp_result;

	if ((fp_f = fopen(IN_FMAP, "w")) == NULL) {
		printf("File Open Error (%s) \n", IN_FMAP);
		return 0;
	}
	if ((fp_w = fopen(IN_WEIGHT, "w")) == NULL) {
		printf("File Open Error (%s) \n", IN_WEIGHT);
		return 0;
	}
	if ((fp_b = fopen(IN_BIAS, "w")) == NULL) {
		printf("File Open Error (%s) \n", IN_BIAS);
		return 0;
	}
	if ((fp_result = fopen(OT_RESULT, "w")) == NULL) {
		printf("File Open Error (%s) \n", OT_RESULT);
		return 0;
	}

	// Initial Setting fmap, weight, bias value.
	for (och = 0 ; och < OCH; och ++){
		for(ich = 0; ich < ICH; ich ++){
			if(och == 0)
				fprintf(fp_f,"(%d,%d) ", och, ich);
			fprintf(fp_w,"(%d,%d) ", och, ich);
			for(ky = 0; ky < KY; ky++){
				for(kx = 0; kx < KX; kx++){
					if(och == 0) {
						fmap[ich][ky][kx] = rand()%256;
						fprintf(fp_f,"%d ", fmap[ich][ky][kx]);
					}
					weight[och][ich][ky][kx] = rand()%256;
					fprintf(fp_w,"%d ", weight[och][ich][ky][kx]);
				}
			}
			if(och == 0)
				fprintf(fp_f,"\n");
			fprintf(fp_w,"\n");
		}
		bias[och] = rand()%256;
		mac_result[och] = 0;
		fprintf(fp_b,"(%d,0) %d\n", och, bias[och]);
		fprintf(fp_w,"\n");
	}
	fclose(fp_f);
	fclose(fp_w);
	fclose(fp_b);


	// TODO Add yours code at day 1





	// to check result between ref_c vs rtl_v
	for (och = 0 ; och < OCH; och ++){
		result_for_demo += result[och];
	}
	printf("result_for_demo : %d\n", result_for_demo);
//	fprintf(fp_result,"result_for_demo : %d\n", result_for_demo);
	fclose(fp_result);
	return 0;
}
