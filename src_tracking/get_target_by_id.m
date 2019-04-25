function [patchs] = get_target_by_id(targets, id, max_k)

total_frame = size(targets, 2);

if total_frame > max_k,
    begin_frame = total_frame - max_k;
    end_frame   = total_frame;
else
    begin_frame = 1;
    end_frame   = total_frame;
end

k = 1;
patchs = cell(0);
for i=begin_frame : end_frame
    for j=1 : size(targets{i}, 2)
       if  targets{i}{j}.id == id
           patchs{k} = targets{i}{j}.patch;
           k = k + 1;
       end
    end
end

end