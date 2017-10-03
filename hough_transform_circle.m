function [acummulator] = hough_transform_circle(img)

    acummulator = zeros(size(img));
    
    r = 10;
    
    for y = 1 : size(img,2);
        for x = 1 : size(img,1);
            if img(x,y) == 1
                rectangle('Position',[y x 1 1],'EdgeColor','g');
                for theta = 0:(1*pi)/180:2*pi
                    Xc = x - r*cos(theta);
                    Xc = round(Xc);
                    Yc = y - r*sin(theta);
                    Yc = round(Yc);
                    %plotCircle(Xc,Yc,r);
                    if Xc > 0 && Xc <= size(img,1)
                        if Yc > 0 && Yc <= size(img,2)
                            acummulator(round(Xc),round(Yc)) = ...
                                acummulator(round(Xc),round(Yc)) + 1;
                        end
                    end
                    
                end
            end
        end
    end
    
   
    [row,col] = find(acummulator == max(acummulator(:)))
    
    for i=1:size(row)
        plotCircle(col(i),row(i),r);
    end
    
end

function plotCircle(x,y,r)

    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    plot(xunit, yunit,'-r');

end