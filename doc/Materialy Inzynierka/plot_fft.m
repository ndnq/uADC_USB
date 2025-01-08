function plot_fft(fft_signal, fs)
    % PLOT_FFT Plots the magnitude and phase of an FFT
    %
    % plot_fft(fft_signal, fs)
    %
    % Inputs:
    %   fft_signal  - The FFT of the signal
    %   fs          - Sampling frequency

    % Compute the frequency vector
    fft_signal(abs(fft_signal) < 1e-14) = 0;
    N = length(fft_signal);
    frequencies = (-N/2:N/2-1) * (fs / N);

    % Plot magnitude
    figure;
    subplot(2, 1, 1);
    plot(frequencies, abs(fftshift(fft_signal)));
    title('Magnitude of FFT');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');

    % Plot phase
    subplot(2, 1, 2);
    plot(frequencies, angle(fftshift(fft_signal)));
    title('Phase of FFT');
    xlabel('Frequency (Hz)');
    ylabel('Phase (radians)');
end

