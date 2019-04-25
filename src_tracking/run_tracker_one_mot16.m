%% run_tracker
% the main code
% change sub num to exp :
%    t_same   =  20
%    t_track  =  10
%    
%    is_show  =  1
%    is_save  =  1

close all;clc;clear;

addpath('ext/kcf');

param.is_train = 0;
param.is_show = 0;
param.is_save = 1;

param.t_track = 8;
param.t_save = 10;
param.t_same = 40;
param.det_score = 0.01;

tic
for nn = 1:7
    disp(param);
    disp(['***************** ' 'branckmark : ' num2str(nn) ' ******************']);
    seq = branchmark_mot16(nn, param);
    tracker(seq, param);
end
disp(toc)
