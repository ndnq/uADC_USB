clear all;
close all

V = 343.8; %speed of sound m/s
fs = 40e3;
f = 250;
T=1/f;
N = fs * T;

time0Vector=(0:N-1) / fs;
delay = 0.1/V

s=sin(time0Vector*f*2*pi)
sd=sin((time0Vector-delay)*f*2*pi)
hold on;
plot(s)
plot(sd)

S=fft(s)
Sd=fft(sd)


frequencies = (0:N-1) * (fs / N);
phase_shift = exp(1i * 2 * pi * frequencies.*delay);
S_shifted = S.*phase_shift;

plot(real(ifft(S_shifted)));

