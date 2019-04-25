addpath HOG\pdollar\channels

close all;
im   = imread('HOG_SVM/SingleObject/FudanPed00001_1.png');
fe_h = hog(single(im), 8, 9); 
for i=1 : size(fe_h, 3)
%     figure; imshow(imresize(fe_h(:,:,i), 10));
    imwrite(imresize(fe_h(:,:,i), 10), sprintf('HOG/hog/%02d.jpg', i));
end
% im_h = hogDraw(fe_h, 25); 
% imwrite(im_h, 'HOG/fhog.png');
% imshow(im); figure; imshow(im_h)
% imshow(fe_h(:,:,28))


% im   = imread('HOG_SVM/SingleObject/FudanPed00001_1.png');
% im   = rgb2gray(im);
% imwrite(im, 'HOG/gray.png');

% im   = imread('HOG_SVM/SingleObject/FudanPed00001_1.png');
% imwrite(im(:,:,1), 'HOG/rgb/r.png');
% imwrite(im(:,:,2), 'HOG/rgb/g.png');
% imwrite(im(:,:,3), 'HOG/rgb/b.png');

% im   = imread('HOG_SVM/SingleObject/FudanPed00001_1.png');
% im = rgb2hsv(im);
% imwrite(im(:,:,1), 'HOG/hsv/h.png');
% imwrite(im(:,:,2), 'HOG/hsv/s.png');
% imwrite(im(:,:,3), 'HOG/hsv/v.png');


