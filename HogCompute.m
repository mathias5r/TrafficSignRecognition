function [descriptor] = HogCompute(image,cellSize,bins, signedUnsigned)

%% Getting magnitude and direction of the gradients

original = image;
image = single(image);
[rho,theta] = computeGradient(image);
theta(theta<0) = theta(theta<0)+(180);

%% Gettings the cells

cellsInX = numel(cellSize(1):cellSize(1):size(image,1));
cellsInY = numel(cellSize(2):cellSize(2):size(image,2));
totalCells = cellsInX*cellsInY;

cellsMagnitude = zeros(cellSize(1),cellSize(2),totalCells);
cellsDirection = zeros(cellSize(1),cellSize(2),totalCells);

cell = 1;
for x = 1:cellSize(1):size(image,1)
    for  y = 1:cellSize(2):size(image,2);
        cellsMagnitude(:,:,cell) = rho(x:x+7,y:y+7);
        cellsDirection(:,:,cell) = theta(x:x+7,y:y+7);
        cell = cell + 1;
    end
end

%% Getting the histograms

if(signedUnsigned)
    base = 0:40:320; %signed
else
    base = 0:20:160; %unsigned
end    
    
hist = zeros(totalCells,bins);

for c = 1:totalCells
    for x = 1:cellSize(1)
       for y = 1:cellSize(1)
           pos = ismember(base,cellsDirection(x,y,c)); 
           if any(pos)
               pos = pos*cellsMagnitude(x,y,c);
               hist(c,:) = hist(c,:) + pos;
           else
               d = cellsDirection(x,y,c);
               value = cellsMagnitude(x,y,c)/2;
               switch logical(true)
                   case d > base(1) & d < base(2)
                       [hist(c,1),hist(c,2)] = balance(base(1),base(2),value);
                   case d > base(2) & d < base(3)
                       [hist(c,2),hist(c,3)] = balance(base(2),base(3),value);
                   case d > base(3) & d < base(4)
                       [hist(c,3),hist(c,4)] = balance(base(3),base(4),value);
                   case d > base(4) & d < base(5)
                       [hist(c,4),hist(c,5)] = balance(base(4),base(5),value);
                   case d > base(5) & d < base(6)
                       [hist(c,5),hist(c,6)] = balance(base(5),base(6),value);
                   case d > base(6) & d < base(7)
                       [hist(c,6),hist(c,7)] = balance(base(6),base(7),value);
                   case d > base(7) & d < base(8)
                       [hist(c,7),hist(c,7)] = balance(base(7),base(8),value);
                   case d > base(8) & d < base(9)
                       [hist(c,8),hist(c,9)] = balance(base(8),base(9),value);
                   otherwise
                        if(signedUnsigned)
                            [hist(c,9),hist(c,1)] = balance(base(9),base(1)+360,value);
                        else
                            [hist(c,9),hist(c,1)] = balance(base(9),base(1)+180,value);
                        end
               end
           end
       end
    end
end

%% Mounting the descriptor

descriptor = [];
aux = 1;
histaux = zeros(size(hist));

for k = 1:(totalCells)-17
    if(aux > 15)
        aux = 1;
        k = k +1;
        continue;
    end
    normValue = norm([hist(k,:) ; hist(k+1,:) ; hist(k+16,:) ; hist(k+17,:)]);
    if normValue ~= 0   
        histaux(k,:) = hist(k,:)/normValue;
        histaux(k+1,:) = hist(k+1,:)/normValue;
        histaux(k+16,:) = hist(k+16,:)/normValue;
        histaux(k+17,:) = hist(k+17,:)/normValue;
    end
    descriptor = [descriptor ; histaux(k,:)' ; histaux(k+1,:)' ; histaux(k+16,:)' ; histaux(k+17,:)'];
    aux = aux + 1;
end

%computeVisualization(original,histaux);

end

%%
function [rho,theta] = computeGradient(img)

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

%%
function visualization = computeVisualization(image, histogram)
  
    figure;
    imshow(image)
    hold on;
    grid on;
  
    bins=9;
    base = 0:20:160;
    cell = 1;
    
    M = 64;
    N = 128;
    
    for k = 1:8:M
        x = [1 N];
        y = [k k];
        plot(x,y,'Color','w','LineStyle','-');
        plot(x,y,'Color','k','LineStyle',':');
    end

    for k = 1:8:N
        x = [k k];
        y = [1 M];
        plot(x,y,'Color','w','LineStyle','-');
        plot(x,y,'Color','k','LineStyle',':');
    end
    
    for y=1:8
        for x=1:16
    
            drawX = x * 8;
            drawY = y * 8;
            
            mx = drawX + 8/2;
            my = drawY + 8/2;
            
            for bin=1:bins
                
                angles = (base.*pi)./180;
                angle = angles(:,bin);
                strenght = histogram(cell,bin);
                dirVecX = cos(angle);
                dirVecY = sin(angle);
                maxVecLen = 8/2;
                scale= 2.;

                x1 = mx - dirVecX * strenght * maxVecLen * scale;
                y1 = my - dirVecY * strenght * maxVecLen * scale;
                x2 = mx + dirVecX * strenght * maxVecLen * scale;
                y2 = my + dirVecY * strenght * maxVecLen * scale;

                plot([x1 x2],[y1 y2],'-r');
             
            end
            cell = cell + 1;
        end
    end
end

%%
function [valueInf, valueSup] = balance(inf, sup, value)
    A = sup - value;
    B = value - inf;
    valueInf = A;
    valueSup = B;
end

