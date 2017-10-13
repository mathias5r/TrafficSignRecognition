% clear all;
% close all;
%% 
im = imread('./German/00001.ppm');
% hsv_im = rgb2hsv(im);
% imshow(hsv_im);


im = rgb2gray(im);
figure(1);
imshow(im);
hold on;

%Método 1
%%
im_aux = single(im);
[rho,theta] = computeGradient(im_aux);
theta(theta<0) = theta(theta<0)+(180);
rho = rho > 100;
rho = double(rho);
%%
% 
% summ = sum(rho);
% 
% [col] = find(summ > 150);
% rho(:,col) = 0;
% 
% summ = sum(rho');
% [row] = find(summ > 150);
% rho(row,:) = 0;
% imshow(rho);


[x,y] = generalized_hough_transform(rho)
