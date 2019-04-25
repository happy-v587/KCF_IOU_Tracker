function draw_save_as_csv

    close all;
    
    base_path = 'result/det-faster-rcnn/train/';
    
    mat = cell(0);
    mat(1:16) = loadResToMat(base_path, 'k2*');
    mat(17:32) = loadResToMat(base_path, 'k4*');
    mat(33:48) = loadResToMat(base_path, 'k6*');
    mat(49:64) = loadResToMat(base_path, 'k8*');
    
    save_csv(mat, 'pic/64-exp-res.csv');
    disp('finish');
    
    function save_csv(mat, filename)
        fid = fopen(filename, 'w+');
        fprintf(fid, 'MOTA,MOTP,FAR,MT,ML,IDS,FP,FN,FM\n');
        for i = 1:size(mat,2)
            fprintf(fid, '%f,%f,%f,%f,%f,%d,%d,%d,%d\n', ...
                mat{i}.mota, mat{i}.motp, mat{i}.far, mat{i}.mt, ....
                mat{i}.ml, mat{i}.ids, mat{i}.fp, mat{i}.fn, mat{i}.fm);                
        end
        fclose(fid);       
    end
    
    function [out] = loadResToMat(base_path, type)
        contents = dir([base_path type]);
        k2 = loadResBatch(base_path, contents);
        out = cell(0);        
        for i=1:16            
            out{i} = k2{i}.data;            
        end 
    end
    
    function [out] = loadResBatch(base_path, contents)
        out = {};
        for k = 1:numel(contents),
            name = contents(k).name;
            if isdir([base_path, name]) && ~any(strcmp(name, {'.', '..'})),
                t.name = name;  
                t.path = [base_path, name, '/eval.txt'];
                t.data = readEval(t.path);
                out{end+1} = t;
            end
        end
    end

    function [out] = readEval(path)
         % IDF1   IDP   IDR| Rcll   Prcn    FAR|   GT  MT    PT    ML|    FP    FN    IDs     FM|  MOTA   MOTP  MOTAL  
         % 37.2  40.7  34.2| 55.6   66.2   2.06|  500 149   195   156| 11336 17702   1011   1931|  24.7   71.5   27.2  
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