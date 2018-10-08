
function [x,y,s,name] = generalized_hough_transform(image)

%% Convolution loop

    files = dir('../Templates/*.mat');

    threshold = [40 40 45 45 50 50  ...
                 70 70 75 75 80 80 ...
                 100 100 105 105 110];

    x = [];y = [];s = [];
    for i = 1:size(files,1)
        path = strcat('../Templates/',files(i).name);
        im = load(path);
        result = conv2(image,im.im,'same');
        %imshow(uint8(result));
        %max(result(:))
        templateNumber = str2num(files(i).name(end-6:end-4));
        index = ((templateNumber-20)/5)+1;
        %files(i).name
        [k,m] = find(result >= threshold(index));
        x = [x k'];
        y = [y m'];
        for j = 1:size(k,1)
            s = [s templateNumber];
        end
    end
end



