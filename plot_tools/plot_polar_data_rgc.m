% load and normalise raw tuning curves
rgc_rfs = load('rgc_rfs.csv');
[nr, nc] = size(rgc_rfs);
rgc_rfs = [rgc_rfs; rgc_rfs(1, :)];
for n = 1:nc
    rgc_rfs(:, n) = (rgc_rfs(:, n) - min(rgc_rfs(:, n)))/(max(rgc_rfs(:, n)) - min(rgc_rfs(:, n)));
end

figure; 
polarplot(ones(360, 1), 'Color', 'white', 'LineWidth', 3); hold on;
polarplot(vm_rgcs, 'Color', 'black', 'LineWidth', 2);
cols = {[56, 61, 150]/255, [70, 148, 73]/255, [94, 60, 108]/255};
for cc = 1:nc
   polarplot(rgc_rfs(:, cc), 'LineWidth', 3, 'Color', cols{cc}); 
end
set(gca, 'ThetaZeroLocation', 'top', 'RTick', [], 'GridAlpha', 1, 'FontSize', 20);
set(gcf, 'Color', 'w');
