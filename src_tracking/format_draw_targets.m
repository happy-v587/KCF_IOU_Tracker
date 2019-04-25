function [rects] = format_draw_targets(targets)

if isempty(targets), return; end

mm = size(targets, 2);
strs = zeros(mm, 1);
rects = zeros(mm, 4);
for nn = 1 : mm
    id = targets{nn}.id;
    h = targets{nn}.target_sz(1);
    w = targets{nn}.target_sz(2);
    x = floor(targets{nn}.pos(2) - floor(w/2));
    y = floor(targets{nn}.pos(1) - floor(h/2));
    rects(nn, :) = [x y w h]; 
end

end