import serial
import time
import matplotlib.pyplot as plt
import numpy as np
import sounddevice as sd

def read_and_plot_serial_data(port, baudrate, N):
    # Open the serial port
    ser = serial.Serial(port, baudrate)
    
    # Prepare to store data and timestamps
    data = []
    timestamps = []
    
    # Start the timer
    start_time = time.time()
    
    # Read N lines from the serial port
    for _ in range(N):
        line = ser.readline()
        line = line.replace(b'\x00', b'')  
        line = line.decode('utf-8').strip()  # Read a line and decode it to string
        try:
            
            value = int(line)  # Assuming the values are integers like 1234
            data.append(value)
        except ValueError:
            print(f"Skipping invalid data: {line}, {line.encode("ascii")}")
    
    # Stop the timer
    end_time = time.time()
    elapsed_time = end_time - start_time
    
    # Close the serial port
    ser.close()
    
    # Plot the data
    data = np.asarray(data, dtype=np.int16)
    data = np.clip(data, 0, 4095)  # Assuming 12-bit data (0-4095)
    sd.play(data, samplerate=44100)  # Play at a 44.1kHz sample rate
    plt.plot(data)
    plt.xlabel('Time (seconds)')
    plt.ylabel('Value')
    plt.title(f'Serial Data over Time ({N} readings)')
    plt.grid(True)
    plt.show()
    # Return the elapsed time
    return elapsed_time

# Example usage
port = 'COM4'  # Change to your serial port
baudrate = 1000000  # Change to your baudrate
N = 40000  # Number of lines to read

elapsed_time = read_and_plot_serial_data(port, baudrate, N)

print(f"Time taken to read {N} lines: {elapsed_time:.4f} seconds, rate: {N/elapsed_time}")
