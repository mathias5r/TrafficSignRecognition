im = imread('3P.ppm');
im2 = rgb2gray(im);
result = im2 > 175;


BW = edge(im2,'Sobel');

imshow(BW);