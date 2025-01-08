clear all;
close all;
A=1
V = 343.8; %speed of sound m/s
micPositions = [15 10; 15 8;15 5;15 2].*1e-2           % x1 y1; x2 y2 in cm
fs = 40e3;
f = 250;
T=1/f;
N = fs * T;

micNumber = size(micPositions);
micNumber = micNumber(1);
micPositions_Relative = micPositions(1,:)-micPositions;
distances = vecnorm(micPositions_Relative,2,2);
delays = distances./V;                              %These are the expected
time0Vector=(0:N-1) / fs;
timeVectors= time0Vector-delays
timeVectors=timeVectors';
s=A*sin(timeVectors*f*2*pi)
plot(s)
title("Original signal")
figure()
% %
S=fft(s,[],1);
plot(ifft(S))
title("Ifft of original spectrum")

frequencies = (-N/2:N/2-1) * (fs / N);
delsTimeFreq=frequencies .*delays;
phase_shift = exp(-1i * 2 * pi * delsTimeFreq);
phase_shift = ifftshift(phase_shift);
S_shifted = S.*phase_shift';
figure()
plot(real(ifft(S_shifted)))
title("After shifting")

