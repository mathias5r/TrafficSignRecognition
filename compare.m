path = './Treinamento/30_12.png';

im = imread(path);                           % Leitura da imagem
im = imresize(im,[64 128]);                % Redimencionamento da imagem
im = rgb2gray(im);

imshow(im);
hold on;

[hog,visualization] = extractHOGFeatures(im);

plot(visualization);