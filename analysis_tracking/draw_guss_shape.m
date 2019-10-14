close all;
output_sigma = 40;
sz = [132 132];
[rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
y = exp(-0.5 * (((rs.^2 + cs.^2) / output_sigma^2)));
mesh(y);
axis off;
% saveas(gca, 'analysis_tracking/gass.jpg');

% cs = cs - 20;
% y = exp(-0.5 * (((rs.^2 + cs.^2) / output_sigma^2)));
% rdm = rand(132, 132);
% figure;mesh(y .* rdm);
% axis off;
% saveas(gca, 'analysis_tracking/gass2.jpg');

img = imread('analysis_tracking/img.png');
spec_img=zeros(132,132,3);
img_temp=rgb2gray(img);
for i=2:132-1
    for j=2:132-1
        spec_img(i,j,:)=double(img(i-1,j-1,:))-double(img(i+1,j+1,:))+128;
    end
end
spec_img = imnoise(spec_img/255);
imshow(spec_img(:,:,1) .* y);figure
spec_img = cos(spec_img)*0.9;
imshow(spec_img(:,:,1) .* y);
saveas(gca, 'analysis_tracking/filter.jpg');
