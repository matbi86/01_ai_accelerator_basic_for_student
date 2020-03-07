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
#define ICH 16
#define OCH 32

int main(){
	int time_val = time(NULL);
	printf("==== AI Basic, CNN Core. seed_num %d ====\n",time_val);
	srand(time_val);

	unsigned int kx, ky; 					// Kernel
	unsigned int ich, och; 					// in / ouput channel

	unsigned int fmap [ICH][KY][KX]; 		// 8b
	unsigned int weight[OCH][ICH][KY][KX]; 	// 8b
	unsigned int bias [OCH]; 				// 8b
	unsigned int mac_result[OCH]; 			// 24b = 16 bit + 4bit + 4 bit ( log (ICH 16) )
	unsigned int result[OCH]; 				// 25b = 24 bit + 1bit
	unsigned int result_for_demo=0; 		// 30b = 25 bit + 5 b

	// Initial Setting fmap, weight, bias value.
	for (och = 0 ; och < OCH; och ++){
		for(ich = 0; ich < ICH; ich ++){
			for(ky = 0; ky < KY; ky++){
				for(kx = 0; kx < KX; kx++){
					if(och == 0)
						fmap[ich][ky][kx] = rand()%256;
					weight[och][ich][ky][kx] = rand()%256;
				}
			}
		}
		bias[och] = rand()%256;
		mac_result[och] = 0;
	}

	// TODO
	// 1. multiply and accumulate



	// 2. added bias, no activation function



	return 0;
}
