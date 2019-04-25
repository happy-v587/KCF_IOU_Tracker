function show_box(img, tit, targets, frame)
%% show_box

if isempty(targets), return; end
targets = targets{frame};

colors = [
        1 0 0;        0 1 0;        0 0 1;
        1 1 0;        1 0 1;        0 1 1;
        0.5 0.5 1;    0.5 1 0.5;    1 0.5 0.5;
];

imshow(imresize(img, 0.5));
title(tit);
mm = size(targets, 2);

for nn = 1 : mm
    id = targets{nn}.id;
    h = targets{nn}.target_sz(1);
    w = targets{nn}.target_sz(2);
    x = floor(targets{nn}.pos(2) - floor(w/2));
    y = floor(targets{nn}.pos(1) - floor(h/2));
    rectangle('Position', [x y w h]/2, 'LineWidth', 1, 'EdgeColor', colors(mod(id, 9)+1, :));
    text(x/2, y/2, ['#' num2str(id, '%03d')], 'color', colors(mod(id, 9)+1, :), 'FontSize', 8, 'BackgroundColor', [1 1 1]);
end

text(20, 40, ['#' num2str(frame, '%03d')], 'color', [0 0 0], 'FontSize', 15, 'back', [1 1 1]);
xlabel(num2str(mm));

drawnow;

end