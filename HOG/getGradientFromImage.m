function [rho,theta] = getGradientFromImage(img)

    gx = zeros(size(img), 'like', img);
    gy = zeros(size(img), 'like', img);
    
    gx(:,2:end-1) = conv2(img, [1 0 -1], 'valid');
    gy(2:end-1,:) = conv2(img, [1;0;-1], 'valid');
    
    % forward difference on borders
    gx(:,1)   = img(:,2)   - img(:,1);
    gx(:,end) = img(:,end) - img(:,end-1);
    
    gy(1,:)   = img(2,:)   - img(1,:);
    gy(end,:) = img(end,:) - img(end-1,:);

    % return magnitude and direction
    rho = hypot(gx,gy);
    theta = atan2d(-gy,gx);

end
