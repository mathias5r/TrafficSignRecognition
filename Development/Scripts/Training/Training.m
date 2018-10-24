%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                            *   
% > Author: Mathias Silva da Rosa   
% > Purpose: Training of SVM Classifier     
% > Usage: Create de SVM.mat file for after test   
% > Notes: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

clear;
close all;
clc;

%% Initial settings 

addpath(genpath('../HOG/'));

featureSize = 3780;                     % Descriptor size
trainFolder = '../../Dataset/Training/';
content = dir(trainFolder);
index = find(vertcat(content.isdir));
folders = content(index);
folders = folders(3:end);

%% Getting descriptors and labels

for i = 1:size(folders,1)
    
    path= strcat(trainFolder,folders(i).name,'/Images/Union/*.ppm');
    files = dir(path);
    
    descriptors = zeros(size(files,1),featureSize);
    labels = cell(size(files,1),1);  
    
    for j = 1:size(files,1)
        filePath = strcat(trainFolder,folders(i).name,'/Images/Union/',files(j).name);
        image = imread(filePath);                          
        imageResized = imresize(image,[64 128]);               
        grayImage = rgb2gray(imageResized);                                                    
        featureVector = HogCompute(grayImage,[8 8],9,0); 
        descriptors(j,:) = featureVector;                 
        labels(j) = cellstr(files(j).name(end-4));
    end
    
    SVMModel = fitcsvm(descriptors,labels);
    
    name = strcat('SVM_',folders(i).name,'.mat');
    pathToSVM = strcat(trainFolder,folders(i).name,'/',name);
    save(pathToSVM,'SVMModel');
    
end



