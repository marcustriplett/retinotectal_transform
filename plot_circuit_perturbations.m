function plot_circuit_perturbations(DSI, max_response, pref_dir, FWHM, num_trials)

save_on = 0;

xticklabs = {'complete', 'w/o recip. inh.', 'abl. S1', 'abl. S1,S2', 'abl. S1,S2,S3'};
pos = [0 0 600 700];
maxcol = 10;
fs = 30; % font size

cmap = cbrewer('seq', 'Oranges', maxcol, 'PCHIP');
figure;
for t = 1:num_trials
    bar(t, DSI(t), 'FaceColor', cmap(maxcol - t, :), 'LineWidth', 3)
    if t == 1, hold on, end;
end
set(gcf, 'Color', 'w', 'Position', pos);
ylabel('DSI')
set(gca, 'FontSize', fs, 'YTick', [0.5, 1], 'LineWidth', 3);
set(gca, 'XTick', 1:num_trials, 'XTickLabel', xticklabs);
xtickangle(45);
box off;
if save_on, export_fig('paper_figs/bar_dsi', '-pdf'); end;

figure;
for t = 1:num_trials
    bar(t, max_response(t), 'FaceColor', cmap(maxcol - t, :), 'LineWidth', 3)
    if t == 1, hold on, end;
end
ylabel('Amplitude (a.u.)')
set(gcf, 'Color', 'w', 'Position', pos);
set(gca, 'FontSize', fs, 'YTick', [0.15, 0.3], 'LineWidth', 3)
set(gca, 'XTick', 1:num_trials, 'XTickLabel', xticklabs);
xtickangle(45);
box off;
if save_on, export_fig('paper_figs/bar_amplitude', '-pdf'); end;

figure;
for t = 1:num_trials
    bar(t, abs(pref_dir(1) - pref_dir(t)), 'FaceColor', cmap(maxcol - t, :), 'LineWidth', 3)
    if t == 1, hold on, end;
end
ylabel('Tuning error (degrees)')
set(gcf, 'Color', 'w', 'Position', pos);
set(gca, 'FontSize', fs, 'YTick', [20, 40, 60], 'LineWidth', 3, ...
    'XTick', 1:num_trials, 'XTickLabel', xticklabs);
xtickangle(45);
box off;
if save_on, export_fig('paper_figs/bar_tuning_error', '-pdf'); end;

figure;
for t = 1:num_trials
    bar(t, FWHM(t), 'FaceColor', cmap(maxcol - t, :), 'LineWidth', 3)
    if t == 1, hold on, end;
end
ylabel('Bandwidth (degrees)')
set(gcf, 'Color', 'w', 'Position', pos);
set(gca, 'FontSize', fs, 'YTick', [60:60:240], 'LineWidth', 3, ...
    'XTick', 1:num_trials, 'XTickLabel', xticklabs);
xtickangle(45);
box off;
if save_on, export_fig('paper_figs/bar_fwhm_band', '-pdf'); end;
