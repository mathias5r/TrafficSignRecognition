function [ HOGDescriptorSize ] = getHOGDescriptorSize(imageSize,cellsSize,blocksSize,histogramBins)

% HOG descriptor length = Block * CellsPerBlock * BinsPerCell 
blocksInXAxis = ((imageSize(1)/cellsSize)-1);
blocksInYAxis = ((imageSize(2)/cellsSize)-1);
blocks = blocksInXAxis * blocksInYAxis;
cellPerBlock  = (blocksSize^2)/(cellsSize^2);
HOGDescriptorSize = blocks*cellPerBlock*histogramBins;

end

