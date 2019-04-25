function show_box_dt(img, tit, data, frame)
%% show box dt
    imshow(imresize(img, 0.5));
    title(tit);
    data = data(data(:, 1) == frame, 3:6);
    for nn = 1 : size(data, 1)            
        x = data(nn, 1);
        y = data(nn, 2);
        w = data(nn, 3);
        h = data(nn, 4);
        rectangle('Position', [x y w h]/2, 'LineWidth', 1, 'EdgeColor', [0 1 1]);            
    end
    text(20, 40, ['#' num2str(frame, '%03d')], 'color', [0 0 0], 'FontSize', 15, 'back', [1 1 1]);
    xlabel(num2str(size(data, 1)));
    drawnow;    
end