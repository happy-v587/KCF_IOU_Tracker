mota = {
43.5
67.7
54.4
44.2
33.7
43.2
29.9
};

fps={
30
30
14
30
30
30
25
};

density = {
14.2
69.7
9.7
32.6
26.8
9.2
24.6
};

close all;


set(gcf, 'Position', [500, 300, 350, 300])
plot(cell2mat(fps)',cell2mat(mota)', 'r.');
% xlabel('FPS');
% ylabel('MOTA');
% title('FPS - MOTA');
% axis([0 35 28 72]);
% grid minor;
% saveas(gca, 'pic/seq_fps_mota_16.bmp');
hold on;
% figure
% set(gcf, 'Position', [500, 300, 350, 300])
plot(cell2mat(density)',cell2mat(mota)', 'bd');
% xlabel('DENSITY');
% ylabel('MOTA');
% title('DENSITY - MOTA');
% axis([0 25 28 72]);
grid minor;
% saveas(gca, 'pic/seq_density_mota_16.bmp');
