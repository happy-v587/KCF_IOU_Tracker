output_sigma = 20;
sz = [72 105];
[rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
y = exp(-0.5 * (((rs.^2 + cs.^2) / output_sigma^2)));
surf(y,'LineStyle','none');
view([ -90, 90]);
figure
imshow(y);