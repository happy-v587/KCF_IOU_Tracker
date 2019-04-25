function draw_fp_score_9

    close all;
    
    set(gcf,'Position',[500 200 450 350]);
       
    base_path = 'result/det-faster-rcnn/train/';
    
    x = [10  20  30  40 ];
    y1 = loadResToMat(base_path, 'k2*c0.9');
    y2 = loadResToMat(base_path, 'k4*c0.9');
    y3 = loadResToMat(base_path, 'k6*c0.9');
    y4 = loadResToMat(base_path, 'k8*c0.9');
    
    plot(x,y1,'--k*', 'LineWidth', 1.5);
    hold on        
    plot(x,y2,'-.ko', 'LineWidth', 1.5);
    hold on    
    plot(x,y3,':k*' , 'LineWidth', 1.5);
    hold on    
    plot(x,y4,'-ko' , 'LineWidth', 2);      
   
    
    legend1 = legend('2','4','6','8');
%     axis([8 43 650 950 ]);
    title(legend1, 'k_{lost}');
    xlabel('k_{same}');
    ylabel('IDS');
    grid minor;
    
    saveas(gcf, 'pic/fp-score-9.bmp');
    
    function [out] = loadResToMat(base_path, type)
        contents = dir([base_path type]);
        k2 = loadResBatch(base_path, contents);
        out = zeros([1,4]);        
        for i=1:4
            out(1,i) = k2{i}.data.fp;
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