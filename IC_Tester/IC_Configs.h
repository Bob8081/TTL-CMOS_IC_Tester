#ifndef IC_CONFIGS_H_
#define IC_CONFIGS_H_

#include <stddef.h>
#include <stdint.h>


#define IC_7408 ICs[0]
#define IC_4066 ICs[1]
#define IC_7445 ICs[2]
#define IC_4532 ICs[3]
#define IC_74157 ICs[4]
#define IC_74156 ICs[5]


unsigned char test_7408(void);
unsigned char test_4066(void);
unsigned char test_7445(void);
unsigned char test_4532(void);
unsigned char test_74157(void);
unsigned char test_74156(void);



typedef enum {
    DIP14,
    DIP16
} IC_Package;


typedef struct {
    unsigned char input_mask_PD;
    unsigned char input_mask_PA;
    unsigned char output_mask_PD;
    unsigned char output_mask_PA;
    IC_Package package_type;
    unsigned char (*test_function)(void);
} IC_Config;


IC_Config ICs[] = {

	{ // IC 7408
	.input_mask_PD = (1 << PORTD0) | (1 << PORTD1) | (1 << PORTD3) | (1 << PORTD4),
	.input_mask_PA = (1 << PORTA1) | (1 << PORTA2) | (1 << PORTA4) | (1 << PORTA5),
	.output_mask_PD = (1 << PORTD2) | (1 << PORTD5),
	.output_mask_PA = (1 << PORTA6) | (1 << PORTA3),
	.package_type = DIP14,
	.test_function = test_7408
	},
	 
	{ // IC 4066
	.input_mask_PD = (1 << PORTD0) | (1 << PORTD2) | (1 << PORTD4) | (1 << PORTD5), // I1, I2, C2, C3
	.input_mask_PA = (1 << PORTA1) | (1 << PORTA2) | (1 << PORTA4) | (1 << PORTA6), // C1, C4, I4, I3
	.output_mask_PD = (1 << PORTD1) | (1 << PORTD3), // O1, O2
	.output_mask_PA = (1 << PORTA3) | (1 << PORTA5), // O4, O3
	.package_type = DIP14,
	.test_function = test_4066
	},
	
	
	{ // IC 7445
    .input_mask_PD = 0, // No Inputs on PORTD
    .input_mask_PA =(1 << PORTA1) | (1 << PORTA2) | (1 << PORTA3) | (1 << PORTA4), // Inputs D, C, B, A
    .output_mask_PD = (1 << PORTD0) | (1 << PORTD1) | (1 << PORTD2) | (1 << PORTD3) | (1 << PORTD4) | (1 << PORTD5) | (1 << PORTD6), // Outputs 0-6
    .output_mask_PA = (1 << PORTA5) | (1 << PORTA6) | (1 << PORTA7), // Outputs 7-9
    .package_type = DIP16,
    .test_function = test_7445
	},
	
	{ // IC 4532
    .input_mask_PD = (1 << PORTD0) | (1 << PORTD1) | (1 << PORTD2) | (1 << PORTD3) | (1 << PORTD4), // Inputs 4-7 , EN-IN
    .input_mask_PA = (1 << PORTA3) | (1 << PORTA4) | (1 << PORTA5) | (1 << PORTA6), // Inputs 3-0
	.output_mask_PD = (1 << PORTD5) | (1 << PORTD6), // Q2, Q1
    .output_mask_PA = (1 << PORTA1) | (1 << PORTA2) | (1 << PORTA7), // EN-Out, GS, Q0
    .package_type = DIP16,
    .test_function = test_4532
	},
	
	{ // IC 74157
    .input_mask_PD = (1 << PORTD0) | (1 << PORTD1) | (1 << PORTD2) | (1 << PORTD4) | (1 << PORTD5), // Select, 1A,1B, 2A,2B
    .input_mask_PA = (1 << PORTA1) | (1 << PORTA2) | (1 << PORTA3) | (1 << PORTA5) | (1 << PORTA6), // EN, 4A,4B, 3A,3B
    .output_mask_PD = (1 << PORTD3) | (1 << PORTD6), // 1Y, 2Y
    .output_mask_PA = (1 << PORTA4) | (1 << PORTA7), // 4Y, 3Y
    .package_type = DIP16,
    .test_function = test_74157
	},
	
	{ // IC 74156
    .input_mask_PD = (1 << PORTD0) | (1 << PORTD1) | (1 << PORTD2), // I1, EN1, Address B
    .input_mask_PA = (1 << PORTA1) | (1 << PORTA2) | (1 << PORTA3), // I2, EN2, Adress A
    .output_mask_PD = (1 << PORTD3) | (1 << PORTD4) | (1 << PORTD5) | (1 << PORTD6), // 1Q0 - 1Q3
    .output_mask_PA = (1 << PORTA4) | (1 << PORTA5) | (1 << PORTA6) | (1 << PORTA7), // 2Q0-2Q3
    .package_type = DIP16,
    .test_function = test_74156
	},
	
	
};
	

#endif