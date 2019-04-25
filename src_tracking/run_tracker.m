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
conf = config();
param.is_show = conf.is_show;
param.is_save = conf.is_save;

for ii=1:size(conf.t_track, 1)
    param.t_track = conf.t_track{ii};
    param.t_save = conf.t_save{ii};
    for jj=1:size(conf.t_same, 1)
        param.t_same = conf.t_same{jj};
        for kk=1:size(conf.det_score, 1)
            param.det_score = conf.det_score{kk};
            for nn = 6:7
                disp(param);
                disp(['***************** ' 'branckmark : ' num2str(nn) ' ******************']);
                seq = branchmark(nn, param);
                tracker(seq, param);
            end            
        end      
    end
end