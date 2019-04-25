function show_kcf_th

    M = 200;
    N = 1500;
    canvas = zeros(M, N, 3);
    canvas(:,:,1) = 0.2;
    canvas(:,:,2) = 0.2;
    canvas(:,:,3) = 0.2;
    canvas = draw_line(canvas, 75, 50, 50, 50, 27,  [1 1 1]);
    canvas = draw_cow(canvas,  75, 150, 50, 50, 3,  [1 0 0]);
    canvas = draw_rect(canvas, 75, 100, 50, 250, [0 1 0]);
    subplot(2,1,1);imshow(canvas);title('k=1');
    
    canvas = zeros(M, N, 3);
    canvas(:,:,1) = 0.2;
    canvas(:,:,2) = 0.2;
    canvas(:,:,3) = 0.2;
    canvas = draw_line(canvas, 75, 50, 50, 50, 27,  [1 1 1]);
    canvas = draw_cow(canvas,  75, 200, 50, 50, 3,  [1 0 0]);
    canvas = draw_rect(canvas, 75, 100, 50, 250, [0 1 0]);    
    subplot(2,1,2);imshow(canvas);title('k=2');
    
    function canvas = draw_block(canvas, x,y,w,h,c)
        temp = ones(w,h,3);
        temp(:,:,1) = c(1);
        temp(:,:,2) = c(2);
        temp(:,:,3) = c(3);
        canvas(x:x+w-1, y:y+h-1, :) = temp;
    end
    
    function canvas = draw_line(canvas, x, y, w, h, m, c)
        for i=1:m
            canvas = draw_block(canvas, x, y + 50*(i-1) + i, w, h, c*(0.7 + i/m * 0.3));    
        end        
    end

    function canvas = draw_cow(canvas, x, y, w, h, m, c)
        p = y / w;
        for i=1:m
            canvas = draw_block(canvas, x, y + 50*(i-1) + i + p - 1, w, h, c);    
        end        
    end

    function canvas = draw_rect(canvas, x, y, w, h, c)
        canvas(x:x+w-1, y:y+2, 1) = c(1);
        canvas(x:x+w-1, y:y+2, 2) = c(2);
        canvas(x:x+w-1, y:y+2, 3) = c(3);
        
        canvas(x:x+w-1, y+h:y+h+2, 1) = c(1);
        canvas(x:x+w-1, y+h:y+h+2, 2) = c(2);
        canvas(x:x+w-1, y+h:y+h+2, 3) = c(3);
        
        canvas(x:x+2, y:y+h+2, 1) = c(1);
        canvas(x:x+2, y:y+h+2, 2) = c(2);
        canvas(x:x+2, y:y+h+2, 3) = c(3);
        
        canvas(x+w:x+w+2, y:y+h+2, 1) = c(1);
        canvas(x+w:x+w+2, y:y+h+2, 2) = c(2);
        canvas(x+w:x+w+2, y:y+h+2, 3) = c(3);
    end

end