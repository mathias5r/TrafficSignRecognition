%% Clean all variables

clear;
close all;
clc;

%% Init files and databases

addpath(genpath('./Preprocessing/'));
addpath(genpath('./HOG/'));

testImagesType = '*.ppm';
pathToTestImages = './Dataset/Test/'; 
testImages = dir(strcat(pathToTestImages, testImagesType));

cont = 1;

for i = 1:size(testImages,1)

    %% Getting Images
    testImagePath = strcat(pathToTestImages,testImages(i).name);
    testImage = imread(testImagePath); 

    %% HSV Binarization
    HSVimage = HSVbinarization(testImage,[0.960 0.060],225);

    %% Morphological operations
    morphImage = Morphological(HSVimage);

    %% Edge detection
    boardImage = edge(morphImage,'Canny');    
    
    %% Remove Centroids
    finalImage = RemoveCentroids(boardImage);
    
    %% Segmentation
    [x,y,s] = generalized_hough_transform(single(finalImage));

    sign = [];
    for h = 1:size(x,2);
        if(x(h) > 0 && y(h) > 0)
            pointA = x(h) - round(s(h)/2);
            pointB = y(h) - round(s(h)/2);
            if(pointA > 0 && pointB > 0)
                if(pointA+s(h) < size(testImage,1) && pointB+s(h) < size(testImage,2))
                    sign = testImage(pointA:pointA+s(h),pointB:pointB+s(h));
                    pwd2 = strcat('../Dataset/Test/Hough/Limiar6/',testImages(i).name(1:end-4),'-',num2str(h),'.png');
                    imwrite(sign,pwd2);
% 
                    %% Description
                    sign = imresize(sign,[64 128]);
                    descriptor = HogCompute(sign,[8 8],9,0);
                    
                    %% Classification
                    results(cont,1) = cellstr(testImages(i).name);
                    results(cont,2) = cellstr(predict(SVMModel,descriptor'));
                    cont = cont + 1;
                end
            end
        end
    end      
end
toc
% results
