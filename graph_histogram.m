C=R_array;
% C=debug_Vds_expand_array;
C_count=size(C);
numBins = 500;
f3 = figure;
histogram(C,numBins,'BinLimits',[min(C),max(C)],'EdgeColor','none');
grid on;
xlabel('Data Value', 'FontSize', 15);
ylabel('Count', 'FontSize', 15);
% Compute mean and standard deviation.
mu = mean(C);
sigma = std(C);
% Indicate those on the plot.
xline(mu, 'Color', 'g', 'LineWidth', 2);
xline(mu - sigma, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(mu + sigma, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(mu - 2*sigma, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(mu + 2*sigma, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(mu - 3*sigma, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xline(mu + 3*sigma, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');

sMean = sprintf('  Mean = %.3f\n  SD = %.3f', mu, sigma);

ylim([0, C_count(1)/20]); % Give some headroom above the bars.
yl = ylim;
% Position the text 90% of the way from bottom to top.
text(1,0.9*yl(2), sMean, 'Color', 'r', ...
	'FontWeight', 'bold', 'FontSize', 9, ...
	'EdgeColor', 'b');

sMean2= sprintf('Histogram with %d bins.  Mean = %.3f.  SD = %.3f', numBins, mu, sigma);
title(sMean2, 'FontSize', 15);
% 計算該 [] 值 以下(上)佔全部資料數比例
C_low3_sigma=find(C<(mu-2*sigma));
C_low3_sigma_count=size(C_low3_sigma);
s_low3_sigma=sprintf('The percentage is %.3f%%',(C_low3_sigma_count(1)/C_count(1))*100  );
disp(s_low3_sigma);
