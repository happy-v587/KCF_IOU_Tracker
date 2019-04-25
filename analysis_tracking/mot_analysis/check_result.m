clc;
%% base path
addpath 'ext/devkit'
benchmarkGtDir = 'D:/vm_disk/ubuntu_16.04/track/data/2DMOT2015/train/';
base_path='result/det-faster-rcnn/train/';

%% sort
fprintf('========== %s ========== ', 'sort');
evaluateTracking('seqmap/c1-train.txt',...
    '3thpart/sort/output/', benchmarkGtDir, 'MOT15');

fprintf('========== %s ========== ', 'sort');
evaluateTracking('seqmap/c1-train.txt',...
    'result/det-sort/train/k10-s40-c0.9/', benchmarkGtDir, 'MOT15');

%% iou
fprintf('\n\n========== %s ========== ', 'iou');
% evaluateTracking('result_others/iou/train/c1-train.txt',...
%     'result_others/iou/train/', benchmarkGtDir, 'MOT15');
evaluateTracking('seqmap/c1-train.txt',...
    '3thpart/iou-tracker/result/', benchmarkGtDir, 'MOT15');


%% iou + kcf

names = {};
contents = dir(base_path);
for k = 1:numel(contents),
    name = contents(k).name;
    if isdir([base_path name]) && ~any(strcmp(name, {'.', '..'})),
        t.name = name;  
        t.path = [base_path name '/'];  
        names{end+1} = t;
    end
end

for k = 1:size(names, 2)
    fprintf('========== %s ========== ', names{k}.name);
    evaluateTracking('seqmap/c1-train.txt', names{k}.path, benchmarkGtDir, 'MOT15');    
end
