clear all;
close all;

% Constants
vs = 34300; % Speed of sound (cm/s)
f = 2000;
omega = f * 2 * pi; % Frequency (rad/s)

% Grid size (physical dimensions)
si = 50; % Size of grid in cm
grid_points = 50; % Number of grid points
x = linspace(-si/2, si/2, grid_points); % x-coordinates
y = linspace(0, si, grid_points); % y-coordinates
[X, Y] = meshgrid(x, y); % Create a 2D grid

% Source and microphone positions
mic_spacing = [1 2 3 4 5 6];
rn = [-13.72 0; -10.29 0; -6.86 0; -1 0; 0 0; 1 0; 6.86 0; 10.29 0; 13.72 0]; % Microphone positions (cm)

% Initialize parameters for sweeping
focus_y = 5; % Fixed y-coordinate for the focus point
focus_x_range = linspace(-si/2, si/2, 3); % Sweep x-coordinate of focus point
num_sweeps = length(focus_x_range);

% Choose a specific y distance to plot (in cm)
specific_y = 15; % Example y distance
[~, y_idx] = min(abs(y - specific_y)); % Find the closest y index to the specified distance

% Loop through each focus point and generate separate figures
for sweep_idx = 1:num_sweeps
    % Current focal point
    rf = [focus_x_range(sweep_idx), focus_y]; 

    % Initialize directivity matrix
    D = zeros(grid_points, grid_points);

    % Calculate directivity for the current focal point
    for n = 1:size(rn, 1)
        dist_focus_to_mic = vecnorm(rf - rn(n,:), 2, 2); % Focus to mic
        for i = 1:grid_points
            for j = 1:grid_points
                grid_point = [X(i, j), Y(i, j)];
                dist_point_to_mic = vecnorm(grid_point - rn(n,:), 2, 2); % Grid to mic
                D(i, j) = D(i, j) + exp(-1j * omega * dist_point_to_mic / vs) ...
                                    .* exp(1j * omega * dist_focus_to_mic / vs)./size(rn, 1);
            end
        end
    end

    % Normalize and take the real part
    D = 1 + real(D);
    D = D ./ 2;
    D = abs(D);

    % Extract the slice of D at the specified y distance
    D_slice = D(y_idx, :);

    % Plot the 1D response
    figure;
    plot(x, D_slice, 'b-', 'LineWidth', 1.5);
    hold on;

    % Mark the maximum value
    [max_value, max_idx] = max(D_slice); 
    plot(x(max_idx), max_value, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5); % Red circle for max value

    % Labels and title
    title(['Directivity at Y = ', num2str(specific_y), ' cm (Focus X: ', num2str(rf(1)), ' cm)']);
    xlabel('X [cm]');
    ylabel('Amplitude');
    grid on;

    % Plot microphone positions
    scatter(rn(:,1), zeros(size(rn,1), 1), 75, 'rx', 'DisplayName', 'Microphones'); % Microphones in red
    legend show;
end
