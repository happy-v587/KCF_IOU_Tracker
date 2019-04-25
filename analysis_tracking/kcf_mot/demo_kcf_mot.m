function demo_kcf_mot(brench, obj_id, kernel_type, feature_type, show_visualization, show_plots)
 
    close all;clc;
    mat_path = mfilename('fullpath');
    slash_idx = strfind(mat_path, '\');
    mat_path = mat_path(1:slash_idx(end));
    mat_path = strrep(mat_path, '\', '/');
    
    %default settings
    if nargin < 1, brench = 1; end
    if nargin < 2, obj_id = 1; end
    if nargin < 3, kernel_type = 'gaussian'; end
    if nargin < 4, feature_type = 'hog'; end
    if nargin < 5, show_visualization = 1; end
    if nargin < 6, show_plots = 1; end

    %base path
    root_path = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train';
    base_path = [root_path '/%s/gt/gt.txt'];
    base_img  = [root_path '/%s/img1/'];
    brenchmark = { 'ADL-Rundle-6'; 'ADL-Rundle-8'; 'ETH-Bahnhof'; 'ETH-Pedcross2';
        'ETH-Sunnyday'; 'KITTI-13'; 'KITTI-17'; 'PETS09-S2L1'; 'TUD-Campus';
        'TUD-Stadtmitte'; 'Venice-2'
    };

    %base data
    brench = str2double(brench);
    base_path = sprintf(base_path,brenchmark{brench});    
    data = load(base_path);
    
    video_path = sprintf(base_img, brenchmark{brench});    
    
    img_files = dir([video_path '*.png']);
    if isempty(img_files),
        img_files = dir([video_path '*.jpg']);
        assert(~isempty(img_files), 'No image files to load.')
    end
    img_files = sort({img_files.name});

    %target object    
    obj_id = str2double(obj_id);
    totalFrame = max(data(data(:,2) == obj_id,1));
    
    data = data(data(:,1) == 1, :);
    lefttop    = [data(obj_id,4) data(obj_id,3)];   % r, c
    target_sz  = [data(obj_id,6) data(obj_id,5)]; % h, w
    pos        = [lefttop(1) + target_sz(1)/2, lefttop(2) + target_sz(2)/2];   
    
    %parameters according to the paper. at this point we can override
    %parameters based on the chosen kernel or feature type
    kernel.type = kernel_type;

    features.gray = false;
    features.hog = false;
    features.rgb = false;

    padding = 1.5;  %extra area surrounding the target
    lambda = 1e-4;  %regularization
    output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)

    switch feature_type
    case 'gray',
        interp_factor = 0.075;  %linear interpolation factor for adaptation

        kernel.sigma = 0.2;  %gaussian kernel bandwidth

        kernel.poly_a = 1;  %polynomial kernel additive term
        kernel.poly_b = 7;  %polynomial kernel exponent

        features.gray = true;
        cell_size = 1;

    case 'rgb',
        interp_factor = 0.075;  %linear interpolation factor for adaptation

        kernel.sigma = 0.2;  %gaussian kernel bandwidth

        kernel.poly_a = 1;  %polynomial kernel additive term
        kernel.poly_b = 7;  %polynomial kernel exponent

        features.rgb = true;
        cell_size = 1;

    case 'hog',
        interp_factor = 0.02;

        kernel.sigma = 0.5;

        kernel.poly_a = 1;
        kernel.poly_b = 9;

        features.hog = true;
        features.hog_orientations = 9;
        cell_size = 4;

    otherwise
        error('Unknown feature.')
    end

    assert(any(strcmp(kernel_type, {'linear', 'polynomial', 'gaussian'})), 'Unknown kernel.')

    resize_image = (sqrt(prod(target_sz)) >= 100);  %diagonal size >= threshold
    if resize_image,
        pos = floor(pos / 2);
        target_sz = floor(target_sz / 2);
    end

    window_sz = floor(target_sz * (1 + padding));
    output_sigma = sqrt(prod(target_sz)) * output_sigma_factor / cell_size;
    yf = fft2(gaussian_shaped_labels(output_sigma, floor(window_sz / cell_size)));
    cos_window = hann(size(yf,1)) * hann(size(yf,2))';

    model_xf = 0;
    model_alphaf = 0;
    time = 0;
    positions = zeros(totalFrame, 2);  %to calculate precision

    if show_visualization
        update_visualization = show_video(img_files, video_path, resize_image);
    end

    for frame = 1 : totalFrame

        disp(['frame=>' num2str(frame)]);

        img_path = [video_path num2str(frame,'%06d') '.jpg'];    
        img = imread(img_path);
        if resize_image,
            img = imresize(img, 0.5);
        end
        [pos, t, model_xf, model_alphaf] = kcf(img, pos, kernel, lambda, interp_factor, cell_size, features, ...
        frame, yf, model_xf, model_alphaf, window_sz, cos_window); 

        positions(frame,:) = pos;    
        time = time + t;

        if show_visualization
            box = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
            stop = update_visualization(frame, box);
            if stop, break, end  %user pressed Esc, stop early
            drawnow       
        end
    end

    if resize_image,
        positions = positions * 2;
    end

    video = brenchmark{brench};
    ground_truth = load_gt_data(base_path, obj_id);
    precisions = precision_plot(positions, ground_truth, video, show_plots);
    filename = [brenchmark{brench} '-' num2str(obj_id) '.mat'];
    save([mat_path '/' filename], 'precisions');
    
    function ground_truth = load_gt_data(infile, obj_id)
        ground_truth = load(infile);
        ground_truth = ground_truth(ground_truth(:,2) == obj_id, 3:6); % frame,id,x,y,w,h,conf,-1,-1,-1               
        if size(ground_truth,1) == 1,
            %we have ground truth for the first frame only (initial position)
            ground_truth = [];
        else
            %store positions instead of boxes
            ground_truth = ground_truth(:,[2,1]) + ground_truth(:,[4,3]) / 2;
        end
    end
end