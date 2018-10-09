clear all;


    im = imread('./Aux/circulo25.png');
    im = rgb2gray(im);
    %im = imresize(im,[35 35]);
    im = im > 100;
    imshow(im);
    im = double(im);
    path = strcat('circulo025','.mat');
    save(path,'im');