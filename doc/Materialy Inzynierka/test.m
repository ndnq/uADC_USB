% Parameters
clear all;
close all;
V = 343.8; % Speed of sound m/s
d = 0.1;   % Distance in meters
dt = d / V; % Time delay due to distance
fs = 40e3; % Sampling frequency
f = 250;   % Frequency of the sinusoidal signal

T = 1 / f; % Period of the signal
N = fs * T; % Number of samples
t = (0:N-1) / fs; % Time vector

% Original signal
x = sin(2 * pi * f * t);

% Shift the signal by dt
time_shift = dt;
x_shifted = sin(2 * pi * f * (t - time_shift));

% FFT of the shifted signal
X_shifted = fft(x_shifted);

% Frequency vector (centered around zero)
frequencies = (-N/2:N/2-1) * (fs / N);

% Apply phase shift in the frequency domain
phase_shift = exp(1i * 2 * pi * frequencies * time_shift);
phase_shift = ifftshift(phase_shift); % Center phase shift to match fftshift

% Compensate phase shift
X_compensated = X_shifted .* phase_shift;

% Inverse FFT to get the compensated signal
x_compensated = ifft(X_compensated);

% Plot the original and compensated signals
figure;
subplot(3, 1, 1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, x_shifted);
title('Shifted Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(t, real(x_compensated));
title('Compensated Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Compare the original and compensated signals
max_error = max(abs(x - real(x_compensated)));
disp(['Maximum error between original and compensated signal: ', num2str(max_error)]);
