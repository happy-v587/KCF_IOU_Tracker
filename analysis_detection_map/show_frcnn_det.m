baseimage = 'F:/MOT16/test/%s/img1/%s.jpg';
brenchmark = { 
    'MOT16-01'; 
    'MOT16-03'; 
    'MOT16-06'; 
    'MOT16-07'; 
    'MOT16-08'; 
    'MOT16-12'; 
    'MOT16-14'; 
};
brench = 2;
dets = load(sprintf('result/det-iou-mot16/test/k8-s40-c0.0/%s.txt', brenchmark{brench}));

is_save = 0;

for i = 1 : 500
    disp(['frame  ====> ' num2str(i)]);
    det = dets(dets(:,1) == i, 3:7);    
    im = imread(sprintf(baseimage, brenchmark{brench}, num2str(i,'%06d')));
    im = imresize(im, 0.5);
    hf = figure(1); subplot(1,1,1); imshow(im);
        
    text(20, 40, ['#' num2str(i, '%03d')], 'color', [0 0 0], 'FontSize', 20, 'back', [1 1 1]);
    for j = 1 : size(det)           
        rectangle('Position', det(j, 1:4)/2, 'LineWidth', 1, 'EdgeColor', [1 0 0]);
        text(det(j,1)/2, det(j,2)/2, num2str(det(j,5)), 'color', [0 1 0]);
    end
    drawnow;
    if is_save
        result_dir = sprintf('result/train-fastercnn/%s', brenchmark{brench});
        
        if exist(result_dir, 'dir') == 0
            mkdir(result_dir);
        end
        
        filename = sprintf('%s/%06d.png', result_dir, i);
        % hgexport(hf, filename, hgexport('factorystyle'), 'Format', 'png');
        saveas(hf, filename);
    else
%         pause;
    end 
end
