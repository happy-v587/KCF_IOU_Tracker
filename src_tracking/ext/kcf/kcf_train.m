function [model_xf, model_alphaf] = kcf_train(im, pos, frame, yf, ...
        model_xf, model_alphaf, window_sz, features, cell_size, ...
        cos_window, kernel, lambda, interp_factor)
    
    if size(im,3) > 1, im = rgb2gray(im); end
    
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