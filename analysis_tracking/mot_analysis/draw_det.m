function [rects] = draw_det

frame = 196;
det = load(sprintf('data/sort-det/train/%s.txt', 'ADL-Rundle-6'));
imgFile = sprintf('D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/%s.jpg', 'ADL-Rundle-6', num2str(frame, '%06d'));

data = det(det(:, 1) == frame, 3:7);
data = data(data(:,5)>0,1:4);

mm = size(data, 1);
rects = zeros(mm, 4);
for nn = 1 : mm
    x = data(nn, 1);
    y = data(nn, 2);
    w = data(nn, 3);
    h = data(nn, 4);
    rects(nn, :) = [x y w h];     
end   

set(gca, 'Position',[0 0 1 1]);
imshow(imgFile);
text(20, 40, ['#' num2str(frame, '%03d')], 'color', [0 0 0], 'FontSize', 15, 'back', [1 1 1]); 
for aa=1:size(rects, 1), rectangle('Position', rects(aa,:), 'EdgeColor', [1 0 0], 'LineWidth', 5); end
drawnow;
saveas(gca, sprintf('result/pics/det-kcf/ADL-Rundle-6/%s-det-0.jpg', num2str(frame)));

end