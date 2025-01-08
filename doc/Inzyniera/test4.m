clear all;
close all;
A = 1;
V = 343.8; % Speed of sound m/s
micRelN = 2; %Which microphone's phase is taken as zero
micPositions = [15 10; 15 8; 15 5; 15 2] .* 1e-2; % x1 y1; x2 y2 in cm
fs = 40e3;
f = 250;
T = 1 / f;
N = fs * T;

micNumber = size(micPositions, 1);
micPositions_Relative = micPositions(1, :) - micPositions;
distances = vecnorm(micPositions_Relative, 2, 2);
delays = distances / V; % These are the expected delays from the source
delaysRel = delays-delays(micRelN);
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

S = fft(s, [], 1);
plot_fft(S,fs)
frequencies = (-N/2:N/2-1) * (fs / N);
frequencies = ifftshift(frequencies);
phase_shift = exp(1i * 2 * pi * frequencies .* delays);
S_shifted = S .* phase_shift';


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
compute_phase_delay(S',3);

function phase_diff = compute_phase_delay(ffts, ref_index)
    % COMPUTE_PHASE_DELAY Computes the phase delay of each FFT relative to a specific FFT
    %
    % phase_delays = COMPUTE_PHASE_DELAY(ffts, ref_index)
    %
    % Inputs:
    %   ffts       - Array of FFTs (each row is an FFT)
    %   ref_index  - Index of the reference FFT (1-based index)
    %
    % Outputs:
    %   phase_delays - Array of phase delays (each row is the phase delay for corresponding FFT)
    
    % Get the reference FFT
    ffts(abs(ffts) < 1e-14) = 0;
    
    % Number of FFTs
    num_ffts = size(ffts, 1);
    len_ffts = size(ffts, 2);
    phase_diff = angle(ffts) - angle(ffts(ref_index, :));
    phase_diff = phase_diff(:,1:len_ffts/2-1);
    [somthing indices]= max(abs(phase_diff'));
    outdices=(1:1:num_ffts);
    phase_diff = phase_diff(sub2ind(size(phase_diff), outdices,indices ))%KYS
    
    
end
