clear;
close;
%% 
im = imread('00023.ppm');
im = rgb2gray(im);
figure(1);
imshow(im);
hold on;

%Método 1
im_aux = single(im);
[rho,theta] = computeGradient(im_aux);
theta(theta<0) = theta(theta<0)+(180);
rho = rho > 100;
figure;
imshow(rho);
hold on;
axis on;

%%
hough_transform_line(rho);
%aux = hough_transform_circle(rho);
