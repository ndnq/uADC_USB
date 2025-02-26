clear all;
close all;
maxScale = 30e-2;
accuracy = 5e-4;
grid = maxScale/accuracy; %tick = accuracy
A = 1;
V = 343.8;      % Speed of sound m/s
fs = 40e3;
f = 10e3;
T = 1 / f;
N = fs * T;

micY = 1;
photoiter = 1;
yposes = linspace(5, 25, 30);

for ypos = yposes
    micPositions = [ypos 11; 15 micY; 16 micY; 14 micY; 13 micY; 12 micY; 17 micY; 18 micY] .* 1e-2; % x1 y1; x2 y2 in cm
    micPositionsOnGraph = round(micPositions ./ accuracy);
    micNumber = size(micPositions, 1);
    micPositions_Relative = micPositions(1, :) - micPositions;
    distances = vecnorm(micPositions_Relative, 2, 2);
    delays = distances ./ V; % These are the expected delays from the source
    delaysRel = delays;

    xx = linspace(0, maxScale, grid);
    yy = linspace(0, maxScale, grid);
    xiter = 1;
    yiter = 1;
    PhaseErrorSum = zeros([grid grid]);
    w = 2 * pi * f;

    expectedPhaseError = wrapTo2Pi(atan2(sin(w .* delaysRel(2:end)), cos(w .* delaysRel(2:end))));
    for x = xx
        for y = yy
            micPositionstoXY_Relative = [x y] - micPositions;
            distanceXY = vecnorm(micPositionstoXY_Relative, 2, 2);
            delayXY = distanceXY ./ V;
            delaysRelXY = delayXY;

            PhaseError = expectedPhaseError - wrapTo2Pi(atan2(sin(w .* delaysRelXY(2:end)), cos(w .* delaysRelXY(2:end))));
            PhaseError = abs(PhaseError);
            PhaseErrorSum(xiter, yiter) = log10(sum((PhaseError)));
            yiter = yiter + 1;
        end
        yiter = 1;
        xiter = xiter + 1;
    end
    PhaseErrorSum = normalize(PhaseErrorSum);
    PhaseErrorSum = 1 - PhaseErrorSum;
    
    % Plotting the results
    figure()
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.2,0.8 , 0.8]);
    imshow(abs(PhaseErrorSum)', []);
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
    title(sprintf('Phase error at frequency %.1f Hz', f));
    xlabel('X Position (cm)');
    ylabel('Y Position (cm)');
    
    % Annotate with frequency
    text(10, 10, sprintf('Frequency: %.1f Hz', f), 'Color', 'white', 'FontSize', 12);
    
    % Adding legend
    legend('show', 'Location', 'eastoutside');
    
    % Plot an X at the position of maximum in PhaseErrorSum
    [maxValue, maxIndex] = max(PhaseErrorSum(:));
    [maxRow, maxCol] = ind2sub(size(PhaseErrorSum), maxIndex);
    plot(maxRow, maxCol, 'bx', 'MarkerSize', 15, 'LineWidth', 2, 'DisplayName', 'Minimum Phase Error');
    
    saveas(gcf, sprintf("figure%d.png", photoiter));
    photoiter = photoiter + 1;
end
