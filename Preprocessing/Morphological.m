function [result] = Morphological(image)

    %% Fill holes
    filledImage = imfill(image,'holes');
    filledImage = filledImage > 0;

    %% Eroding Image 
    modelA = strel('disk',1,0); 
    binarizedImage = imerode(filledImage,modelA);
       
        
    %% Remove small and big areas
    lowerLimit = 50;
    higgerLimit = 8000;
    sizeThreshold = bwareafilt(logical(binarizedImage),[lowerLimit higgerLimit]);
    
    %% Dilate Image
    seB = strel('disk',2,0);
    result = imdilate(sizeThreshold,seB);
    
end