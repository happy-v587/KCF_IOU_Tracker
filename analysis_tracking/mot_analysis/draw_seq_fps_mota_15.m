mota = {
68.9
23.1
39.9
52.0
58.7
17.6
17.5
33.6
10.1
24.9
20.6
};

fps={
25
7
14
14
14
2.5
30
30
10
10
30
};

density = {
5.5
22.1
5.8
7.5
4.6
15.9
18.6
16.3
8.1
5.0
10.1
};

set(gcf, 'Position', [500, 300, 350, 300])
plot(cell2mat(fps)',cell2mat(mota)', 'k*');
xlabel('FPS');
ylabel('MOTA');
title('FPS - MOTA');
axis([0 35 8 72]);
grid minor;
saveas(gca, 'analysis_tracking/mot_analysis/seq_fps_mota.bmp');

figure
set(gcf, 'Position', [500, 300, 350, 300])
plot(cell2mat(density)',cell2mat(mota)', 'k*');
xlabel('DENSITY');
ylabel('MOTA');
title('DENSITY - MOTA');
axis([0 25 8 72]);
grid minor;
saveas(gca, 'analysis_tracking/mot_analysis/seq_density_mota.bmp');
