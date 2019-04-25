function in_out_trackers = kcf_track(img, frame, in_out_trackers)
%% track_kcf

if isempty(in_out_trackers), return; end

inner_trackers = in_out_trackers{frame-1};
for idx = 1 : size(inner_trackers, 2)
    tracker = inner_trackers{idx};

    %[pos, t, model_xf, model_alphaf] = kcf(img, tracker.pos, tracker.kernel, tracker.lambda, tracker.interp_factor, tracker.cell_size, tracker.features, ...
    %    frame, tracker.yf, tracker.model_xf, tracker.model_alphaf, tracker.window_sz, tracker.cos_window); 

    [pos] = kcf_predict(img, tracker.pos, tracker.model_xf, tracker.model_alphaf, tracker.window_sz, ...
        tracker.features, tracker.cell_size, tracker.cos_window, tracker.kernel);

    tracker.pos = pos;
    in_out_trackers{frame}{idx} = tracker;
end

end