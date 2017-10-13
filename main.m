clear;
close all;
clc;

pwd = './German/';
files = dir('./German/*.ppm');


for i = 1:size(files,1)

path = strcat(pwd,files(i).name);
im = imread(path);

% R = im(:,:,1)./(im(:,:,1)+im(:,:,2)+im(:,:,3));
% G = im(:,:,2)./(im(:,:,1)+im(:,:,2)+im(:,:,3));
% B = im(:,:,3)./(im(:,:,1)+im(:,:,2)+im(:,:,3));
% 
% im(:,:,1) = R*255;
% im(:,:,2) = G*255;
% im(:,:,3) = B*255;

figure(1);
imshow(im);

im_hsv = rgb2hsv(im);
binhue = (im_hsv(:,:,1) >= 0.942) | (im_hsv(:,:,1) <= 0.085);
binsat = (im_hsv(:,:,2)*255) > 100;
aux = binsat.*binhue;

%%
bigger = bwareafilt(logical(aux),[400 1000]);
biggerA = imfill(bigger,'holes');
biggerB = biggerA > 0;
%%
[rho,theta] = computeGradient(single(biggerB));
figure(2);
imshow(rho)
%%
% [x,y] = generalized_hough_transform(rho);

end
