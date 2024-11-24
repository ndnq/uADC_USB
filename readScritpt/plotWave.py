import numpy as np
import matplotlib.pyplot as plt
import serial
import time

def plot_channel(com_port: str, num_values: int,chan = 0):
    """
    Open a serial port and plot the first `num_values` values of channel 1.
    
    Parameters:
        com_port (str): The COM port to connect to (e.g., "COM3").
        baud_rate (int): The baud rate for the serial connection.
        num_values (int): The number of values to plot from channel 1.
    """
    # Initialize the serial connection
    try:
        ser = serial.Serial(com_port, 12000000, timeout=1)
        print(f"Connected to {com_port} at 12000000 baud.")
    except serial.SerialException as e:
        print(f"Error opening serial port: {e}")
        return
    
    # Buffer to store channel 1 values
    channel_values = []
    t0 = 1
    try:
        while len(channel_values) < num_values:
            # Read a line from the serial port
            
            line = ser.readline().decode('utf-8').strip()
            #print(f"Received: {line}")  # Debug: Print the received line
            dt = time.time()-t0
            #print(f"freq = {1/dt}")
            # Parse the line if it matches the expected format5
            try:
                # Split the line into channel and value components
                channel, value = line.split(":")
                value = int(value.strip())/4095*3.3       # Extract value
                # Store the value if it's from channel 1
                channel_values.append(value)
            except (ValueError, IndexError) as parse_error:
                print(f"Failed to parse line: {line} ({parse_error})")
        t0 = time.time()
    
    except KeyboardInterrupt:
        print("Interrupted by user.")
    
    finally:
        # Close the serial connection
        ser.close()
        print("Serial port closed.")
    
    # Plot the collected values from channel 1
    if channel_values:
        channel_values = channel_values 
        
        plt.plot(channel_values, marker='o', label='Channel 1')
        plt.ylim((0,3.3))
        plt.title(f'Channel {chan} Data')
        plt.xlabel('Sample Index')
        plt.ylabel('Value [V]')
        plt.legend()
        plt.grid(True)
        plt.show()
    else:
        print("No data received for Channel 1.")    

# Example usage
plot_channel("COM4", 20, 0)  # Adjust COM port and baud rate as needed
