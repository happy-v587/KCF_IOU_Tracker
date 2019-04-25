function [pos, time, model_xf, model_alphaf] = kcf(img, pos, ...
    kernel, lambda, interp_factor, cell_size, features, ...
    frame, yf, model_xf, model_alphaf, window_sz, cos_window)

if size(img,3) > 1, img = rgb2gray(img); end

tic()
if frame > 1,
[pos] = predict(img, pos, model_xf, model_alphaf, window_sz, ...
    features, cell_size, cos_window, kernel);
end
[model_xf, model_alphaf] = train(img, pos, frame, yf, ...
    model_xf, model_alphaf, window_sz, features, cell_size, ...
    cos_window, kernel, lambda, interp_factor);
time = toc();

function [model_xf, model_alphaf] = train(im, pos, frame, yf, model_xf, model_alphaf, ...
    window_sz, features, cell_size, cos_window, kernel, lambda, interp_factor)

    patch = get_subwindow(im, pos, window_sz);
    xf = fft2(get_features(patch, features, cell_size, cos_window));

    switch kernel.type
        case 'gaussian',
            kf = gaussian_correlation(xf, xf, kernel.sigma);
        case 'polynomial',
            kf = polynomial_correlation(xf, xf, kernel.poly_a, kernel.poly_b);
        case 'linear',
            kf = linear_correlation(xf, xf);
    end
    
    alphaf = yf ./ (kf + lambda);   %equation for fast training

    if frame == 1,  %first frame, train with a single image
        model_alphaf = alphaf;
        model_xf = xf;
    else
        %subsequent frames, interpolate model
        model_alphaf = (1 - interp_factor) * model_alphaf + interp_factor * alphaf;
        model_xf = (1 - interp_factor) * model_xf + interp_factor * xf;
    end
end

function [pos] = predict(im, pos, model_xf, model_alphaf, window_sz, features,...
    cell_size, cos_window, kernel)

    ppatch = get_subwindow(im, pos, window_sz);        
    zf = fft2(get_features(ppatch, features, cell_size, cos_window));

    switch kernel.type
        case 'gaussian',
            kzf = gaussian_correlation(zf, model_xf, kernel.sigma);
        case 'polynomial',
            kzf = polynomial_correlation(zf, model_xf, kernel.poly_a, kernel.poly_b);
        case 'linear',
            kzf = linear_correlation(zf, model_xf);
    end
    
    response = real(ifft2(model_alphaf .* kzf));  %equation for fast detection

    [vert_delta, horiz_delta] = find(response == max(response(:)), 1);
    
    if vert_delta > size(zf,1) / 2,  %wrap around to negative half-space of vertical axis
        vert_delta = vert_delta - size(zf,1);
    end
    
    if horiz_delta > size(zf,2) / 2,  %same for horizontal axis
        horiz_delta = horiz_delta - size(zf,2);
    end
    
    pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
    
end

end