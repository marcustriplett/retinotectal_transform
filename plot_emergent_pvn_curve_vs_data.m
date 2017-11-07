pvn_rfs = load('pvn_rfs.csv');
[nr, nc] = size(pvn_rfs);
pvn_rfs = [pvn_rfs; pvn_rfs(1, :)];
for n = 1:nc
    pvn_rfs(:, n) = (pvn_rfs(:, n) - min(pvn_rfs(:, n)))/(max(pvn_rfs(:, n)) - min(pvn_rfs(:, n)));
end

figure;
polarplot(ones(360, 1), 'Color', 'white', 'LineWidth', 3); hold on;
polarplot([response_p(2, :), response_p(2, 1)], 'Color', 'black', 'LineWidth', 2); hold on;
polarplot(pvn_rfs(:, 2), 'Color', [231, 199, 31]/255, 'LineWidth', 3);
set(gca, 'ThetaZeroLocation', 'top', 'RTick', [], 'GridAlpha', 1, 'FontSize', 20);
set(gcf, 'Color', 'w');