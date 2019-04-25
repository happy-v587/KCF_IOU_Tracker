function [rects] = draw_det_iou

branckmark = 'ADL-Rundle-6';
det = load(sprintf('data/sort-det/train/%s.txt', branckmark));

for frame = 2 : size(det, 1)
    disp(frame);
    
    % show frame image        
    imgFile = sprintf('D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/%s.jpg', branckmark, num2str(frame, '%06d'));
    
    set(gca, 'Position',[0 0 1 1]);
    imshow(imgFile);
    text(20, 40, ['#' num2str(frame, '%03d')], 'color', [0 0 0], 'FontSize', 15, 'back', [1 1 1]); 

    % draw last rectangle    
    rects = get_det(frame-1, det);
    for aa=1:size(rects, 1), rectangle('Position', rects(aa,:), 'EdgeColor', [0 1 0], 'LineWidth', 5); end
    % draw rectangle    
    rects = get_det(frame, det);
    for aa=1:size(rects, 1), rectangle('Position', rects(aa,:), 'EdgeColor', [1 0 0], 'LineWidth', 3); end

    drawnow;

    saveas(gca, sprintf('pic/sort-det/%s/%s.jpg', branckmark, num2str(frame)));
end

function [rects] = get_det(frame, data)
    data = data(data(:, 1) == frame, 3:7);
    data = data(data(:,5)>0.9, 1:4);
    mm = size(data, 1);
    rects = zeros(mm, 4);
    for nn = 1 : mm
        x = data(nn, 1);
        y = data(nn, 2);
        w = data(nn, 3);
        h = data(nn, 4);
        rects(nn, :) = [x y w h];     
    end   
end

end