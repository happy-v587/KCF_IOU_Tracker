function show_tracker_ans

close all; clear;

type = 'test';
brench = 8;

switch type
    case 'gt',
        basepath = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/gt/gt.txt';
        baseimage = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/';
        brenchmark = { 
            'ADL-Rundle-6'; 'ADL-Rundle-8'; 'ETH-Bahnhof'; 'ETH-Pedcross2'; 
            'ETH-Sunnyday'; 'KITTI-13'; 'KITTI-17'; 'PETS09-S2L1'; 'TUD-Campus'; 
            'TUD-Stadtmitte'; 'Venice-2' 
        };
    case 'train',
        basepath = 'F:/mot/kcf_iou/data/faster-rcnn/train/%s.txt';
        % basepath = 'F:/mot/kcf_iou/result/det-faster-rcnn/train/k8-s40-c0.9/%s.txt';
        baseimage = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/';
        brenchmark = { 
            'ADL-Rundle-6'; 'ADL-Rundle-8'; 'ETH-Bahnhof'; 'ETH-Pedcross2'; 
            'ETH-Sunnyday'; 'KITTI-13'; 'KITTI-17'; 'PETS09-S2L1'; 'TUD-Campus'; 
            'TUD-Stadtmitte'; 'Venice-2' 
        };
    case 'test',
        basepath = 'F:/mot/kcf_iou/data/faster-rcnn/test/%s.txt';
        % basepath = 'F:/mot/kcf_iou/result/det-faster-rcnn/test/k8-s40-c0.9/%s.txt';
        baseimage = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/test/%s/img1/';
        brenchmark = {
            'ADL-Rundle-1'; 'ADL-Rundle-3'; 'AVG-TownCentre'; 'ETH-Crossing';
            'ETH-Jelmoli'; 'ETH-Linthescher'; 'KITTI-16'; 'KITTI-19'; 'PETS09-S2L2';
            'TUD-Crossing'; 'Venice-1'  
        };
end

show_one(basepath,baseimage,brenchmark, brench);

function show_one(basepath,baseimage,brenchmark, brench)
    colors = [ 1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1;
    0 1 1; 0.5 0.5 1; 0.5 1 0.5; 1 0.5 0.5; ];

    det = load(sprintf(basepath,brenchmark{brench}));
    path = sprintf(baseimage, brenchmark{brench});
    frame = max(unique(det(:,1)));

    for i = 1 : frame
        disp(['frame  ====> ' num2str(i)]);
        index = find(det(:,1) == i);
        ids = det(index,2);
        rect = det(index,3:6);  
        score = det(index,7);
        index = find(score(:,1)>0.9);
        ids = ids(index);
        rect = rect(index,:);
        filename = num2str(i,'%06d.jpg');    
        im = imread(strcat(path, filename));                
        imshow(im);
        % 绘制第几帧
        text(20, 40, ['#' num2str(i, '%03d')], 'color', [0 0 0], 'FontSize', 20, 'back', [1 1 1]);
        for j = 1 : size(rect)
            pos = rect(j, 1:4);
            color = colors(mod(ids(j), size(colors, 1))+1,:);
            rectangle('Position', pos, 'LineWidth', 1, 'EdgeColor', color);
            text(pos(1), pos(2), num2str(ids(j)), 'color', color);
            text(pos(1), pos(2), num2str(score(j)), 'color', color);
        end
        drawnow;        
    end
end
end



