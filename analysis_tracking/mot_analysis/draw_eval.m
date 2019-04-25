function draw_eval

    close all; clc; 
      
%     iou = readEval('3thpart/iou-tracker/result/eval.txt')
%     sort = readEval('3thpart/sort/output/eval.txt')
%     kcf = readEval('result/det-faster-rcnn/train/k8-s40-c0.9/eval.txt')
    
    base_path = 'result/det-faster-rcnn/train/k8-s40-c0.9/'; 
    out = cell(1,12);
    contents = dir([base_path 'eval*']);    
    for k = 1:numel(contents)
        name = contents(k).name;
        if ~any(strcmp(name, {'.', '..'})),
            t.name = name;  
            t.path = [base_path, name];
            t.data = readEval(t.path);
            out{k} = t;
        end
    end
    
    fprintf('MOTA\tMOTP\tFAR\tMT\tML\tIDS\tFP\tFN\tFM\tNAME\n');
    for i = 1:size(out, 2)
        mat = out{i}.data;
        name = out{i}.name;        
        fprintf('%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%d\t%d\t%d\t%d\t%s\n', ...
                mat.mota, mat.motp, mat.far, mat.mt / mat.gt*100, ....
                mat.ml / mat.gt*100, mat.ids, mat.fp, mat.fn, mat.fm, name);
    end
    
    function [out] = readEval(path)
         % IDF1   IDP   IDR| Rcll   Prcn    FAR|   GT  MT    PT    ML|    FP    FN    IDs     FM|  MOTA   MOTP  MOTAL  
         % 37.2  40.7  34.2| 55.6   66.2   2.06|  500 149   195   156| 11336 17702   1011   1931|  24.7   71.5   27.2  
         % 36.942,48.902,29.683,50.272,82.821,0.75655,500,111,228,161,4161,19844,670,1617,38.166,72.452,39.838
        data = load(path);
        out.idf1 = data(1,1);
        out.idp  = data(1,2);
        out.idr  = data(1,3);
        out.rcll = data(1,4);
        out.prcn = data(1,5);
        out.far  = data(1,6);
        out.gt   = data(1,7);
        out.mt   = data(1,8);
        out.pt   = data(1,9);
        out.ml   = data(1,10);
        out.fp   = data(1,11);
        out.fn   = data(1,12);
        out.ids  = data(1,13);
        out.fm   = data(1,14);
        out.mota = data(1,15);
        out.motp = data(1,16);
        out.motal= data(1,17);
    end

end