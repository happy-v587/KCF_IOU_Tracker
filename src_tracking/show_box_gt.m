function show_box_gt(img, tit, gt, frame)
%% show box gt

    if isempty(gt)
        return
    end
    
    colors = [
            1 0 0;        0 1 0;        0 0 1;
            1 1 0;        1 0 1;        0 1 1;
            0.5 0.5 1;    0.5 1 0.5;    1 0.5 0.5;
    ];

    imshow(imresize(img, 0.5));
    title(tit);
    ids = gt(gt(:, 1) == frame, 2);
    gts = gt(gt(:, 1) == frame, 3:6);
    for nn = 1 : size(gts, 1)
        id = ids(nn);
        color = colors(mod(id, size(colors, 1))+1,:);
        x = gts(nn, 1);
        y = gts(nn, 2);
        w = gts(nn, 3);
        h = gts(nn, 4);
        rectangle('Position', [x y w h]/2, 'LineWidth', 1, 'EdgeColor', color);
        text(x/2, y/2, ['#' num2str(id, '%03d')], 'color', color, 'FontSize', 8, 'BackgroundColor', [1 1 1], 'Margin', 1);

        for k = 1 : 10
            if (frame - k) < 1 , break; end
            foot = gt(gt(:, 1) == (frame - k), 3:6);
            if size(foot, 1) < id, break; end; 
            x = foot(id, 1);
            y = foot(id, 2);
            w = foot(id, 3);
            h = foot(id, 4);
            rectangle('Position', [x+w/2, y+h 2 2]/2, 'LineWidth', 1, 'EdgeColor', color);
        end            
    end
    text(20, 40, ['#' num2str(frame, '%03d')], 'color', [0 0 0], 'FontSize', 15, 'back', [1 1 1]);
    xlabel(num2str(size(gts, 1)));
    drawnow;    
end