function [image] = createCircle(s,x,y,r)

[columnsInImage rowsInImage] = meshgrid(1:s(2), 1:s(1));

image = (rowsInImage - y).^2 ...
    + (columnsInImage - x).^2 <= r.^2;
image = imcomplement(image);

end