%% Clean all variables

clear;
close all;
clc;

%% Init files and databases

addpath(genpath('./Preprocessing/'));
addpath(genpath('./Segmentation/'));
addpath(genpath('./HOG/'));

testImagesType = '*.ppm';
pathToTestImages = './Dataset/Test/'; 
testImages = dir(strcat(pathToTestImages, testImagesType));

pathToSVMs = './Results/TrainedSVMs';
svmFolders = dir(pathToSVMs);
svmClasses = trainingFolders(3:end)

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

    segmentedImage = [];
    for localizedPoints = 1:size(x,2);
        if(x(localizedPoints) > 0 && y(localizedPoints) > 0)
            verticalPoint = x(localizedPoints) - round(s(localizedPoints)/2);
            horizontalPoint = y(localizedPoints) - round(s(localizedPoints)/2);
            if(verticalPoint > 0 && horizontalPoint > 0)
                if(verticalPoint+s(localizedPoints) < size(testImage,1) && horizontalPoint+s(localizedPoints) < size(testImage,2))
                    segmentedImage = testImage(verticalPoint:verticalPoint+s(localizedPoints),horizontalPoint:horizontalPoint+s(localizedPoints));
                    pathToResult = strcat('./Results/Test/',testImages(i).name(1:end-4),'-',num2str(localizedPoints),'.png');
                    imwrite(segmentedImage,pathToResult);
% 
                    %% Description
                    segmentedImage = imresize(segmentedImage,[64 128]);
                    descriptor = getHOGDescriptor(segmentedImage,[8 8],9,0);
                    
                    %% Classification
                    results(cont,1) = cellstr(testImages(i).name);
                    results(cont,2) = cellstr(predict(SVMModel,descriptor'));
                    cont = cont + 1;
                end
            end
        end
    end      
end

