function  draw_kcf_mot_precisions()

mat_path = mfilename('fullpath');
slash_idx = strfind(mat_path, '\');
mat_path = mat_path(1:slash_idx(end));
mat_path = strrep(mat_path, '\', '/');
mat_path = [mat_path '/'];

%{
ETH_Bahnhof(mat_path);
function ETH_Bahnhof(mat_path)

p1 = load([mat_path 'ETH-Bahnhof-1.mat']);
p2 = load([mat_path 'ETH-Bahnhof-2.mat']);
p3 = load([mat_path 'ETH-Bahnhof-3.mat']);
p4 = load([mat_path 'ETH-Bahnhof-4.mat']);
p5 = load([mat_path 'ETH-Bahnhof-5.mat']);
p6 = load([mat_path 'ETH-Bahnhof-6.mat']);

plot(p1.precisions, '-r', 'LineWidth', 3); hold on 
plot(p2.precisions, '-b', 'LineWidth', 3); hold on 
plot(p3.precisions, '-g', 'LineWidth', 3); hold on 
plot(p4.precisions, '-.y', 'LineWidth', 3); hold on 
plot(p5.precisions, '-.k', 'LineWidth', 3); hold on 
plot(p6.precisions, '-.m', 'LineWidth', 3);
xlabel('Location error threshold');
ylabel('Precision');
legend('1st Target','2nd Target','3rd Target',...
    '4th Target','5th Target','6th Target', 'Location', 'SouthEast');
saveas(gcf, [mat_path  'ETH-Bahnhof-pre.jpg']);

figure
path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/ETH-Bahnhof/img1/000001.jpg';
im = imread(path);
imshow(im);

path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/ETH-Bahnhof/gt/gt.txt';
data = load(path);
data = data(data(:,1) == 1, :);

text(20, 40, ['#' num2str(1, '%03d')], 'color', [0 0 0], 'FontSize', 20, 'back', [1 1 1]);
color = {'red'; 'blue'; 'green'; 'yellow'; 'black'; 'magenta'};
for i = 1 : size(data, 1)
    rectangle('Position', data(i, 3:6), 'LineWidth', 2, 'EdgeColor', color{i});
    text(data(i, 3), data(i, 4)-8, num2str(i), 'color', color{i}, 'FontWeight', 'bold');
end
saveas(gcf, [mat_path  'ETH-Bahnhof-img.jpg']);

end
%}

%{
ETH_Sunnyday(mat_path);
function ETH_Sunnyday(mat_path)

p1 = load([mat_path 'ETH-Sunnyday-1.mat']);
p2 = load([mat_path 'ETH-Sunnyday-2.mat']);
p3 = load([mat_path 'ETH-Sunnyday-3.mat']);
p4 = load([mat_path 'ETH-Sunnyday-4.mat']);
p5 = load([mat_path 'ETH-Sunnyday-5.mat']);

plot(p1.precisions, '-r', 'LineWidth', 3); hold on 
plot(p2.precisions, '-b', 'LineWidth', 3); hold on 
plot(p3.precisions, '-g', 'LineWidth', 3); hold on 
plot(p4.precisions, '-.y', 'LineWidth', 3); hold on 
plot(p5.precisions, '-.k', 'LineWidth', 3); 
xlabel('Location error threshold');
ylabel('Precision');
legend('1st Target','2nd Target','3rd Target',...
    '4th Target','5th Target', 'Location', 'SouthEast');
saveas(gcf, [mat_path  'ETH-Sunnyday-pre.jpg']);

figure
path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/ETH-Sunnyday/img1/000001.jpg';
im = imread(path);
imshow(im);

path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/ETH-Sunnyday/gt/gt.txt';
data = load(path);
data = data(data(:,1) == 1, :);

text(20, 40, ['#' num2str(1, '%03d')], 'color', [0 0 0], 'FontSize', 20, 'back', [1 1 1]);
color = {'red'; 'blue'; 'green'; 'yellow'; 'black'; 'magenta'};
for i = 1 : size(data, 1)
    rectangle('Position', data(i, 3:6), 'LineWidth', 2, 'EdgeColor', color{i});
    text(data(i, 3), data(i, 4)-8, num2str(i), 'color', color{i}, 'FontWeight', 'bold');
end
saveas(gcf, [mat_path  'ETH-Sunnyday-img.jpg']);

end
%}

%{
TUD_Campus(mat_path);
function TUD_Campus(mat_path)

p1 = load([mat_path 'TUD-Campus-1.mat']);
p2 = load([mat_path 'TUD-Campus-2.mat']);
p3 = load([mat_path 'TUD-Campus-3.mat']);
p4 = load([mat_path 'TUD-Campus-4.mat']);
p5 = load([mat_path 'TUD-Campus-5.mat']);
p6 = load([mat_path 'TUD-Campus-6.mat']);

plot(p1.precisions, '-r', 'LineWidth', 3); hold on 
plot(p2.precisions, '-b', 'LineWidth', 3); hold on 
plot(p3.precisions, '-g', 'LineWidth', 3); hold on 
plot(p4.precisions, '-.y', 'LineWidth', 3); hold on 
plot(p5.precisions, '-.k', 'LineWidth', 3); hold on 
plot(p6.precisions, '-.m', 'LineWidth', 3);
xlabel('Location error threshold');
ylabel('Precision');
legend('1st Target','2nd Target','3rd Target',...
    '4th Target','5th Target','6th Target', 'Location', 'SouthEast');
saveas(gcf, [mat_path  'TUD-Campus-pre.jpg']);

figure
path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/TUD-Campus/img1/000001.jpg';
im = imread(path);
imshow(im);

path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/TUD-Campus/gt/gt.txt';
data = load(path);
data = data(data(:,1) == 1, :);

text(20, 40, ['#' num2str(1, '%03d')], 'color', [0 0 0], 'FontSize', 20, 'back', [1 1 1]);
color = {'red'; 'blue'; 'green'; 'yellow'; 'black'; 'magenta'};
for i = 1 : size(data, 1)
    rectangle('Position', data(i, 3:6), 'LineWidth', 2, 'EdgeColor', color{i});
    text(data(i, 3), data(i, 4)-8, num2str(i), 'color', color{i}, 'FontWeight', 'bold');
end
saveas(gcf, [mat_path  'TUD-Campus-img.jpg']);

end
%}

TUD_Stadtmitte(mat_path);
function TUD_Stadtmitte(mat_path)

p1 = load([mat_path 'TUD-Stadtmitte-1.mat']);
p2 = load([mat_path 'TUD-Stadtmitte-2.mat']);
p3 = load([mat_path 'TUD-Stadtmitte-3.mat']);
p4 = load([mat_path 'TUD-Stadtmitte-4.mat']);
p5 = load([mat_path 'TUD-Stadtmitte-5.mat']);
p6 = load([mat_path 'TUD-Stadtmitte-6.mat']);
p7 = load([mat_path 'TUD-Stadtmitte-7.mat']);

plot(p1.precisions, '-r', 'LineWidth', 3); hold on 
plot(p2.precisions, '-b', 'LineWidth', 3); hold on 
plot(p3.precisions, '-g', 'LineWidth', 3); hold on 
plot(p4.precisions, '-.y', 'LineWidth', 3); hold on 
plot(p5.precisions, '-.k', 'LineWidth', 3); hold on 
plot(p6.precisions, '-.m', 'LineWidth', 3); hold on 
plot(p7.precisions, '--r', 'LineWidth', 3);
xlabel('Location error threshold');
ylabel('Precision');
legend('1st Target','2nd Target','3rd Target',...
    '4th Target','5th Target','6th Target', '7th Target', 'Location', 'SouthEast');
saveas(gcf, [mat_path  'TUD-Stadtmitte-pre.jpg']);

figure
path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/TUD-Stadtmitte/img1/000001.jpg';
im = imread(path);
imshow(im);

path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/TUD-Stadtmitte/gt/gt.txt';
data = load(path);
data = data(data(:,1) == 1, :);

text(20, 40, ['#' num2str(1, '%03d')], 'color', [0 0 0], 'FontSize', 20, 'back', [1 1 1]);
color = {'red'; 'blue'; 'green'; 'yellow'; 'black'; 'magenta'; 'red'};
for i = 1 : size(data, 1)
    rectangle('Position', data(i, 3:6), 'LineWidth', 2, 'EdgeColor', color{i});
    text(data(i, 3), data(i, 4)-8, num2str(i), 'color', color{i}, 'FontWeight', 'bold');
end
saveas(gcf, [mat_path  'TUD-Stadtmitte-img.jpg']);

end

end