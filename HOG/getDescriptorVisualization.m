function visualization = getDescriptorVisualization(image, histogram)
  
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
    
            drawX = (x-1) * 8;
            drawY = (y-1) * 8;
            
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
