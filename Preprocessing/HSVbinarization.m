function [result] = HSVbinarization(image,hueThresholds,satThreshold)

    % Converting imagem from RGB to HSV
    HSVimage = rgb2hsv(image);
        
    % Hue binarization
    Hue = (HSVimage(:,:,1) >= hueThresholds(1)) |...
          (HSVimage(:,:,1) <= hueThresholds(2));
          
    % Sat equalization and binarization
    satEq = histeq(HSVimage(:,:,2)); 
    Sat = (satEq*255) > satThreshold;    
   
    % Result
    result = Sat.*Hue;
end