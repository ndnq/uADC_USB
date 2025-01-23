import serial
import matplotlib.pyplot as plt
import numpy as np
import time
import sounddevice as sd
import struct

def read_and_plot_samples(com_port, num_samples):
    # Open the serial port
    ser = serial.Serial(com_port, baudrate=115200)
    
    t0 = time.time()
    # Read a chunk of data from the serial port
    data = ser.read(num_samples * 2)  # Each sample is 2 bytes (16 bits)
    
    dt = time.time()
    elapsed_time = dt - t0
    total_samples = len(data) // 2
    print(f"Time passed: {elapsed_time:.3f} seconds")
    print(f"Total sample rate: {total_samples / elapsed_time:.1f} Hz")
    print(f"Per-channel sample rate: {(total_samples / 8) / elapsed_time:.1f} Hz")
    
    # Unpack the data as big-endian unsigned shorts (16 bits)
    decoded_values = struct.unpack('>' + 'H' * (len(data) // 2), data)
    
    ser.close()
    
    # Convert to numpy array and truncate to multiple of 8 for de-interleaving
    data_int = np.array(decoded_values, dtype=np.uint16)  # Use uint16 to handle raw bits
    truncate_length = (len(data_int) // 8) * 8
    data_int = data_int[:truncate_length]
    
    # De-interleave into 8 channels (each row is a channel)
    channels = data_int.reshape((-1, 8)).T
    
    # Select the first channel for demonstration
    selected_channel = channels[1]
    
    # If necessary, convert 12-bit data (assuming it's stored in the lower 12 bits)
    # selected_channel = selected_channel & 0x0FFF  # Uncomment if 12-bit masking is needed
    
    # Convert to int16 for audio playback (adjust if using 12-bit signed data)
    selected_channel_int16 = selected_channel.astype(np.int16)
    
    # Play the selected channel at its correct sample rate (total / 8)
    sample_rate_per_channel = int(total_samples / elapsed_time / 8)
    print(f"Playing audio at {sample_rate_per_channel} Hz")
    sd.play(selected_channel_int16, samplerate=sample_rate_per_channel)
    
    # Plot the selected channel
    #plt.plot(selected_channel_int16)
    plt.figure()
    plt.plot(channels[0].astype(np.uint16))
    plt.figure()
    plt.plot(channels[1].astype(np.uint16))
    plt.figure()
    plt.plot(channels[2].astype(np.uint16))
    plt.figure()
    plt.plot(channels[3].astype(np.uint16))

    plt.title("ADC Data Samples (Channel 0)")
    plt.xlabel("Sample Index")
    plt.ylabel("ADC Value")
    plt.show()

if __name__ == "__main__":
    com_port = "COM4"  # Change to your COM port
    num_samples = 20000 * 5*8  # Total samples to collect (for all channels)
    read_and_plot_samples(com_port, num_samples)