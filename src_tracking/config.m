function obj = config()
%% config

    obj.t_same    = {10;20;30;40};        % judge same
    obj.det_score = {0.6;0.7;0.8;0.9};    % score for detect
    obj.t_track   = {2;4;6;8;};           % k frame to track 
    
    obj.t_save    = {4;6;8;10};
    
    obj.is_show   = 0;
    obj.is_save   = 1;
           
end
