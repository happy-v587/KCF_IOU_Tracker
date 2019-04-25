function tracker = initTracker(img, rect, id)
    %% initTracker
    
        tracker.patch = imcrop(img, [rect.x, rect.y rect.w, rect.h]);
        
        lefttop = [rect.y rect.x];   % r, c
        tracker.target_sz = [rect.h rect.w]; % h, w
        tracker.pos = [lefttop(1) + tracker.target_sz(1)/2, lefttop(2) + tracker.target_sz(2)/2];

        tracker.id = id;
        tracker.padding = 1.5;
        tracker.kernel.type = 'gaussian';
        tracker.lambda = 0.0001;
        tracker.output_sigma_factor = 0.1;
        tracker.show_visualization = 0;
        
        feature_type = 'hog';
               
        tracker.features.gray = false;
        tracker.features.hog = false;
        
        switch feature_type
        case 'gray',
            tracker.interp_factor = 0.075;  %linear interpolation factor for adaptation
            tracker.kernel.sigma = 0.2;  %gaussian kernel bandwidth
            tracker.kernel.poly_a = 1;  %polynomial kernel additive term
            tracker.kernel.poly_b = 7;  %polynomial kernel exponent
            tracker.features.gray = true;
            tracker.cell_size = 9;
        case 'hog',
            tracker.interp_factor = 0.02;
            tracker.kernel.sigma = 0.5;
            tracker.kernel.poly_a = 1;
            tracker.kernel.poly_b = 9;
            tracker.features.hog = true;
            tracker.features.hog_orientations = 9;
            tracker.cell_size = 4;
        otherwise
            error('Unknown feature.')
        end

        %tracker.resize_image = (sqrt(prod(tracker.target_sz)) >= 100);  %diagonal size >= threshold
        %if tracker.resize_image,
        %    tracker.pos = floor(tracker.pos / 2);
        %    tracker.target_sz = floor(tracker.target_sz / 2);
        %end

        tracker.window_sz = floor(tracker.target_sz * (1 + tracker.padding));
        tracker.output_sigma = sqrt(prod(tracker.target_sz)) * tracker.output_sigma_factor / tracker.cell_size;
        tracker.yf = fft2(gaussian_shaped_labels(tracker.output_sigma, floor(tracker.window_sz / tracker.cell_size)));
        tracker.cos_window = hann(size(tracker.yf,1)) * hann(size(tracker.yf,2))';

        frame_kcf = 1;
        model_xf = 0;
        model_alphaf = 0;
        [model_xf, model_alphaf] = kcf_train(img, tracker.pos, frame_kcf, tracker.yf, ...
            model_xf, model_alphaf, tracker.window_sz, tracker.features, tracker.cell_size, ...
            tracker.cos_window, tracker.kernel, tracker.lambda, tracker.interp_factor);
        
        tracker.model_xf = model_xf;
        tracker.model_alphaf = model_alphaf;

    end