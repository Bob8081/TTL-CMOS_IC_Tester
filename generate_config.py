def map_pins(package_type):
    pin_map = {}

    if package_type == "DIP14":
        # Pins 1-7 map to PORTD0 to PORTD6
        for i in range(1, 8):
            pin_map[i] = ("D", i - 1)  # PORTD(i-1)
        
        # Pins 8-14 map to PORTA6 to PORTA0 (reversed order)
        for i in range(8, 15):
            pin_map[i] = ("A", 14 - i)  # PORTA(14-i)

    elif package_type == "DIP16":
        # Pins 1-8 map to PORTD0 to PORTD7
        for i in range(1, 9):
            pin_map[i] = ("D", i - 1)  # PORTD(i-1)
        
        # Pins 8-16 map to PORTA7 to PORTA0 (reversed order)
        for i in range(9, 17):
            pin_map[i] = ("A", 16 - i)  # PORTA(16-i)

    else:
        raise ValueError("Unsupported package type. Only DIP14 and DIP16 are supported.")

    return pin_map


def generate_ic_config(name, package_type, input_pins, output_pins):

    # Get the pin map for the given package type
    pin_map = map_pins(package_type)

    # Helper function to map pin numbers to port and bit
    def map_pin_list(pin_list):
        return [pin_map[pin] for pin in pin_list]

    # Map input and output pins to their respective ports and bits
    input_pins_mapped = map_pin_list(input_pins)
    output_pins_mapped = map_pin_list(output_pins)

    # Helper function to generate port mask
    def generate_port_mask(pins, port_letter):
        return " | ".join([f"(1 << PORT{port_letter}{pin[1]})" for pin in pins if pin[0] == port_letter])

    # Separate input and output pins by port (D, A, etc.)
    input_mask_PD = generate_port_mask(input_pins_mapped, 'D')
    input_mask_PA = generate_port_mask(input_pins_mapped, 'A')
    output_mask_PD = generate_port_mask(output_pins_mapped, 'D')
    output_mask_PA = generate_port_mask(output_pins_mapped, 'A')

    # Generate configuration string
    config = f"""{{ // IC {name}
    .input_mask_PD = {input_mask_PD if input_mask_PD else 0}, // Inputs on PORTD
    .input_mask_PA = {input_mask_PA if input_mask_PA else 0}, // Inputs on PORTA
    .output_mask_PD = {output_mask_PD if output_mask_PD else 0}, // Outputs on PORTD
    .output_mask_PA = {output_mask_PA if output_mask_PA else 0}, // Outputs on PORTA
    .package_type = {package_type},
    .test_function = test_{name}
    }}"""
    
    return config


# Main function
if __name__ == "__main__":
    ic_name = input("Enter IC name (e.g., 4532): ").strip()
    package_type = input("Enter package type (e.g., DIP14 or DIP16): ").strip()

    # Input pin numbers
    input_pins = input("Enter input pin numbers (comma-separated, e.g., 1,2,3,4): ")
    input_pins = [int(pin.strip()) for pin in input_pins.split(",")]

    # Output pin numbers
    output_pins = input("Enter output pin numbers (comma-separated, e.g., 5,6,7): ")
    output_pins = [int(pin.strip()) for pin in output_pins.split(",")]

    # Generate configuration
    try:
        config = generate_ic_config(ic_name, package_type, input_pins, output_pins)
        print("\nGenerated IC Configuration:\n")
        print(config)
    except ValueError as e:
        print(f"Error: {e}")
