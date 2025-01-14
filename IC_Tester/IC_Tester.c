#include <mega32a.h>
#include <io.h>
#include <stdint.h>
#include <delay.h>
#include <string.h>
#include <glcd.h>
#include <font5x7.h>
#include "IC_Configs.h"
#include <stdio.h>




// Pin Definitions
#define LED_PASS    PORTC0
#define LED_FAIL    PORTC1
#define TEST_BUTTON_PIN PINB3

//GLCD Parameters
#define GLCD_LCD_WIDTH 84
#define LINES_DY 9

#define F_CPU 11059200UL 

#define NUM_ICs (sizeof(ICs) / sizeof(IC_Config))



// Function prototypes
void initialize_ports(void);
void power_ic(IC_Package package_type);
void display_result(unsigned char result);
void glcd_drawCenteredStr(const char *str, uint8_t y, uint8_t dx);
unsigned char is_button_pressed();
void clear_LEDs();
void clear_ports();
unsigned char reverseBits(unsigned char num);



void main(void) {
    unsigned char result = 0;  
	unsigned char state = 1;
	unsigned char current_ic = 0;

	
	
	// Initialize Nokia5110 Display
	GLCDINIT_t glcd_init_data;
    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = PCD8544_DEFAULT_TEMP_COEF;
    glcd_init_data.bias = PCD8544_DEFAULT_BIAS;
    glcd_init_data.vlcd = PCD8544_DEFAULT_VLCD;
    glcd_init(&glcd_init_data);
	
	// Clear the display
    glcd_clear();

    // Initialize ports
    initialize_ports();
	

    // Main loop
    while (1) {
        switch (state) {
            case 1: // Idle State
				clear_LEDs();
				
                // Display message
                glcd_drawCenteredStr("Press to test", LINES_DY * 2, 1);
				
                // Wait for button press
                if (is_button_pressed()) {
                    state = 2; // Move to Testing State
					
                    while (is_button_pressed()); // Wait for button release
                }
                break;

            case 2: // Testing State
				
				glcd_clear();
				glcd_drawCenteredStr("Testing...", LINES_DY * 2, 1);
				while (current_ic < NUM_ICs) {
					// Run the test for the current IC
					result = ICs[current_ic].test_function();
					clear_ports();

					if (result) {
						state = 3;
					 break;
					}

                    // Move to the next IC or Result State
                    current_ic++;
                }
				
				display_result(result);
                state = 3; // All tests completed, move to Result State
                
                break;
            case 3: // Result State
				
				// Wait for button press to move to Idle State
                if (is_button_pressed()) {
					while (is_button_pressed()); // Wait for button release
					glcd_clear(); 
                    current_ic = 0;
                    state = 1; // Move to Result State
                    
                }
                break;
        }
    }
}

void initialize_ports(void) {
    // Configure TEST_BUTTON_PIN as input with pull-up
    DDRB &= ~(1 << TEST_BUTTON_PIN);
    PORTB |= (1 << TEST_BUTTON_PIN);

    // Configure LED pins
    DDRC |= (1 << LED_PASS) | (1 << LED_FAIL);
    PORTC &= ~((1 << LED_PASS) | (1 << LED_FAIL)); 
    
}

void power_ic(IC_Package package_type) {
    IC_Package package = package_type;
	
	
	// Reset power pins
	DDRA |= (1 << PORTA0);
    PORTA &= ~(1 << PORTA0);
    if (package == DIP14) {
		DDRD |= (1 << PORTD6);
        PORTD &= ~(1 << PORTD6);
    } else if (package == DIP16) {
		DDRD |= (1 << PORTD7);
        PORTD &= ~(1 << PORTD7);
    }
    delay_ms(5);

    // Power the IC
    PORTA |= (1 << PORTA0);
    if (package == DIP14) {
        PORTD &= ~(1 << PORTD6);
    } else if (package == DIP16) {
        PORTD &= ~(1 << PORTD7);
    }
}

unsigned char test_7408(void) {
    unsigned char i;
    unsigned char input1, input2; // Inputs for gates
    unsigned char output1, output2, output3, output4;


    // Configure 7408 input pins as outputs (from MCU)
    DDRD |= IC_7408.input_mask_PD;
    DDRA |= IC_7408.input_mask_PA;

    // Configure 7408 output pins as inputs (from MCU)
    DDRD &= ~IC_7408.output_mask_PD;
    DDRA &= ~IC_7408.output_mask_PA;

    // Set initial pin states to low
    PORTD &= ~IC_7408.input_mask_PD;
    PORTA &= ~IC_7408.input_mask_PA;    

    power_ic(IC_7408.package_type);

    for (i = 0; i < 4; i++) {
        input1 = (i & 0x01); // LSB of inputs
        input2 = (i & 0x02) >> 1; // MSB of inputs

        PORTD = (PORTD & ~IC_7408.input_mask_PD) | (input1 << PORTD0) | (input2 << PORTD1) | (input1 << PORTD3) | (input2 << PORTD4);
        PORTA = (PORTA & ~IC_7408.input_mask_PA) | (input1 << PORTA1) | (input2 << PORTA2) | (input1 << PORTA4) | (input2 << PORTA5);

        delay_ms(20); // Allow time for IC to process

        // Read outputs for all gates
        output1 = (PIND & (1 << PORTD2)) >> PORTD2; // Gate 1 output
        output2 = (PIND & (1 << PORTD5)) >> PORTD5; // Gate 2 output
        output3 = (PINA & (1 << PORTA3)) >> PORTA3; // Gate 3 output
        output4 = (PINA & (1 << PORTA6)) >> PORTA6; // Gate 4 output  

        delay_ms(10);

        if (output1 != (input1 & input2)) return 0; // Gate 1 check
        if (output2 != (input1 & input2)) return 0; // Gate 2 check
        if (output3 != (input1 & input2)) return 0; // Gate 3 check
        if (output4 != (input1 & input2)) return 0; // Gate 4 check   
    }

    glcd_clear();
    glcd_drawCenteredStr("IC is 7408", LINES_DY * 2, 1);
    glcd_drawCenteredStr("DIP14 - TTL", LINES_DY * 3, 1);
    return 1; // Test passed
}

unsigned char test_4066(void) {
    unsigned char i;
    unsigned char control, input, output1, output2, output3, output4;

    // Configure control and input pins as outputs (from MCU)
    DDRD |= IC_4066.input_mask_PD;
    DDRA |= IC_4066.input_mask_PA;

    // Configure output pins as inputs (from MCU)
    DDRD &= ~IC_4066.output_mask_PD;
	DDRA &= ~IC_4066.output_mask_PA;

    // Set initial pin states to low
    PORTD &= ~IC_4066.input_mask_PD;
    PORTA &= ~IC_4066.input_mask_PA;

    power_ic(IC_4066.package_type);

    // Testing loop for all switch combinations
    for (i = 0; i < 2; i++) {
        control = 1; // Set control to 0 or 1
        input = i;   // Set input to 0 or 1

        // Set control and inputs
        PORTD = (PORTD & ~IC_4066.input_mask_PD) | (input << PORTD0) | (input << PORTD2) | (control << PORTD4) | (control << PORTD5);
        PORTA = (PORTA & ~IC_4066.input_mask_PA) | (control << PORTA1) | (control << PORTA2) | (input << PORTA4) | (input << PORTA6);
				
        delay_ms(20); // Allow time for IC to process

        // Read outputs for all switches
        output1 = ((PIND & (1 << PORTD1)) >> PORTD1);
        output2 = ((PIND & (1 << PORTD3)) >> PORTD3);  
        output3 = ((PINA & (1 << PORTA3)) >> PORTA3);
        output4 = ((PINA & (1 << PORTA5)) >> PORTA5);     
        

		
        delay_ms(10);

        // Verify output matches the input for all switches
        if (output1 != input) return 0;
		if (output2 != input) return 0;
		if (output3 != input) return 0;
		if (output4 != input) return 0;
    }

    glcd_clear();
    glcd_drawCenteredStr("IC is 4066", LINES_DY * 2, 1);
    glcd_drawCenteredStr("DIP14 - CMOS", LINES_DY * 3, 1);
    return 1; // Test passed
}

unsigned char test_7445(void) {
    unsigned char input, expected_PA, expected_PD, i;
    unsigned char outputs_PD, outputs_PA;

    // Configure input pins as outputs (from MCU)
    DDRD |= IC_7445.input_mask_PD;
    DDRA |= IC_7445.input_mask_PA;

    // Configure output pins as inputs (from MCU)
    DDRD &= ~IC_7445.output_mask_PD;
    DDRA &= ~IC_7445.output_mask_PA;

    // Set initial input states to low
    PORTD &= ~IC_7445.input_mask_PD;
    PORTA &= ~IC_7445.input_mask_PA;

    power_ic(IC_7445.package_type);

    // Testing loop for all BCD inputs
    for (i = 0; i < 10; i++) {
        // Set inputs (BCD value)
        input = i;
        PORTA = (PORTA & ~IC_7445.input_mask_PA) | ((input & 0x0F) << PORTA1); // Set D, C, B, A

        delay_ms(20); // Allow time for IC to process

        // Read outputs
        outputs_PD = (PIND & IC_7445.output_mask_PD); // Outputs 0-6
        outputs_PA = (PINA & IC_7445.output_mask_PA); // Outputs 7-9
		
		expected_PD = 0x7F; // All high initially
        expected_PA = 0xE0;  
        
        delay_ms(10);

        if (input < 7) {
            expected_PD &= ~(1 << input); // Set the correct bit low
        } else {
            expected_PA &= ~(1 << (14 - input));
        }
		
		 if (outputs_PD != expected_PD || outputs_PA != expected_PA) {
            return 0; // Test failed
        }
    }

    glcd_clear();
    glcd_drawCenteredStr("IC is 7445", LINES_DY * 2, 1);
    glcd_drawCenteredStr("DIP16 - TTL", LINES_DY * 3, 1);
    return 1; // Test passed
}

unsigned char test_4532(void) {
    unsigned char input;
    unsigned char outputs_PD;
    unsigned char outputs_PA;
    unsigned char expected_output;
    unsigned char q0;
    unsigned char q2;
    unsigned char q1;
    unsigned char combined_output;

    // Configure input pins as outputs (from MCU)
    DDRD |= IC_4532.input_mask_PD;
    DDRA |= IC_4532.input_mask_PA;

    // Configure output pins as inputs (from MCU)
    DDRD &= ~IC_4532.output_mask_PD;
    DDRA &= ~IC_4532.output_mask_PA;

    // Set initial input states to low (important for priority encoder)
    PORTD &= ~IC_4532.input_mask_PD;
    PORTA &= ~IC_4532.input_mask_PA;

    // Set EN_IN high to enable the encoder
    PORTD |= (1 << PORTD4); // Assuming PORTD4 is EN_IN

    power_ic(IC_4532.package_type);

    // Test each input individually, starting with the highest priority
    for (input = 7; input > 0; input--) {
		
		PORTD &= ~((1 << PORTD0) | (1 << PORTD1) | (1 << PORTD2) | (1 << PORTD3));
		PORTA &= ~((1 << PORTA3) | (1 << PORTA4) | (1 << PORTA5) | (1 << PORTA6));
		
        // Set the current input high
        if (input < 4) {
            PORTA |= (1 << (PORTA3 + (3 - input))); // Set inputs 0-3
        } else {
            PORTD |= (1 << (PORTD0 + (input - 4))); // Set inputs 4-7
        }

        delay_ms(20);

        // Read outputs
        outputs_PD = (PIND & IC_4532.output_mask_PD); 
        outputs_PA = (PINA & IC_4532.output_mask_PA);
		
		delay_ms(10);
        
        //Extract the relevant bits
        q0 = (outputs_PA >> PORTA7) & 0x01;
        q2 = (outputs_PD >> PORTD5) & 0x01;
        q1 = (outputs_PD >> PORTD6) & 0x01;

        // Combine the outputs
        combined_output = (q2 << 2) | (q1 << 1) | q0;
        
        //Calculate the expected output
        expected_output = input;

        // Check the outputs
        if (combined_output != expected_output) {
            return 0; // Test failed
        }
    }

    glcd_clear();
    glcd_drawCenteredStr("IC is 4532", LINES_DY * 2, 1);
    glcd_drawCenteredStr("DIP16 - CMOS", LINES_DY * 3, 1);
    return 1; // Test passed
}

unsigned char test_74157(void) {
	unsigned char select;
    unsigned char i;
    unsigned char input1, input2, expected_output;
    unsigned char output1, output2, output3, output4; 
	
	// Configure input pins as outputs (from MCU)
    DDRD |= IC_74157.input_mask_PD;
    DDRA |= IC_74157.input_mask_PA;

    // Configure output pins as inputs (from MCU)
    DDRD &= ~IC_74157.output_mask_PD;
    DDRA &= ~IC_74157.output_mask_PA;

	power_ic(IC_74157.package_type);
	
	// Enable the 74157
    PORTA &= ~(1 << PORTA1); // Enable low (PORTA1)
	PORTD &= ~(1 << PORTD0); // Select pin cleared
	
	for (select = 0; select <= 1; select++) {
        for (i = 0; i < 4; i++) {
			input1 = (i & 0x01); // LSB of inputs
			input2 = (i & 0x02) >> 1; // MSB of inputs
			
			// Set inputs for Mux 1 and Mux 2 on PORTD
			PORTD = (PORTD & ~IC_74157.input_mask_PD) | (input1 << PORTD1) | (input2 << PORTD2) | (input1 << PORTD4) | (input2 << PORTD5);

			// Set inputs for Mux 3 and Mux 4 on PORTA
			PORTA = (PORTA & ~IC_74157.input_mask_PA) | (input1 << PORTA2) | (input2 << PORTA3) | (input1 << PORTA5) | (input2 << PORTA6);
			
			// Set Select Pin 		
			PORTD |= (select << PORTD0);
			
			delay_ms(20);
			
			// Read outputs for all Muxs
			output1 = (PIND & (1 << PORTD3)) >> PORTD3; // Gate 1 output
			output2 = (PIND & (1 << PORTD6)) >> PORTD6; // Gate 2 output
			output3 = (PINA & (1 << PORTA7)) >> PORTA7; // Gate 3 output
			output4 = (PINA & (1 << PORTA4)) >> PORTA4; // Gate 4 output  
			
			delay_ms(10);
			
			// Verify Mux truth table
			expected_output = (select == 0) ? input1 : input2;
            if (output1 != expected_output) return 0;
            if (output2 != expected_output) return 0;
            if (output3 != expected_output) return 0;
            if (output4 != expected_output) return 0;
			
		}
    }
	
	glcd_clear();
    glcd_drawCenteredStr("IC is 74157", LINES_DY * 2, 1);
    glcd_drawCenteredStr("DIP16 - TTL", LINES_DY * 3, 1);
    return 1; // Test passed
}
	
	
unsigned char test_74156(void) {
	unsigned char address;
    unsigned char expected_output;
    unsigned char outputs_PD;
    unsigned char outputs_PA;
//	char str[12];
	
	// Configure input pins as outputs (from MCU)
    DDRD |= IC_74156.input_mask_PD;
    DDRA |= IC_74156.input_mask_PA;

    // Configure output pins as inputs (from MCU)
    DDRD &= ~IC_74156.output_mask_PD;
    DDRA &= ~IC_74156.output_mask_PA;
	
	// Enable pull-up for ouptuts
	PORTD |= IC_74156.output_mask_PD;
	PORTA |= IC_74156.output_mask_PA ;

	power_ic(IC_74156.package_type);
	
	// Enable the 74156
    PORTA &= ~(1 << PORTA2); 
	PORTD &= ~(1 << PORTD1); 
	
	// Test for all addresses
    for (address = 0; address <= 3; address++) {
		
		
        // Set address lines
        PORTD = (PORTD & ~IC_74156.input_mask_PD) | (((address & 0x02) >> 1) << PORTD2); // Address B
        PORTA = (PORTA & ~IC_74156.input_mask_PA) | ((address & 0x01) << PORTA3); // Address A
		
		
        // Test with input high
        PORTD |= (1 << PORTD0); // I1 high
        PORTA &= ~(1 << PORTA1); // I2 Low


        delay_ms(20);
		
        outputs_PD = (PIND & IC_74156.output_mask_PD) >> PORTD3;
        outputs_PA = (PINA & IC_74156.output_mask_PA) >> PORTA4;
		expected_output = (~(1 << address)) & 0x0F;
		
		outputs_PD = reverseBits(outputs_PD) >> 4;
		outputs_PA = reverseBits(outputs_PA) >> 4;
		
		
		// sprintf(str, "%d %d %d", expected_output, outputs_PD, outputs_PA);
		// glcd_drawCenteredStr(str, LINES_DY * 3, 1);
		
		delay_ms(10);
		
        
        if((outputs_PD != expected_output) || (outputs_PA != expected_output)) return 0;

        
    }
	
	glcd_clear();
    glcd_drawCenteredStr("IC is 74156", LINES_DY * 2, 1);
    glcd_drawCenteredStr("DIP16 - TTL", LINES_DY * 3, 1);
    return 1; // Test passed

}



unsigned char is_button_pressed(void) {
    // Read the button state
    if (!(PINB & (1 << TEST_BUTTON_PIN))) { // Active LOW
        delay_ms(50); // Debounce delay
        if (!(PINB & (1 << TEST_BUTTON_PIN))) {
            return 1; // Button is pressed
        }
    }
    return 0; // Button is not pressed
}


void clear_LEDs() {
	PORTC &= ~(1 << LED_PASS);
	PORTC &= ~(1 << LED_FAIL);
	
}

void clear_ports() {
	PORTA = 0;
	PORTD = 0;
}



void display_result(unsigned char result) {
    if (result) {
        PORTC |= (1 << LED_PASS); // Light up pass LED
        PORTC &= ~(1 << LED_FAIL); // Turn off fail LED
        // glcd_clear();   
		// glcd_drawCenteredStr("OK!!", LINES_DY * 2, 1);

        
    } else {
        PORTC |= (1 << LED_FAIL); // Light up fail LED
        PORTC &= ~(1 << LED_PASS); // Turn off pass LED   
        glcd_clear();
		glcd_drawCenteredStr("Unknown IC", LINES_DY * 2, 1);

    }
}


unsigned char reverseBits(unsigned char num)
{
    unsigned char count = sizeof(num) * 8 - 1;
    unsigned char reverse_num = num;

    num >>= 1;
    while (num) {
        reverse_num <<= 1;
        reverse_num |= num & 1;
        num >>= 1;
        count--;
    }
    reverse_num <<= count;
    return reverse_num;
}


void glcd_drawCenteredStr(const char *str, uint8_t y, uint8_t dx)
{
    // Calculate the length of the string
    uint8_t len = strlen(str);
    uint8_t x;
    uint8_t i = 0;

    // Calculate the starting X coordinate to center the string
    if (len <= 15)
    {
        x = (GLCD_LCD_WIDTH - len * 5 - (len - 1) * dx) / 2; // Center X position
    }
    else
    {
        x = 0; // Start at the beginning for long strings
    }


    // Loop through each character in the string
    while (len > 0)
    {
        char c = str[i++];
        if (!c)
        {
            return; // Exit loop if null terminator is reached
        }

        // Display the character using `glcd_putcharxy`
        glcd_putcharxy(x, y, c);

        // Update X coordinate for the next character
        x += 5 + dx; // Character width (5 pixels) + spacing

        // If X exceeds the screen width, move to the next line
        if (x > GLCD_LCD_WIDTH - 6)
        {
            x = 0;
            y += 10; // Move to the next line (font height + spacing)
        }

        len--; // Decrease remaining length
    }
}
