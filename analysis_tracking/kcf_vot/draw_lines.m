function draw_lines

close all;

video = 'Basketball';

% run_tracker(video, 'gaussian', 'hog');
% run_tracker(video, 'gaussian', 'rgb');
% run_tracker(video, 'gaussian', 'gray');
% 
% run_tracker(video, 'polynomial', 'hog');
% run_tracker(video, 'polynomial', 'rgb');
% run_tracker(video, 'polynomial', 'gray');
% 
% run_tracker(video, 'linear', 'hog');
% run_tracker(video, 'linear', 'rgb');
% run_tracker(video, 'linear', 'gray');

draw(video);
function draw(video)
    
    mat_path = mfilename('fullpath');
    slash_idx = strfind(mat_path, '\');
    mat_path = mat_path(1:slash_idx(end));
    mat_path = strrep(mat_path, '\', '/');      
    mat_path = [mat_path '/'];
    
    gh = load([mat_path video '-gaussian-hog.mat']);
    gg = load([mat_path video '-gaussian-gray.mat']);
    gr = load([mat_path video '-gaussian-rgb.mat']);

    ph = load([mat_path video '-polynomial-hog.mat']);
    pg = load([mat_path video '-polynomial-gray.mat']);
    pr = load([mat_path video '-polynomial-rgb.mat']);

    lh = load([mat_path video '-linear-hog.mat']);
    lg = load([mat_path video '-linear-gray.mat']);
    lr = load([mat_path video '-linear-rgb.mat']);

    plot(gg.precisions, '-.k', 'LineWidth', 5); hold on 
    plot(pg.precisions, '-.r', 'LineWidth', 5); hold on 
    plot(lg.precisions, '-.m', 'LineWidth', 5); 
    
    plot(gh.precisions, '--r', 'LineWidth', 3); hold on 
    plot(ph.precisions, '--b', 'LineWidth', 2); hold on 
    plot(lh.precisions, '--g', 'LineWidth', 1); hold on 

    plot(gr.precisions, ':y', 'LineWidth', 2); hold on 
    plot(pr.precisions, ':b', 'LineWidth', 2); hold on 
    plot(lr.precisions, ':g', 'LineWidth', 2); hold on 

    xlabel('Location error threshold');
    ylabel('Precision');

    legend( 'gaus-gray','ploy-gray','line-gray',...  
            'gaus-hog', 'ploy-hog', 'line-hog',...  
            'gaus-rgb', 'ploy-rgb', 'line-rgb',...                       
            'Location', 'NorthWest'); % NorthWest  SouthEast
    
%     set(gcf,'position',[300 100 600 400]);
%     set(gca,'position',[0.08 0.08 0.88 0.88] );
    saveas(gcf, [mat_path  video '-lines.bmp']);
    
    base_path = 'E:\paper_code\KCF\tracker_release2\data\Benchmark\';
    img_path = [base_path video '\img\0001.jpg'];
    gt_path = [base_path video '\groundtruth_rect.txt'];
    im = imread(img_path);
    figure; imshow(im);
    gt = load(gt_path);
    rect = gt(1,:);
    rectangle('Position', [rect(1) rect(2) rect(3) rect(4)], 'EdgeColor', 'g', 'LineWidth', 3);
%     set(gca,'position',[0 0 1 1] );
    saveas(gcf, [mat_path  video '-img.bmp']);
end

end