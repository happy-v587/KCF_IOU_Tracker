clc;
%% base path
addpath 'ext/devkit'
benchmarkGtDir = 'F:/MOT16/train/';
base_path='result/det-base-mot16/train/';

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
    evaluateTracking('seqmap/MOT16.txt', names{k}.path, benchmarkGtDir, 'MOT16');    
end
