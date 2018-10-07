%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                            *   
% > Author: Mathias Silva da Rosa   
% > Purpose: Training of SVM Classifier     
% > Usage: Create de SVM.mat file for after test   
% > Notes: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

clear;
close all;
clc;

%% Getting HOG methods
addpath(genpath('./HOG/'));
pathToStoreTrainedSVMs = '../../Results/TrainedSVMs/';
   			 
trainingDatasetPath = './Dataset/Training/';
trainingFolders = dir(trainingDatasetPath);
trainingClasses = trainingFolders(3:end); % Removing '.' and '..' links 

HOGFeatureSize = getHOGDescriptorSize([64 128],8,16, 9);

for class = 1:size(trainingClasses,1)
    
    traningImagesPath= strcat(trainingDatasetPath,trainingClasses(class).name,'/Images/Union/*.ppm');
    images = dir(traningImagesPath);
    
    descriptorsList = zeros(size(images,1),HOGFeatureSize);
    descriptorsLabels = cell(size(images,1),1);  
    
    for imageIndex = 1:size(images,1)
        imagePath = strcat(trainingDatasetPath,trainingClasses(class).name,'/Images/Union/',images(imageIndex).name);
        imageVector = imread(imagePath);                          
        imageResized = imresize(imageVector,[64 128]);               
        grayImage = rgb2gray(imageResized);                                                    
        [featureVector,~] = getHOGDescriptor(grayImage,[8 8], 9, 0); 
        descriptorsList(imageIndex,:) = featureVector;                 
        descriptorsLabels(imageIndex) = cellstr(images(imageIndex).name(end-4));
    end
    
    SVMModel = fitcsvm(descriptorsList,descriptorsLabels);
    
    svmModelName = strcat('SVM_',trainingClasses(class).name,'.mat');
    mkdir(strcat(pathToStoreTrainedSVMs,trainingClasses(class).name,'/'));
    pathToSVM = strcat(pathToStoreTrainedSVMs,trainingClasses(class).name,'/',svmModelName);
    save(pathToSVM,'SVMModel');
    
end



