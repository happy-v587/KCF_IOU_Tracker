function obj = branchmark_mot16(brench, param)
%% select branch

obj.brench = brench;

%% branchmark

obj.trainBrenchmark = { 
    'MOT16-02'; 
    'MOT16-04'; 
    'MOT16-05'; 
    'MOT16-09'; 
    'MOT16-10'; 
    'MOT16-11'; 
    'MOT16-13';     
};

obj.testBranchmark = {
    'MOT16-01'; 
    'MOT16-03'; 
    'MOT16-06'; 
    'MOT16-07'; 
    'MOT16-08'; 
    'MOT16-12'; 
    'MOT16-14'; 
};

if param.is_train
    obj.branchname = obj.trainBrenchmark{brench};
else
    obj.branchname = obj.testBranchmark{brench};
end

%% base path

obj.trainPathImages = '../data/tracking/MOT16/train/%s/img1/%s.jpg';
obj.testPathImages  = './data/tracking/MOT16/test/%s/img1/%s.jpg';

obj.trainPathGt     = '../data/tracking/MOT16/train/%s/gt/gt.txt';

%% result path

if param.is_train
        
    obj.trainPathDet = '../data/tracking/MOT16/train/%s/det/det.txt';    
    obj.resultPath = sprintf('../result1/det-base-mot16/train/k%.0f-s%.0f-c%.1f', ...
       param.t_track, param.t_same, param.det_score);
    
%     obj.trainPathDet = 'data/faster-rcnn/train/%s.txt';
%     obj.resultPath = sprintf('result/det-faster-rcnn/train/k%.0f-s%.0f-c%.1f', ...
%        param.t_track, param.t_same, param.det_score);
    
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
    
%     obj.testPathDet = 'F:/MOT16/test/%s/det/det.txt';    
%     obj.resultPath = sprintf( 'result/det-base-mot16/test/k%.0f-s%.0f-c%.1f', ...
%         param.t_track, param.t_same, param.det_score);
    
    obj.testPathDet = 'data/iou/test/%s.txt';    
    obj.resultPath = sprintf( 'result/det-iou-mot16/test/k%.0f-s%.0f-c%.1f', ...
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
