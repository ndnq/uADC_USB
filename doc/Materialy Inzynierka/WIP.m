clear all;
close all;
vs = 34300 %cm/s
source_real = [2 1]%cm
mics = [-1 0; 0 0; 1 0]%cm
delta_dist = vecnorm(source_real-mics,2,2)
delta_t = delta_dist./vs %s

A0 = 1
freq = 1000
samples = 10000
sampleFreq = 40000 %samples/s
times=linspace(0,samples*.1./sampleFreq,samples)
sumS = zeros(1,length(times));
sumSS = zeros(1,length(times));
fig1 = figure;
fig2 = figure;

for n = 1:length(mics)
    s = A0./(4*pi*delta_dist(n)).*sin(2*pi*freq*(times-delta_t(n)))
    S = fft(s)./length(times)
    SS = S.*exp(-j.*delta_t(n).*freq)
    figure(fig1); % Activate the first figure
    hold on
    plot(fftshift(abs(S)))
    figure(fig2); % Activate the second figure
    hold on
    plot(fftshift(angle(S)))
    sumS = sumS + S;
    sumSS = sumSS + s;
    %plot(times,s)
end
%sumS = sumS ./ length(mics)
%figure
%hold on
%plot(fftshift(abs(sumS)))
%plot(fftshift(abs(sumSS)))



