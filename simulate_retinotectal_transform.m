% SIMULATE_RETINOTECTAL_TRANSFORM 
%   Simulates the transformation of a retinal representation of the 
%   direction of object motion to a tectal representation with a simple 
%   rate-based neural network.
%   
%   See the corresponding journal article: "A three-layer network model
%   of direction-selective circuits in the optic tectum. "
%   F. Abbas et al. (2017). Frontiers in Neural Circuits.
%
%   Requires the CircStat, and CBrewer packages.

addpath plot_tools

% plot toggles
plot_polar_curves = 1;
plot_tuning_curves = 1;

% load raw tuning curves
rgc_rfs = load('rgc_rfs.csv');
[nr, nc] = size(rgc_rfs);
rgc_rfs = [rgc_rfs; rgc_rfs(1, :)];

% circuit vars
num_rgc = 3;
num_sin = 3;
num_pvn = 4;

tau_r = 5;
tau_s = 5;
tau_p = 5;

trial_duration = 100;
num_stimuli = 360;

relu = @(x) max(zeros(length(x), 1), x);

num_trials = 5;
DSI = zeros(num_trials, 1);
max_response = zeros(num_trials, 1);
pref_dir = zeros(num_trials, 1);
FWHM = zeros(num_trials, 1);

cols = {[56, 61, 150]/255, [231, 199, 31]/255, [70, 148, 73]/255, [94, 60, 108]/255};

% normalise raw tuning curves
for n = 1:nc
    rgc_rfs(:, n) = normalise(rgc_rfs(:, n));
end

vm_rgcs = zeros(360, nc);
rgc_params = zeros(nc, 2);
kap_mod = [2, 1.3, 2];
for n = 1:nc
    [thetahat, kappa] = circ_vmpar(circ_ang2rad(0:30:330), rgc_rfs(1:12, n), circ_ang2rad(30));
    kappa = kappa/kap_mod(n);
    rgc_params(n, :) = [thetahat, kappa];
    d = circ_vmpdf(circ_ang2rad(1:360), thetahat, kappa);
    vm_rgcs(:, n) = d/max(d);
end

% one trial per circuit condition
for trial = 1:5
    
    % load circuit architecture
    if trial == 1
        circuit = load_circuit(num_rgc, num_sin, num_pvn);
    else
       circuit = perturb_circuit(circuit, trial - 1); 
    end
    w_sr = circuit{1}; w_ss = circuit{2}; w_pr = circuit{3}; w_ps = circuit{4};

    % activity vectors
    r = zeros(num_rgc, trial_duration);
    s = zeros(num_sin, trial_duration);
    p = zeros(num_pvn, trial_duration);
    
    % response records
    response_r = zeros(num_rgc, num_stimuli);
    response_s = zeros(num_sin, num_stimuli);
    response_p = zeros(num_pvn, num_stimuli);
    
    for theta = 1:360/num_stimuli:360
        for t = 2:trial_duration
            % update RGCs
            drdt = 1/tau_r * (-r(:, t - 1) + transpose(vm_rgcs(theta, :)));
            r(:, t) = r(:, t - 1) + drdt;
            % update SINs
            dsdt = 1/tau_s * (-s(:, t - 1) + w_sr * r(:, t) - w_ss * s(:, t - 1)); 
            s(:, t) = relu(s(:, t - 1) + dsdt);
            % update PVNs
            dpdt = 1/tau_p * (-p(:, t - 1) + w_pr * r(:, t) - w_ps * s(:, t - 1));
            p(:, t) = relu(p(:, t - 1) + dpdt);

        end
        response_r(:, theta) = r(:, end);
        response_s(:, theta) = s(:, end);
        response_p(:, theta) = p(:, end);
    end
    
    % RGC response normalisation
    for rr = 1:num_rgc
        response_r(rr, :) = normalise(response_r(rr, :));
    end
    
    % SIN response normalisation and DSI calculation
    [sin_pref_val, sin_pref_ind] = max(response_s, [], 2);
    dsi_sin = zeros(num_sin, 1);
    
    for ss = 1:num_sin
        response_s(ss, :) = normalise(response_s(ss, :));
        dsi_sin(ss) = (sin_pref_val(ss) - response_s(ss, mod(sin_pref_ind(ss) + 180, 360)))/(sin_pref_val(ss) + response_s(ss, mod(sin_pref_ind(ss) + 180, 360)));
    end
    
    % compute P2 response FWHM bandwidth
    [mr, pd] = max(response_p(2, :));
    max_response(trial) = mr;
    halfmax = mr/2;
    if pd < 180
        left = [max(1, pd - 180):pd - 1, mod(pd - 180, 360):360];
        right = pd + 1:pd + 180;
    else
        left = max(1, pd - 180):pd - 1;
        right = [pd + 1:min(pd + 180, 360), 1:mod(pd + 180, 360)];
    end
    
    % Compute FWHM
    minleftval = 1;
    minrightval = 1;
    minleft = 0;
    minright = 0;
    for l = 1:numel(left)
        dif = abs(response_p(2, left(l)) - halfmax);
        if dif < minleftval
            minleftval = dif;
            minleft = left(l);
        end
    end
    
    for r = 1:numel(right)
        dif = abs(response_p(2, right(r)) - halfmax);
        if dif < minrightval
            minrightval = dif;
            minright = right(r);
        end
    end
    
    if minleft < 180
        FWHM(trial) = minright - minleft;
    else
        FWHM(trial) = (360 - minleft) + minright;
    end
        
    % Plotting  
    if plot_tuning_curves
        figure(trial);
        clf;
        hold on;
        set(gcf, 'Color', 'w');
        for pp = 1:num_pvn
            plot(response_p(pp, :), 'LineWidth', 3, 'Color', cols{pp})
        end
        set(gca, 'FontSize', 30, 'XTick', 0:180:360, 'LineWidth', 3, 'YTick', 0:0.1:0.3);
        axis square;
        ylabel('Response (a.u.)')
        xlabel('Angle (degrees)')
        ylim([0, 0.3])
        xlim([0, 360])
    end
    [pvn_pref_val, pvn_pref_ind] = max(response_p, [], 2);
    dsi_pvn = zeros(num_pvn, 1);
    for pp = 1:num_pvn
        response_p(pp, :) = normalise(response_p(pp, :));
        dsi_pvn(pp) = (pvn_pref_val(pp) - response_p(pp, mod(pvn_pref_ind(pp) + 180, 360)))/(pvn_pref_val(pp) + response_p(pp, mod(pvn_pref_ind(pp) + 180, 360)));
    end
    
    DSI(trial) = dsi_pvn(2);
    [~, pref_dir(trial)] = max(response_p(2, :));

    if plot_polar_curves
        figure(trial);
        clf;
        polarplot([]); hold on;
        set(gca, 'ThetaZeroLocation', 'top', 'RTick', [], 'GridAlpha', 1, 'FontSize', 30, 'LineWidth', 2);
        set(gcf, 'Color', 'w');
        polarplot(ones(360, 1), 'Color', 'white', 'LineWidth', 5);
        for pp = 1:num_pvn
            polarplot([response_p(pp, :), response_p(pp, 1)], 'LineWidth', 3, 'Color', cols{pp}); hold on;
        end
        box off;
    end
end

plot_polar_data_sin();
plot_emergent_pvn_curve_vs_data();
plot_polar_data_rgc();
plot_circuit_perturbations(DSI, max_response, pref_dir, FWHM, num_trials);