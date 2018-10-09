
function [x,y,s] = generalized_hough_transform(image)

%% Convolution loop

    templates = dir('./Templates/*.mat');

    threshold = [40 40 45 45 50 50  ...
                 70 70 75 75 80 80 ...
                 100 100 105 105 110];

    x = [];y = [];s = [];
    for i = 1:size(templates,1)
        pathToTemplates = strcat('./Templates/',templates(i).name);
        templateData = load(pathToTemplates);
        result = conv2(image,templateData.im,'same');
        templateNumber = str2num(templates(i).name(end-6:end-4));
        index = ((templateNumber-20)/5)+1;
        [k,m] = find(result >= threshold(index));
        x = [x k'];
        y = [y m'];
        for j = 1:size(k,1)
            s = [s templateNumber];
        end
    end
end



