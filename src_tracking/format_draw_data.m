function [rects] = format_draw_data(det, frame)

if isempty(det), return; end

data = det(det(:, 1) == frame, 3:6);
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