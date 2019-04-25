function pre_id = kcf_nms(img, frame, data, targets, param)
%% kcf nms and iou and gate and size and hog and so on

det_rects = get_det_by_frame(data, frame, param.det_score);

if isempty(det_rects), pre_id=[]; return; end
if isempty(targets), pre_id=-1*ones(size(det_rects,1),1); return; end

targets = targets{frame};
t_size = size(targets, 2);
ids = zeros(t_size, 1); 
tck_rects = zeros(t_size, 4);

for idx = 1 : t_size
    id = targets{idx}.id;
    ids(idx) = id;            
    h = targets{idx}.target_sz(1);
    w = targets{idx}.target_sz(2);
    x = floor(targets{idx}.pos(2) - floor(w/2));
    y = floor(targets{idx}.pos(1) - floor(h/2));              
    tck_rects(idx, :) = [x y w h];
end

if 0
    colors = [
            1 0 0;        0 1 0;        0 0 1;
            1 1 0;        1 0 1;        0 1 1;
            0.5 0.5 1;    0.5 1 0.5;    1 0.5 0.5;
    ];
    figure(2);
    clf;
    for j = 1 : size(det_rects, 1)
        rectangle('Position', det_rects(j, 1:4), 'EdgeColor', colors(mod(j, size(colors, 1))+1,:), 'LineWidth',4);    
    end
    for j = 1 : size(tck_rects, 1)
        rectangle('Position', tck_rects(j, 1:4), 'EdgeColor', [0 0 0]);
    end
    drawnow;
    pause();
end

if 0
    lamba = 0.00000001;
    I = eye(size(tck_rects,2));
    w = (tck_rects' * tck_rects + lamba.*I) \ (tck_rects' * ids);
    pre_id = det_rects * w;
end

if 1
    t_size = size(tck_rects, 1);
    overlap_mat = zeros(t_size, size(det_rects, 1));
    for idx = 1 : t_size
        [ov, ~, ~] = calc_overlap(tck_rects(idx,:), det_rects);
        overlap_mat(idx, :) = ov;                
    end            
    [match, ~] = Hungarian(-overlap_mat);   
    pre_id = gen_relate_id(match, ids);    
    disp(ids')
    disp(pre_id')
end

end