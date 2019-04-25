im1 = imread('pic/1.png');
im2 = imread('pic/2.png');

im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

[m, n, c] = size(im1)
im2 = imresize(im2, [m, n]);

diff = abs(im1 - im2);
mean(mean(diff))

imwrite(diff, 'pic/1-2-diff.png');

diff(diff < 20) = 0;
imwrite(diff, 'pic/1-2-diff-20.png');

diff(diff < 40) = 0;
imwrite(diff, 'pic/1-2-diff-40.png');

diff(diff < 60) = 0;
imwrite(diff, 'pic/1-2-diff-60.png');
