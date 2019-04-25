function in_out_trackers = trackers_clean(in_out_trackers, frame, param)

if isempty(in_out_trackers), 
    return; 
end

if frame - param.t_save <= 0
    return; 
end

in_out_trackers{frame - param.t_save} = {{1},{2}};

end