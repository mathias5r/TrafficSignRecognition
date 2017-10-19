% Limpeza das variáveis
clear;
close all;
clc;
 
% Caminho dos arquivos
pwd = './German/';
files = dir('./German/*.ppm');

for i = 13:size(files,1)

    % Obtendo imagens 
    path = strcat(pwd,files(i).name);
    image = imread(path);
    %imshow(image)

    % Conversão de RGB para HSV
    HSVimage = rgb2hsv(image);
        
    % Binarização da Matiz
    Hue = (HSVimage(:,:,1) >= 0.942) | (HSVimage(:,:,1) <= 0.085);
    %imshow(Hue);
    
    % Binarização e Equalização da Saturação
    HSVimage(:,:,2) = histeq(HSVimage(:,:,2));
    Sat = (HSVimage(:,:,2)*255) > 200;
    %imshow(Sat);
    
    % Matiz x Saturação
    binarizedImage = Sat.*Hue;
    %imshow(binarizedImage);

    % Remoção de área muito pequenas ou muito grandes
    lowerLimit = 800;
    higgerLimit = 8000;
    sizeThreshold = bwareafilt(logical(binarizedImage),[lowerLimit higgerLimit]);
    %imshow(sizeThreshold);
    
    % Dilatação das área restantes
    dilatedAreas = imfill(sizeThreshold,'holes');
    dilatedAreas = dilatedAreas > 0;
    %imshow(dilatedAreas);
    se = strel('disk',4,0);
    dilatedAreas = imdilate(dilatedAreas,se);
    %imshow(dilatedAreas);
     
    % Detecção de borda por Algoritmo Canny
    boards = edge(dilatedAreas,'Canny');
    %imshow(boards)   
    
    stats = regionprops('table',boards,'Centroid',...
    'MajorAxisLength','MinorAxisLength');

    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    
    for j = 1:size(stats,1)
        if radii(j) <= 25 || radii(j) >= 75
            auxImage = createCircle([size(image,1) size(image,2)]...
                                   ,centers(j,1),centers(j,2),radii(j));
            boards = boards.*auxImage; 
            %imshow(boards);
        end
    end
    
    [x,y,s] = generalized_hough_transform(single(boards));

    sign = [];
    if(x(1) > 0 && y(1) > 0)
        pointA = x(1) - round(s/2);
        pointB = y(1) - round(s/2);
        if(pointA > 0 && pointB > 0)
            sign = image(pointA:pointA+s,pointB:pointB+s);
            pwd2 = strcat('./Segmentation/',files(i).name(1:end-4),'.png');
            imwrite(sign,pwd2);
            
            
            teste = imread('teste.png');
            teste = rgb2gray(teste);
            teste = teste > 0;
            teste = imresize(teste,[64 128]);
            descriptor = HogCompute(teste,[8 8],9,0);
        end
    end
    
    
    
      
end
