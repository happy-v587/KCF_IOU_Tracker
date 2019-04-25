function draw_bar_iou_sort_kcf

    close all;
      
    iou = readEval('3thpart/iou-tracker/result/eval.txt');
    sort = readEval('3thpart/sort/output/eval.txt');
    kcf = readEval('result/det-faster-rcnn/train/k8-s40-c0.9/eval.txt');
    
    name = {'MOTA', 'MOTP', 'MT', 'ML', 'IDS', 'FP', 'FN', 'FAF'};
    y_show = [
        iou.mota    sort.mota    kcf.mota;        
        iou.motp    sort.motp    kcf.motp;        
        iou.mt/5    sort.mt/5    kcf.mt/5;
        iou.ml/5    sort.ml/5    kcf.ml/5;
        iou.ids/50  sort.ids/50  kcf.ids/50;
        iou.fp/200  sort.fp/200  kcf.fp/200;
        iou.fn/250  sort.fn/250  kcf.fn/250;
        iou.far*20  sort.far*20  kcf.far*20;
    ];
    y = [
        iou.mota    sort.mota    kcf.mota;        
        iou.motp    sort.motp    kcf.motp;        
        iou.mt      sort.mt      kcf.mt;
        iou.ml      sort.ml      kcf.ml;
        iou.ids     sort.ids     kcf.ids;
        iou.fp      sort.fp      kcf.fp;
        iou.fn      sort.fn      kcf.fn;
        iou.far     sort.far     kcf.far;
    ];
    set(gcf,'Position',[100 100 1200 600]);            
    bar(y_show);
    for i = 1:length(y)
        a = i - 0.35;
        if i == 6 || i == 7, scale = 5; else scale = 3; end
        
        text(a,      y_show(i,1)+2, num2str(y(i,1), scale), 'FontSize', 10);
        text(a+0.25, y_show(i,2)+2, num2str(y(i,2), scale), 'FontSize', 10);
        text(a+0.45, y_show(i,3)+2, num2str(y(i,3), scale), 'FontSize', 10);
    end
    
    set(gca, 'XTickLabel', name);
    set(gca, 'Position',[0.05 0.1 0.92 0.85]);        
%     grid
    legend1 = legend('iou', 'sort', 'our');        
    set(legend1,'EdgeColor',[0.999 0.999 0.999],'Orientation','horizontal','Location','southoutside');
    set(gca, 'Box', 'off');
    xlabel('Evaluation metrics');
    ylabel('Conversion to Unified Scope');
    axis([0 9 0 85]);
    saveas(gcf, 'pic/bar-iou-ssort-kcf.bmp');  

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