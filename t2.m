function pht_mig
    num_photons = 1000;  % Number of photons to simulate
    g = 0.8;            % Anisotropy factor
    radius = 1;         % Radius of the unit disk
    mu1_val = [5, 10, 15];  % Higher absorption in the lesion
    mu2_val = [2, 5, 8];    % Lower absorption outside the lesion
    all_ext_pt = [];
    all_ab_pt = [];
    all_b_p = {};  % Cell array for storing all photon paths reaching boundary

    % Simulate photon migration 
    for i = 1:length(mu1_val)
        mu_1 = mu1_val(i);
        for j = 1:length(mu2_val)
            mu_2 = mu2_val(j);

            ext_pt = [];
            ab_pt = [];
            b_p = {};  % Cell array to hold individual photon paths

            % Run simulation for each photon
            for photon = 1:num_photons
                [ext_pt, photon_path, absorbed] = simulate_single_photon(radius, mu_1, mu_2, g);
                
                % Store paths and points
                if absorbed
                    ab_pt = [ab_pt; photon_path(end, :)];
                else
                    ext_pt = [ext_pt; ext_pt];
                    b_p{end+1} = photon_path;  % Store full path if photon reached the boundary
                end
            end
            
            % Store for overall analysis
            all_ext_pt = [all_ext_pt; ext_pt];
            all_ab_pt = [all_ab_pt; ab_pt];
            all_b_p = [all_b_p; b_p'];  % Append using cell indexing to prevent size mismatch

            % Plot for current mu_1 and mu_2 combination
            figure;
            hold on;
            unt_crcl(radius);
            pth_pt(b_p, ext_pt, ab_pt);
            title(sprintf('Photon Migration with \\mu_1 = %d and \\mu_2 = %d', mu_1, mu_2));
            xlabel('x');
            ylabel('y');
           % legend({'Boundary (\delta D)', 'Photon Paths to Boundary', 'Exit Points', 'Absorbed Points'}, 'Location', 'best');
            hold off;
        end
    end

    % Plot absorbed photons
    figure;
    hold on;
    unt_crcl(radius);
    if ~isempty(all_ab_pt)
        scatter(all_ab_pt(:, 1), all_ab_pt(:, 2), 15, 'r', 'filled');
    end
    title('Absorbed Photons');
    xlabel('x');
    ylabel('y');
    legend({'Boundary (\delta D)', 'Absorption Points'}, 'Location', 'best');
    hold off;

    % Plot photons that reached the boundary
    figure;
    hold on;
    unt_crcl(radius);
    for k = 1:length(all_b_p)
        photon_path = all_b_p{k};
        plot(photon_path(:, 1), photon_path(:, 2), 'b-');
    end
    title('Photons Reaching Boundary (\delta D)');
    xlabel('x');
    ylabel('y');
    legend({'Boundary (\delta D)', 'Photon Paths to Boundary'}, 'Location', 'best');
    hold off;

    % Plot exit points of photons
    figure;
    hold on;
    unt_crcl(radius);
    if ~isempty(all_ext_pt)
        scatter(all_ext_pt(:, 1), all_ext_pt(:, 2), 15, 'b', 'filled');
    end
    title('Exit Points of Photons');
    xlabel('x');
    ylabel('y');
    legend({'Boundary (\delta D)', 'Exit Points'}, 'Location', 'best');
    hold off;

    % Plot Henyey-Greenstein distribution
    figure;
    plot_hen_grn_dist(g);
    title('Henyey-Greenstein Scattering Distribution');
    xlabel('Scattering Angle (cos(\theta))');
    ylabel('Probability Density');
end

function [ext_pt, photon_path, absorbed] = simulate_single_photon(radius, mu_1, mu_2, g)
    % Initialize photon position and direction
    theta = 2 * pi * rand();  % Random angle on the boundary
    position = radius * [cos(theta), sin(theta)];
    direction = -[cos(theta), sin(theta)];  % Initial direction inward

    % Store photon path for plotting
    photon_path = position;
    max_steps = 1000;  % Set a limit to prevent infinite loops

    for step = 1:max_steps
        % Determine if the photon is in the lesion or outside
        if norm(position) < 0.5  % Lesion is assumed to be a smaller circle with radius 0.5
            local_mu_a = mu_1;
        else
            local_mu_a = mu_2;
        end

        % Draw the distance traveled 's'
        s = -log(rand()) / 10;  % Exponential random variable (mean free path is 1/mu)

        % Update position
        nw_pst = position + s * direction;

        % Add new position to path
        photon_path = [photon_path; nw_pst];

        % Check if the photon exits the disk
        if norm(nw_pst) >= radius
            ext_pt = nw_pst;  % Save the exit point
            absorbed = false;
            return;
        end
        % Decide if the photon is absorbed
        if rand() < local_mu_a / 10
            ext_pt = [];
            absorbed = true;
            return;
        end
        % Scatter the photon, update direction using Henyey-Greenstein
        direction = hen_grn(direction, g);
        position = nw_pst;  % Update the position
    end

    % In case the photon does not exit or absorb within max_steps
    ext_pt = [];
    absorbed = true;
end

function new_direction = hen_grn(crnt_drctn, g)
    % Draw a new direction based on the Henyey-Greenstein scattering function
    xi = rand();  % Random number from uniform distribution [0,1]
    if g == 0
        cos_theta = 2 * xi - 1;  % Uniform scattering
    else
        cos_theta = (1 / (2 * g)) * (1 + g^2 - ((1 - g^2) / (1 + g * (2 * xi - 1)))^2);
    end
 phi = 2 * pi * rand(); % Compute the azimuthal angle (phi) randomly in [0, 2*pi]
theta = acos(cos_theta);% Convert to spherical coordinates

    % Compute new direction in spherical coordinates
    new_dx = sin(theta) * cos(phi);
    new_dy = sin(theta) * sin(phi);
 new_direction = [new_dx, new_dy];% New direction as a unit vector in 2D
end

function unt_crcl(radius)
    theta = linspace(0, 2 * pi, 100);
    plot(radius * cos(theta), radius * sin(theta), 'k--', 'LineWidth', 5);
    axis equal;
    xlim([-1.2, 1.2]);
    ylim([-1.2, 1.2]);
end
% Plot photon paths to the boundary, exit points, and absorption points
function pth_pt(b_p, ext_pt, ab_pt)
    for k = 1:length(b_p)
        photon_path = b_p{k};
        plot(photon_path(:, 1), photon_path(:, 2), 'b-');
    end
    if ~isempty(ext_pt)
        scatter(ext_pt(:, 1), ext_pt(:, 2), 15, 'b', 'filled');
    end
    if ~isempty(ab_pt)
        scatter(ab_pt(:, 1), ab_pt(:, 2), 15, 'r', 'filled');
    end
end

function plot_hen_grn_dist(g)
    % Plot the Henyey-Greenstein distribution
    cos_theta = linspace(-1, 1, 500);
    if g == 0
        H = 1/2 * ones(size(cos_theta));  % Uniform distribution for g = 0
    else
        H = (1 - g^2) ./ ((1 + g^2 - 2 * g * cos_theta).^1.5) / (2 * g);
    end
    plot(cos_theta, H, 'b-', 'LineWidth', 2);
end


