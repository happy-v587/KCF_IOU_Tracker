I=imResample(single(imread('peppers.png'))/255,[480 640]);
H=hog(I,8,9); 
imshow(I); 
V=hogDraw(H,25); 
figure; imshow(V)