clear all;
close all;
maxScale = 30e-2;
accuracy = 1e-3;
grid = maxScale/accuracy; %tick = accuracy
A = 1;
V = 343.8;      % Speed of sound m/s
%micRelN = 2;    %Which microphone's phase is taken as zero


fs = 40e3;
f = 1e3;
T = 1 / f;
N = fs * T;

micY=1;
photoiter = 1
yposes = linspace(5,25,10);

%%for ypos = yposes

micPositions = [round(ypos) 11; 15 micY; 16 micY; 14 micY; 13 micY; 12 micY; 17 micY; 18 micY] .* 1e-2; % x1 y1; x2 y2 in cm
micPositionsOnGraph = round(micPositions./accuracy);
micNumber = size(micPositions, 1);
micPositions_Relative = micPositions(1, :) - micPositions;
distances = vecnorm(micPositions_Relative, 2, 2);
delays = distances ./ V; % These are the expected delays from the source
delaysRel = delays;
% time0Vector = (0:N-1) / fs;
% timeVectors = time0Vector + delays;
% timeVectors = timeVectors';

xx=linspace(0,maxScale,grid);
yy=linspace(0,maxScale,grid);
xiter=1;
yiter=1;
PhaseErrorSum=zeros([grid grid]);
w=2*pi*f;

expectedPhaseError=wrapTo2Pi(atan2(sin(w.*delaysRel(2:end)),cos(w.*delaysRel(2:end))));
for x=xx
    for y=yy
    micPositionstoXY_Relative = [x y] - micPositions;
    distanceXY = vecnorm(micPositionstoXY_Relative, 2, 2);
    delayXY = distanceXY./V;
    delaysRelXY = delayXY;
    
    PhaseError=expectedPhaseError-wrapTo2Pi(atan2(sin(w.*delaysRelXY(2:end)),cos(w.*delaysRelXY(2:end))));
    PhaseError=norm(PhaseError,2);
    PhaseErrorSum(xiter,yiter) = log10(sum((PhaseError)));
    yiter = yiter + 1;
    end
    yiter = 1;
    xiter = xiter + 1;
end
PhaseErrorSum=normalize(PhaseErrorSum);
PhaseErrorSum=1-PhaseErrorSum;
clf
imshow(abs(PhaseErrorSum)',[])
colorbar()
axis on;
hold on;
plot(micPositionsOnGraph(1,1),micPositionsOnGraph(1,2), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
plot(micPositionsOnGraph(2:end,1),micPositionsOnGraph(2:end,2), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
saveas(gcf,sprintf("figure%d.png",photoiter))
photoiter = photoiter + 1;
%%end

% PhaseErrorsAtDistances =

% % Generate signals
% s = A * sin(timeVectors * f * 2 * pi);
% figure;
% plot(time0Vector, s);
% title("Original signal");
% xlabel("Time (s)");
% ylabel("Amplitude");
% 
% S = fft(s, [], 1);
% plot_fft(S,fs)
% frequencies = (-N/2:N/2-1) * (fs / N);
% frequencies = ifftshift(frequencies);
% phase_shift = exp(1i * 2 * pi * frequencies .* delays);
% S_shifted = S .* phase_shift';
% 
% 
% % Perform inverse FFT to get the time-shifted signals
% s_shifted = ifft(S_shifted, [], 1);
% 
% % Plot the original and time-shifted signals
% figure;
% subplot(3, 1, 1);
% plot(time0Vector, s);
% title('Original Signals');
% xlabel('Time (s)');
% ylabel('Amplitude');
% 
% subplot(3, 1, 2);
% plot(time0Vector, real(s_shifted));
% title('Time-Shifted Signals (After Phase Compensation)');
% xlabel('Time (s)');
% ylabel('Amplitude');
% %compute_phase_delay(S',3);


