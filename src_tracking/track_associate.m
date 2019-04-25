function [state, rid] = track_associate(in_out_trackers, img, rect, maybe_ids, t_same, t_track)
%% track_associate

is_show = 0;

patch = imcrop(img, [rect.x, rect.y rect.w rect.h]);

if is_show
   figure(5);  subplot(1,2,1); imshow(patch);  
end

maybe_ids_len = size(maybe_ids, 2);

for ii=1 : maybe_ids_len
    
    if maybe_ids{ii} == 0, 
        continue; 
    end
    
    patchs = get_target_by_id(in_out_trackers, maybe_ids{ii}, t_track);   

    [score] = matchBatch(patch, patchs);
    if score < t_same
        state = true;
        rid = maybe_ids{ii};        
        return
    end
end

state = false;
rid = -1;

function [score] = matchBatch(patch, patchs)
%%  比较 patch 和 List<patchs>的相似性
%  返回不同模板的相似性

    patch_len = size(patchs, 2);
    score = zeros(patch_len, 1);
    for i=1 : patch_len
        score(i) = match(patch, patchs{i});
    end
    score = mean(score); % mean or min or max
end

function [patch_diff] = match(patch1, patch2, filter)
%% 第一种方法，点与点直接比较

    if size(patch1, 3) > 1
        patch1 = rgb2gray(patch1);
    end
    if size(patch2, 3) > 1
        patch2 = rgb2gray(patch2);
    end    

    scale = [size(patch1, 1) size(patch1, 2)];
    patch2 = imresize(patch2, scale);

    if nargin < 3 || filter == 0
        w = fspecial('gaussian', [5 5], 5);
        patch1 = imfilter(patch1, w);
        patch2 = imfilter(patch2, w);
    end

    [m, n, c] = size(patch1);
    patch_diff = patch1 - patch2;
    patch_diff = abs(patch_diff);
    patch_diff = sum(patch_diff(:)) / (m*n*c);
end

end