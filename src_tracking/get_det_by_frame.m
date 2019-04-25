function [det] = get_det_by_frame(dets, frame, score)

assert(frame >= 1);
assert(score >= 0);

% frame, x, y, w, h, score
det = dets(dets(:,1) == frame, 3:7);

% score > t
det = det(det(:,5)>score, :);
% w > 0
det = det(det(:,3)>score, :);
% h > 0
det = det(det(:,4)>score, :);

% if x, y < 0, x,y =0; end
for i=1 : size(det, 1)
   if det(i, 1) < 0, det(i, 1) = 0; end
   if det(i, 2) < 0, det(i, 2) = 0; end   
end

end