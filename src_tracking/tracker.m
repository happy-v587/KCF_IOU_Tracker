function tracker(seq, param)
%% tracker
% 已经完成的工作：
%   1. 使用Faster-RCNN 检测目标
%   2. 使用KCF进行目标追踪
%   3. 添加历史信息

global g_id; g_id = 0;

if param.is_train == 1,
gt         =  seq.gt;
end
data       =  seq.data;
video_path =  seq.video_path;

is_save    =  param.is_save;
is_show    =  param.is_show;

trackers   =  cell(0);   
frame      =  1; 
img        =  imread([video_path num2str(frame,'%06d') '.jpg']);

trackers   =  kcf_init(img, frame, data, trackers, param);

if is_save
    write_data(trackers, frame, seq.resultTxt);
end

is_show_det_and_kcf = 0;

for frame = 2 : seq.totalFrame
    disp(['frame=>' num2str(frame) '/' num2str(seq.totalFrame)]);

    % 清理数据
    trackers = trackers_clean(trackers, frame, param);
    
    % 读入图片
    img      =  imread([video_path num2str(frame,'%06d') '.jpg']);   
    
    % 根据上一帧预测
    trackers =  kcf_track(img, frame, trackers);
    
    % 显示Faster-RCNN检测结果和KCF检测结果  
    if is_show_det_and_kcf,
        
        set(gca, 'Position',[0 0 1 1]);
        imshow(img);
        
        text(20, 40, ['#' num2str(frame, '%03d')], 'color', [0 0 0], 'FontSize', 15, 'back', [1 1 1]); 
        
        [det_pos] = format_draw_data(data, frame);
        for aa=1:size(det_pos, 1), rectangle('Position', det_pos(aa,:), 'EdgeColor', [1 0 0], 'LineWidth', 5); end
        
        [kcf_pos] = format_draw_targets(trackers{frame});
        for aa=1:size(kcf_pos, 1), rectangle('Position', kcf_pos(aa,:), 'EdgeColor', [0 1 0], 'LineWidth', 5); end 
                
        drawnow;
        % saveas(gca, ['result/' num2str(frame) '.jpg']);
    end
    
    % 数据关联
    pre_id   =  kcf_nms(img, frame, data, trackers, param);
    
    % 初始化新的追踪器
    trackers =  kcf_init(img, frame, data, trackers, param, pre_id);
    
    if is_save
        write_data(trackers, frame, seq.resultTxt);
    end

    if is_show
        figure(1);
        %set(gcf, 'position', get(0,'ScreenSize') + [50 50 -150 -150]);                  
        plot_pos = { 
            [0.025         0.1 0.3 1]; 
            [0.025*2+0.3   0.1 0.3 1]; 
            [0.025*3+0.3*2 0.1 0.3 1]; };        
        
        if param.is_train == 1,
        subplot(1,3,1,'Position',plot_pos{1}); show_box_gt(img, 'gt',    gt,       frame);
        end       
        subplot(1,3,2,'Position',plot_pos{2}); show_box_dt(img, 'det',   data,     frame);
        subplot(1,3,3,'Position',plot_pos{3}); show_box   (img, 'track', trackers, frame);            
        %pause(0.1);
    end
end

end