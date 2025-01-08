clear all;
close all;
maxScale = 30e-2;
accuracy = 1e-3;
grid = maxScale/accuracy; %tick = accuracy
A = 1;
V = 343.8;      % Speed of sound m/s

f = 1000;
T = 1 / f;
timeDomainAccuracy = 50e-6;


photoiter = 1
xposes = linspace(5,25,10);
xpos = 12;

micY=1;
frequencies=[50 250 1000 5000 10000 20000]
for f = frequencies

for xpos = xposes

micPositions = [round(xpos) 11; 15 micY; 14 micY; 8 micY; 16 micY; 22 micY] .* 1e-2; % x1 y1; x2 y2 in cm
micPositionsOnGraph = round(micPositions./accuracy);
micNumber = size(micPositions, 1);
micPositions_Relative = micPositions(1, :) - micPositions(2:end,:);
distances = vecnorm(micPositions_Relative, 2, 2);
delays = distances ./ V; % These are the expected delays from the source

xx=linspace(0,maxScale,grid);
yy=linspace(0,maxScale,grid);
xiter=1;
yiter=1;
PhaseErrorSum=zeros([grid grid]);
w=2*pi*f;
deltaPhi = delays .* w;
for x=xx
    for y=yy
    micPositionstoXY_Relative = [x y] - micPositions(2:end,:);
    distanceXY = vecnorm(micPositionstoXY_Relative, 2, 2);
    delayXY = distanceXY./V;
    %Kwantyzacja
    %delayXY=round(delayXY/timeDomainAccuracy)*timeDomainAccuracy;
    %Dodanie szumu fazowego
    stddev = 10e-6;
    noise = stddev*randn(size(delayXY));
    delayXY = delayXY+noise;
    deltaPhiXY = delayXY.*w;

    Q=exp(j*deltaPhi).*exp(-j*deltaPhiXY);
    PhaseErrorSum(xiter,yiter) = real(sum(Q));
    yiter = yiter + 1;
    end
    yiter = 1;
    xiter = xiter + 1;
end
  % Plotting the results
    %figure('visible','off')
    figure()
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.2,0.8 , 0.8]);
    imshow((exp(PhaseErrorSum))', []);
xticks = linspace(0, grid-1, 11); % 11 ticks from 0 to grid-1
yticks = linspace(0, grid-1, 11);
xticklabels = linspace(0, maxScale*100, 11); % Convert to cm
yticklabels = linspace(0, maxScale*100, 11);

set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels);
    colorbar();
    axis on;
    hold on;
    
    % Plot microphones
    plot(micPositionsOnGraph(1,1), micPositionsOnGraph(1,2), 'r+', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Source');
    plot(micPositionsOnGraph(2:end,1), micPositionsOnGraph(2:end,2), 'g+', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Microphones');
    
    % Add title and labels
    title(sprintf('Phase alignment at frequency %.1f Hz', f));
    xlabel('X Position (cm)');
    ylabel('Y Position (cm)');
    
    % Annotate with frequency
    text(10, 10, sprintf('Frequency: %.1f Hz', f), 'Color', 'red', 'FontSize', 12);
    
    % Adding legend
    legend('show', 'Location', 'eastoutside');
    
    % Plot an X at the position of maximum in PhaseErrorSum
    [maxValue, maxIndex] = max(PhaseErrorSum(:));
    [maxRow, maxCol] = ind2sub(size(PhaseErrorSum), maxIndex);
    plot(maxRow, maxCol, 'bx', 'MarkerSize', 15, 'LineWidth', 2, 'DisplayName', 'Maximum Phase Alignment');
    
    saveas(gcf, sprintf("Alignment%d_%dHz_test.png", photoiter,f));
    photoiter = photoiter + 1;
end
photoiter = 0;
end

