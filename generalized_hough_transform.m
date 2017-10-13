% Author: Mathias Silva da Rosa
% Generalized Hough Transform
%   Average runtime: 620ms
%   Convolution:
%       50 circles (range of 50x50 to 150x150)         
%       50 hexagons (range of 50x50 to 150x150)      
%       50 lozenges (range of 50x50 to 150x150)      

%% Inicialization 

function [x,y] = generalized_hough_transform(image)

%% Get Image

%     image = imread('./Imagens/teste3.png');
%     image = rgb2gray(image);
%     image = image/255;
%     image = single(image);

%% Convolution loop

    files = dir('./Templates/*.mat');

    for i = 1:size(files,1)
       path = strcat('./Templates/',files(i).name);
       im = load(path);
       result = conv2(image,im.im,'same');
       imshow(uint8(result));
       if max(result(:)) > 200
            files(i).name
            [x,y] = find(result == max(result(:)));
            return;
       end
    end
    
    x = -1;
    y = -1;
    
end



