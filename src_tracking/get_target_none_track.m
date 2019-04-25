function [target_n_show_ids] = get_target_none_track(targets, relate, t_track)

target_show_ids = cell(0);
target_n_show_ids = cell(0);
total_frame = size(targets, 2);

if total_frame <= 1
    return 
end

m = 1;
for i=1 : size(targets{total_frame}, 2)
    target_show_ids{m} = targets{total_frame}{m}.id;m=m+1;
end

for i=1 : size(relate.ids, 2)
    target_show_ids{m} = relate.ids{i};m=m+1;
end

k = 1;
begin_frame = total_frame - t_track - 1;
if begin_frame <= 0, begin_frame = 1; end
for i=begin_frame : total_frame-1
    for j=1 : size(targets{i}, 2)                
        if ~array_in(target_show_ids, targets{i}{j}.id) && ~array_in(target_n_show_ids, targets{i}{j}.id)
            target_n_show_ids{k} = targets{i}{j}.id;
            k = k + 1;
        end
    end
end

function [bool] = array_in(ocean, needal)    
    bool = false;
    for ii=1 : size(ocean, 2)
        bool = (ocean{ii} == needal);
        if bool, return; end
    end
end
    
end