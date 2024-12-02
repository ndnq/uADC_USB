import serial
import matplotlib.pyplot as plt
import numpy as np
import time
import sounddevice as sd

def read_and_plot_samples(com_port, num_samples, buffer_size=1024):
    # Open the serial port
    ser = serial.Serial(com_port, baudrate=115200)
    
    t0 = time.time()
    # Read a chunk of data from the serial port
    data = ser.read(num_samples)
    
    dt = time.time()
    print(f"Time passed {dt-t0} , samplerate :{num_samples/(dt-t0)}")
    
    ser.close()
    data_int = np.frombuffer(data, dtype=np.uint8)
    sd.play(data_int,samplerate=40000)
    # Plot the samples
    plt.plot(data_int)
    plt.title("ADC Data Samples")
    plt.xlabel("Sample Index")
    plt.ylabel("ADC Value")
    plt.show()

if __name__ == "__main__":
    com_port = "COM4"  # Example COM port, change as needed
    num_samples = 40000*5  # Example number of samples to collect
    read_and_plot_samples(com_port, num_samples)