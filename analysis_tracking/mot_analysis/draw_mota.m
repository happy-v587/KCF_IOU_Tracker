function draw_mota(num)
    
    if nargin < 1, num = 1; else num = str2num(num); end
    
%     close all;
    
    base_path = 'result/det-faster-rcnn/train/';
    x = [2   4   6   8  ];
    y = [10  20  30  40 ];
    
    filenames = {
        'eval.txt'; ...
        'eval_ADL-Rundle-6.txt'; ...
        'eval_ADL-Rundle-8.txt'; ...
        'eval_ETH-Bahnhof.txt'; ...
        'eval_ETH-Pedcross2.txt'; ...
        'eval_ETH-Sunnyday.txt'; ...
        'eval_KITTI-13.txt'; ...
        'eval_KITTI-17.txt'; ...
        'eval_PETS09-S2L1.txt'; ...
        'eval_TUD-Campus.txt'; ...
        'eval_TUD-Stadtmitte.txt'; ...
        'eval_Venice-2.txt'
    };
    filename = filenames{num};
    z1 = loadResToMat(base_path, '*c0.6', filename);
    z2 = loadResToMat(base_path, '*c0.7', filename);
    z3 = loadResToMat(base_path, '*c0.8', filename);
    z4 = loadResToMat(base_path, '*c0.9', filename);
    
    figure1 = figure;
    set(figure1, 'Name', filename);
    set(gcf,'Position',[500 200 350 250]);
    % mesh meshc meshz
    mesh(x,y,z1, 'LineWidth', 1.5, 'LineStyle', ':');  hold on; 
    mesh(x,y,z2, 'LineWidth', 1.5, 'LineStyle', '--'); hold on; 
    mesh(x,y,z3, 'LineWidth', 1.5, 'LineStyle', '-.'); hold on;
    mesh(x,y,z4, 'LineWidth', 1.5, 'LineStyle', '-');
    colormap([0,0,0])
    set(gca, 'LineWidth', 1);
      
    text(8, 40, z1(4,4)-0.1, '*', 'FontSize', 20);
    text(8.5, 40, z1(4,4)+0.3, num2str(z1(4,4)), 'FontSize', 10, 'FontWeight', 'bold');
    
    text(8, 40, z2(4,4)-0.1, '*', 'FontSize', 20);
    text(8.5, 40, z2(4,4)+0.3, num2str(z2(4,4)), 'FontSize', 10, 'FontWeight', 'bold');
    
    text(8, 40, z3(4,4)-0.1, '*', 'FontSize', 20);
    text(8.5, 40, z3(4,4)+0.3, num2str(z3(4,4)), 'FontSize', 10, 'FontWeight', 'bold');
    
    text(8, 40, z4(4,4)-0.1, '*', 'FontSize', 20);
    text(8.5, 40, z4(4,4)+0.3, num2str(z4(4,4)), 'FontSize', 10, 'FontWeight', 'bold');
       
    view(-15, 5);
    grid minor;
%     axis([1 9 10 40 30 40]);
    xlabel('{\itK}_{lost}');
    ylabel('{\itK}_{same}');
    zlabel('MOTA');
%     title(filename(6:size(filename,2)));
    legend1 = legend('0.6','0.7','0.8','0.9');
    set(legend1,'EdgeColor',[0.999 0.999 0.999]);
    set(gca, 'TickDir', 'in');
    title(legend1, '{\itK}_{score}');
    annotation(figure1,'textbox', [0.1 0.99 0.01 0.01], 'String',{'(a)'}, 'FontSize',10, 'FitBoxToText','off', 'EdgeColor','none');    
    saveas(gcf, 'pic/mota.bmp');    
    
    function [out] = loadResToMat(base_path, type, filename)
        if nargin < 3, filename = 'eval.txt'; end
        contents = dir([base_path type]);
        k2 = loadResBatch(base_path, contents, filename);
        out = zeros([4,4]);        
        for i=1:4
            for j=1:4
                out(i,j) = k2{4*(i-1)+j}.data.mota;
            end
        end 
    end
    
    function [out] = loadResBatch(base_path, contents, filename)
        out = {};
        for k = 1:numel(contents),
            name = contents(k).name;
            if isdir([base_path, name]) && ~any(strcmp(name, {'.', '..'})),
                t.name = name;  
                t.path = [base_path, name, '/' filename];
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