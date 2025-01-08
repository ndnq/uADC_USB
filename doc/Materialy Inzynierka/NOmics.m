clear all;
close all;

% Constants
vs = 34300; % Speed of sound (cm/s)
omega = 5000 * 2 * pi; % Frequency (rad/s)

% Grid size (physical dimensions)
si = 50; % Size of grid in cm
grid_points = 50; % Number of grid points
x = linspace(-si/2, si/2, grid_points); % x-coordinates
y = linspace(0, si, grid_points); % y-coordinates
[X, Y] = meshgrid(x, y); % Create a 2D grid

No_mics = [2 3 7 15 21]

%mic_spacing = [1 2 3 4 5 6]
rn_t = [-4 0; -3 0; -2 0; -1 0; 0 0; 1 0; 2 0; 3 0;4 0]; % Microphone positions (cm)

% Initialize parameters for sweeping
focus_y = 20; % Fixed y-coordinate for the focus point
focus_x_range = linspace(-si/2, si/2, 3); % Sweep x-coordinate of focus point
num_sweeps = length(No_mics);



% Loop through each focus point and generate separate figures
for sweep_idx = 1:num_sweeps
    % Current focal point
    %rf = [focus_x_range(sweep_idx), focus_y]; 
     rf = [0, focus_y];
    % Initialize directivity matrix
    D = zeros(grid_points, grid_points);
    rn_x = linspace(-15,15,No_mics(sweep_idx))
    rn = zeros(No_mics(sweep_idx),2)
    rn(:,1) = rn_x;
    rn(:,2) = 0;
    % Calculate directivity for the current focal point
    for n = 1:size(rn, 1)
        dist_focus_to_mic = vecnorm(rf - rn(n,:), 2, 2); % Focus to mic
        for i = 1:grid_points
            for j = 1:grid_points
                grid_point = [X(i, j), Y(i, j)];
                dist_point_to_mic = vecnorm(grid_point - rn(n,:), 2, 2); % Grid to mic
                D(i, j) = D(i, j) + exp(-1j * omega * dist_point_to_mic / vs) ...
                                    .* exp(1j * omega * dist_focus_to_mic / vs)./size(rn,1);
            end
        end
    end
    clims = [0 1];
    % Plot directivity before making real
  % figure;
  % imagesc(x, y, abs(D),clims); % Plot the magnitude of directivity
  % colormap('gray')
  % %imagesc(x, y, abs(D))
  % colorbar;
  % title(['Kierunkowość (Focus X: ', num2str(rf(1)), ' cm)']);
  % xlabel('X (cm)');
  % ylabel('Y (cm)');
  % axis equal;
  % hold on;
%
  % % Plot microphone positions
  % scatter(rn(:,1), rn(:,2), 75, 'rx'); % Microphones in red
%
  % % Plot focal point
  % scatter(rf(1), rf(2), 75, 'ko'); % Focal point in blue
  % file_name_complex = sprintf('directivity_complex_focus_x_%d.stl', rf(1));
  % %save_stl_mesh(X, Y, abs(D), file_name_complex);
  % % Make D real
  
  % % Save directivity after making real
  % file_name_real = sprintf('directivity_real_focus_x_%d.stl', rf(1));
  % %save_stl_mesh(X, Y, abs(D), file_name_real);
  % % Plot directivity after making real
    D = real(D);
    figure;
    imagesc(x, y, abs(D),clims); % Plot the magnitude of directivity
    %imagesc(x, y, abs(D))
    colormap('gray')
    colorbar;
    title(['Kierunkowość (Focus X: ', num2str(rf(1)), ' cm)']);
    xlabel('X (cm)');
    ylabel('Y (cm)');
    axis equal;
    hold on;

    % Plot microphone positions
    scatter(rn(:,1), rn(:,2), 75, 'rx'); % Microphones in red

    % Plot focal point
    scatter(rf(1), rf(2), 75, 'ko'); % Focal point in blue
end

% Function to save a mesh as an STL file
function save_stl_mesh(X, Y, Z, file_name)
    % Create the triangulation object
    tri = delaunay(X, Y);  % Perform Delaunay triangulation
    vertices = [X(:), Y(:), Z(:)];  % Create vertices matrix

    % Create the triangulation object
    triang = triangulation(tri, vertices);

    % Write the triangulation to an STL file
    stlwrite(triang,file_name);
end