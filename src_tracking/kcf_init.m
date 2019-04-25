function [in_out_trackers] = kcf_init(img, frame, data, in_out_trackers, param, ids)
%% init

global g_id; 

init_trackers = cell(0);

rects = get_det_by_frame(data, frame, param.det_score);

if isempty(rects), return; end

relate.k = 1;
relate.ids = cell(0);

for i = 1 : size(rects, 1)
   rect.x = rects(i, 1);
   rect.y = rects(i, 2);
   rect.w = rects(i, 3);
   rect.h = rects(i, 4);          

   if nargin < 6     
       g_id = g_id + 1;
       id = g_id;
   elseif ids(i) == -1
       none_track_ids = get_target_none_track( in_out_trackers, relate, param.t_track );
       if isempty(none_track_ids)
           g_id = g_id + 1;
           id = g_id;
       else
           % 判断是否为原来的目标
           [state, rid] = track_associate(in_out_trackers, img, rect, none_track_ids, param.t_same, param.t_track);
           if state == true
               id = rid;
               relate.ids{relate.k} = rid;
               relate.k = relate.k + 1;
           else
               g_id = g_id + 1;
               id = g_id;
           end
           disp(none_track_ids)
       end
   else
       id = ids(i); 
   end
   init_trackers{i} = initTracker(img, rect, id);
end

in_out_trackers{frame} = init_trackers;

end