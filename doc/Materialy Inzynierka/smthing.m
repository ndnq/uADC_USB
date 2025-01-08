clear all;
close all;

syms w0 t A dt w

s = A*sin(w0*(t-dt))
S = fourier(s,t,w)
phase = angle(S)
f = 1000
w=2*pi*f
t=linspace(0,1/f*10,10000);
A=1
m=sin(w*t);
s=sin(w*(t-1/f*0.75));
hold on;
plot(m)
plot(s)
figure;
hold on;
M = fft(m)
S = fft(s)
M(abs(M)<100) =0
S(abs(S)<100) =0
plot(fftshift(abs(M)))
plot(fftshift(abs(S)))

figure()
hold on;
%assume delay is always negative
angDelayed=fftshift(wrapTo2Pi(angle(S))*360/2/pi);
angNormal=fftshift(wrapTo2Pi(angle(M))*360/2/pi);

plot(angNormal)
plot(angDelayed)

