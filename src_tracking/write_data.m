function write_data(targets, frame, filename)

    if isempty(targets), return; end
    targets = targets{frame};
    mm = size(targets, 2);
    dres = zeros(mm, 6);
    for nn = 1 : mm
        id = targets{nn}.id;
        h = targets{nn}.target_sz(1);
        w = targets{nn}.target_sz(2);
        x = floor(targets{nn}.pos(2) - floor(w/2));
        y = floor(targets{nn}.pos(1) - floor(h/2));
        dres(nn, :) = [frame, id, x, y, w, h];
    end

    write_tracking_results(filename, dres);
    
    function write_tracking_results(filename, dres, len)
        fid = fopen(filename, 'a');
        if nargin < 3
            len = size(dres, 1);
        end
        for i = 1 : len
            % <frame>, <id>, <bb_left>, <bb_top>, <bb_width>, <bb_height>, <conf>, <x>, <y>, <z>    
            fprintf(fid, '%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n', ...
                dres(i,1), dres(i,2), dres(i,3), dres(i,4), dres(i,5), dres(i,6), -1, -1, -1, -1);    
        end
        fclose(fid);
    end
end