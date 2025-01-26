mu = 10; % Combined absorption and scattering coefficient
lambda = 1 / mu; % Mean free path
x0 = 0.5; % Position of the inclusion center
r = 0.2; % Radius of the inclusion
mu1 = 3; % Absorption coefficient inside inclusion
mu2 = 1; % Absorption coefficient outside inclusion
x_s = [1, 0]; % Source position on the boundary
rcv_int = [0.8, 0.9]; % Interval representing the receiver position
num_photons = 1000;% Number of photons to simulate
sctr_pt = [];% Arrays to store photon scattering points that reach the receiver
% Run the simulation for each photon
for photon_idx = 1:num_photons
    pc = x_s;
    vc = -x_s / norm(x_s); % Unit normal direction towards the interior
    absorbed = false;
    phtn_pth = [];
    while ~absorbed
        % Draw random step length s from exponential distribution
        s = -log(rand) / mu;
        pc = pc + s * vc;
        phtn_pth = [phtn_pth; pc];
        
        % Check if photon reaches the receiver interval
        if pc(1) >= rcv_int(1) && pc(1) <= rcv_int(2) && abs(pc(2)) < 0.1
            sctr_pt = [sctr_pt; phtn_pth]; 
            break;
        end    
        % Decide whether scattering or absorption occurs
        if rand < mu1 / mu
            absorbed = true; 
        else
            theta = 2 * pi * rand;% Update direction
            vc = [cos(theta), sin(theta)];
        end
    end
end
figure;
scatter(sctr_pt(:, 1), sctr_pt(:, 2), 10, 'filled');
xlabel('x_1');
ylabel('x_2');
title('Distribution of Scattering Points for Photons Reaching the Selected Receiver');
axis equal;
grid on;
figure;
hold on;
for photon_idx = 1:num_photons
    pc = x_s;
    vc = -x_s / norm(x_s);
    phtn_pth = [];
    absorbed = false;
    while ~absorbed
        s = -log(rand) / mu;% Draw random step length s from exponential distribution
        pc = pc + s * vc;
        phtn_pth = [phtn_pth; pc];
        % Check if photon reaches the receiver interval
        if pc(1) >= rcv_int(1) && pc(1) <= rcv_int(2) && abs(pc(2)) < 0.1
            plot(phtn_pth(:, 1), phtn_pth(:, 2), '-');
            break;
        end    
        % Decide whether scattering or absorption occurs
        if rand < mu1 / mu
            absorbed = true; 
        else
            % Update direction 
            theta = 2 * pi * rand;
            vc = [cos(theta), sin(theta)];
        end
    end
end
xlabel('x_1');
ylabel('x_2');
title('Photon Paths Reaching the Selected Receiver');
axis equal;
grid on;
hold off;
figure;
nbins = 50;
[N, C] = hist3(sctr_pt, [nbins, nbins]);
imagesc(C{1}, C{2}, N');
colorbar;
xlabel('x_1');
ylabel('x_2');
title('Heatmap of Scattering Point Density for Photons Reaching the Selected Receiver');
axis equal;
figure;
distances = sqrt(sctr_pt(:, 1).^2 + sctr_pt(:, 2).^2);
histogram(distances, 30);
xlabel('Distance from Source (units)');
ylabel('Frequency');
title('Histogram of Distances Traveled by Photons Reaching the Receiver');
grid on;




