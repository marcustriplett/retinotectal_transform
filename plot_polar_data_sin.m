% load and normalise raw tuning curves
sin_rfs = load('sin_rfs.csv');
[nr, nc] = size(sin_rfs);
sin_rfs = [sin_rfs; sin_rfs(1, :)];
for n = 1:nc
    sin_rfs(:, n) = (sin_rfs(:, n) - min(sin_rfs(:, n)))/(max(sin_rfs(:, n)) - min(sin_rfs(:, n)));
end

vm_sins = zeros(360, nc);
for n = 1:nc
    [thetahat, kappa] = circ_vmpar(circ_ang2rad(0:30:330), sin_rfs(1:12, n), circ_ang2rad(30));
    d = circ_vmpdf(circ_ang2rad(1:360), thetahat, kappa);
    vm_sins(:, n) = d/max(d);
end

figure; 
polarplot(ones(360, 1), 'Color', 'white', 'LineWidth', 3); hold on;
% polarplot(vm_rgcs, 'Color', 'black', 'LineWidth', 2);
polarplot(response_s', 'Color', 'black', 'LineWidth', 2)
cols = {[56, 61, 150]/255, [70, 148, 73]/255, 'magenta'};
%[231, 199, 31]/255
for cc = 1:nc
   polarplot(sin_rfs(:, cc), 'LineWidth', 3, 'Color', cols{cc}); 
end
% for cc = 1:nc
%     polarplot(vm_sins(:, cc), 'Color', cols{cc}, 'LineWidth', 2);
% end
% polarplot(vm_sins, 'Color', cols, 'LineWidth', 2)
set(gca, 'ThetaZeroLocation', 'top', 'RTick', [], 'GridAlpha', 1, 'FontSize', 20);
set(gcf, 'Color', 'w');
