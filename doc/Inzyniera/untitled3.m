clear all;
close all;
A = 1;
V = 343.8; % Speed of sound m/s
micPositions = [15 10; 15 8; 15 5; 15 2] .* 1e-2; % x1 y1; x2 y2 in cm
fs = 40e3;
f = 250;
T = 1 / f;
N = fs * T;

micNumber = size(micPositions, 1);
micPositions_Relative = micPositions(1, :) - micPositions;
distances = vecnorm(micPositions_Relative, 2, 2);
delays = distances / V; % These are the expected delays
time0Vector = (0:N-1) / fs;
timeVectors = time0Vector + delays;
timeVectors = timeVectors';

% Generate signals
s = A * sin(timeVectors * f * 2 * pi);
figure;
plot(time0Vector, s);
title("Original signal");
xlabel("Time (s)");
ylabel("Amplitude");

% Compute FFT of the signals
S = fft(s, [], 1);

% Frequency vector (centered around zero)
frequencies = (-N/2:N/2-1) * (fs / N);

% Compute phase shift matrix
%[~, freqs_grid] = meshgrid(delays, frequencies);
freqs_grid=delays.*frequencies;
phase_shift = exp(1i * 2 * pi * freqs_grid);

% Apply phase shift to the FFT of the signals
S_shifted = S .* ifftshift(phase_shift)';

% Perform inverse FFT to get the time-shifted signals
s_shifted = ifft(S_shifted, [], 1);

% Plot the original and time-shifted signals
figure;
subplot(3, 1, 1);
plot(time0Vector, s);
title('Original Signals');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(time0Vector, real(s_shifted));
title('Time-Shifted Signals (After Phase Compensation)');
xlabel('Time (s)');
ylabel('Amplitude');

% Compare the original and compensated signals
max_error = max(max(abs(s - real(s_shifted))));
disp(['Maximum error between original and compensated signal: ', num2str(max_error)]);
