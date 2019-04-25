function obj = branchmark(brench, param)
%% select branch

obj.brench = brench;

%% branchmark

obj.trainBrenchmark = { 
    'ADL-Rundle-6'; 
    'ADL-Rundle-8'; 
    'ETH-Bahnhof'; 
    'ETH-Pedcross2'; 
    'ETH-Sunnyday'; 
    'KITTI-13'; 
    'KITTI-17'; 
    'PETS09-S2L1'; 
    'TUD-Campus'; 
    'TUD-Stadtmitte'; 
    'Venice-2' 
};

obj.testBranchmark = {
    'ADL-Rundle-1'; 
    'ADL-Rundle-3'; 
    'AVG-TownCentre'; 
    'ETH-Crossing';
    'ETH-Jelmoli'; 
    'ETH-Linthescher'; 
    'KITTI-16'; 
    'KITTI-19'; 
    'PETS09-S2L2';
    'TUD-Crossing'; 
    'Venice-1'  
};

if param.is_train
    obj.branchname = obj.trainBrenchmark{brench};
else
    obj.branchname = obj.testBranchmark{brench};
end

%% base path

obj.trainPathImages = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/img1/%s.jpg';
obj.testPathImages  = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/test/%s/img1/%s.jpg';

obj.trainPathGt     = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/gt/gt.txt';

%% result path

if param.is_train
        
    % obj.trainPathDet = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/%s/det/det.txt';
    % obj.resultPath = 'result/det-base/train/k10-s20-c0';
    
    obj.trainPathDet = 'data/faster-rcnn/train/%s.txt';
    obj.resultPath = sprintf('result/det-faster-rcnn/train/k%.0f-s%.0f-c%.1f', ...
       param.t_track, param.t_same, param.det_score);
    
%     obj.trainPathDet = 'data/sort-det/train/%s.txt';
%     obj.resultPath = 'result/det-sort/train/k10-s40-c0.9';

    if exist(obj.resultPath, 'file') == 0, 
        mkdir(obj.resultPath); 
    end
    
    obj.resultTxt = strcat(obj.resultPath, sprintf('/%s.txt', obj.trainBrenchmark{obj.brench}));
    obj.gt = load(sprintf(obj.trainPathGt, obj.trainBrenchmark{obj.brench}));
    obj.data = load(sprintf(obj.trainPathDet, obj.trainBrenchmark{obj.brench}));
    obj.video_path = sprintf(obj.trainPathImages, obj.trainBrenchmark{obj.brench});
else
    
    obj.testPathDet = 'data/faster-rcnn/test/%s.txt';
    obj.resultPath = sprintf('result/det-faster-rcnn/test/k%.0f-s%.0f-c%.1f', ...
        param.t_track, param.t_same, param.det_score);
    
    if exist(obj.resultPath, 'file') == 0, 
        mkdir(obj.resultPath); 
    end
    
    obj.resultTxt = strcat(obj.resultPath, sprintf('/%s.txt', obj.testBranchmark{obj.brench}));    
    obj.data = load(sprintf(obj.testPathDet, obj.testBranchmark{obj.brench}));
    obj.video_path = sprintf(obj.testPathImages, obj.testBranchmark{obj.brench});
end

obj.totalFrame = max(obj.data(:,1));

end
