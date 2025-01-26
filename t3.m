function tsk3
    % Set parameters
    num_phtns = 1e5;  % Number of photons per source position
    m = 20;             % Number of intervals (sensors)
    g = 0.8;            % Anisotropy factor
    r = 1;         % r of the unit disk

    % Divide the unit circle into m intervals (sensor locations)
    theta_int = linspace(0, 2*pi, m + 1);
    theta_int = theta_int(1:end-1);  % Ignore the last point as it is the same as the first
    % Prepare matrix to store photon counts for each source position
    dm_o = zeros(m, m);
    dm_w = zeros(m, m);
    % Run simulation with the inclusion (Omega)
    for source_idx = 1:m
        source_theta = theta_int(source_idx);
        source_pst = r * [cos(source_theta), sin(source_theta)];
        exit_counts = simulate_photon_migration(source_pst, theta_int, num_phtns, r, g, true);
        dm_o(source_idx, :) = exit_counts;
    end
    % Run simulation without the inclusion (Omega)
    for source_idx = 1:m
        source_theta = theta_int(source_idx);
        source_pst = r * [cos(source_theta), sin(source_theta)];
        exit_counts = simulate_photon_migration(source_pst, theta_int, num_phtns, r, g, false);
        dm_w(source_idx, :) = exit_counts;
    end
  % Plot the data matrix with and without Omega
    figure;
    subplot(1, 2, 1);
    imagesc(dm_o);
    colorbar;
    title('Photon Exit Matrix With Inclusion (\Omega)');
    xlabel('Sensor Index');
    ylabel('Source Index');
    subplot(1, 2, 2);
    imagesc(dm_w);
    colorbar;
    title('Photon Exit Matrix Without Inclusion');
    xlabel('Sensor Index');
    ylabel('Source Index');
    figure;
    imagesc(dm_o - dm_w);
    colorbar;
    title('Difference Matrix: With Omega - Without Omega');
    xlabel('Sensor Index');
    ylabel('Source Index');
end

function exit_counts = simulate_photon_migration(source_pst, theta_int, num_phtns, r, g, include_omega)
    % Initialize exit counts for each interval
    m = length(theta_int);
    exit_counts = zeros(1, m);

    % Run the simulation for each photon
    for photon = 1:num_phtns
        % Initialize photon direction (towards the center)
        direction = -source_pst / norm(source_pst);

        % Simulate photon migration
        position = source_pst;
        absorbed = false;
        max_steps = 1000;

        for step = 1:max_steps
            % Determine if photon is in the inclusion (Omega)
            if include_omega && norm(position) < 0.5
                mu_a = 15;  % Absorption coefficient inside Omega
            else
                mu_a = 5;   % Absorption coefficient outside Omega
            end

            % Photon movement and possible absorption
            s = -log(rand()) / 10;  % Exponential distance with mean free path of 0.1
            nw_pst = position + s * direction;

            % Check if photon exits the disk
            if norm(nw_pst) >= r
                % Determine the sensor interval for the exit point
                exit_theta = atan2(nw_pst(2), nw_pst(1));
                if exit_theta < 0
                    exit_theta = exit_theta + 2 * pi;
                end
                [~, interval_idx] = min(abs(theta_int - exit_theta));
                exit_counts(interval_idx) = exit_counts(interval_idx) + 1;
                break;
            end

            % Decide if the photon is absorbed
            if rand() < mu_a / 10
                absorbed = true;
                break;
            end

            % Scatter the photon using Henyey-Greenstein
            direction = hen_grn(direction, g);
            position = nw_pst;
        end
    end
end
% Henyey-Greenstein scattering model
function new_direction = hen_grn(current_direction, g)
    xi = rand();  % Random number from uniform distribution [0,1]
    if g == 0
        cos_theta = 2 * xi - 1;  % Uniform scattering
    else
        cos_theta = (1 / (2 * g)) * (1 + g^2 - ((1 - g^2) / (1 + g * (2 * xi - 1)))^2);
    end
    phi = 2 * pi * rand();% Compute the azimuthal angle (phi) randomly in [0, 2*pi]

    % Convert to spherical coordinates
    theta = acos(cos_theta);
    new_dx = sin(theta) * cos(phi);
    new_dy = sin(theta) * sin(phi);
    new_direction = [new_dx, new_dy]; % New direction as a unit vector in 2D
end

