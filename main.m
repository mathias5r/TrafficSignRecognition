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

cont = 1;
% Get svms from trained folders
for j = size(svmFolders):-1:1
   if(strcmp(svmFolders(j).name,'.') || strcmp(svmFolders(j).name,'..')) % Remove linux folders
    svmFolders(j) = [];
   else
    svms(cont,1) = load(strcat('./Results/TrainedSVMs/',svmFolders(j).name,'/SVM_',svmFolders(j).name,'.mat'));  
    cont = cont + 1;
   end
end

svms = flipud(svms); % Reverse array to correct order

cont = 1;

disp('Wait for the results');

for k = 1:size(svms)
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
                        results(cont,2) = cellstr(predict(svms(k).SVMModel,descriptor'));
                        cont = cont + 1;
                    end
                end
            end
        end      
    end
    msg = ['Results to svm: ', svmFolders(k).name];
    disp(msg);
    disp(results);
    T = cell2table(results,'VariableNames',{'Sign','Result'});
    writetable(T,strcat('./Results/SVM_',svmFolders(k).name,'.dat'));
end

