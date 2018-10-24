function [result] = RemoveCentroids(image)
    
    stats = regionprops('table',image,'Centroid',...
    'MajorAxisLength','MinorAxisLength');

    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    
    for j = 1:size(stats,1)
        if radii(j) <= 20 || radii(j) >= 75
            auxImage = createCircle([size(image,1) size(image,2)]...
                                   ,centers(j,1),centers(j,2),radii(j));
            image = image.*auxImage; 
        end
    end

    result = image;
    
end