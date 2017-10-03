function [] = hough_transform_line(img)
   
   thetaLimit = 170;
   max_rho = round(size(img,1)*cos(45)+size(img,2)*sin(45));
   positiveAcummulator = zeros(max_rho,thetaLimit/10);
   negativeAcummulator = zeros(max_rho,thetaLimit/10);
   
   for y=1:size(img,2);
      for x=1:size(img,1);
          if img(x,y) > 0
              for theta=1:10:thetaLimit
                 angleInRad = ((theta-1)*pi)/180;
                 rhoValue = round(y*cos(angleInRad)+x*sin(angleInRad));
                 if rhoValue > 0
                     positiveAcummulator(rhoValue,((theta-1)/10)+1) = ...
                         positiveAcummulator(rhoValue,((theta-1)/10)+1) + 1;
                 elseif rhoValue < 0
                     negativeAcummulator(rhoValue*-1,((theta-1)/10)+1) = ...
                         negativeAcummulator(rhoValue*-1,((theta-1)/10)+1) + 1;
                 end
              end
          end
      end
   end

   [rowP,colP] = find(positiveAcummulator > 200);
   [rowN,colN] = find(negativeAcummulator > 200);
   
   imshow(img);
   hold on;
   axis on;
   
   for i=1:size(rowP,1)
       theta = (colP(i)*10)-10;
       theta = (theta*pi)/180;
       c = cos(theta);
       s = sin(theta);
       y1 = (rowP(i)-s)/c;
       y2 = (rowP(i)-size(img,1)*s)/c;
       plot([y1 y2],[1 size(img,1)],'-r');
   end
   
   for i=1:size(rowN,1)
       theta = (colN(i)*10)-10;
       theta = (theta*pi)/180;
       c = cos(theta);
       s = sin(theta);
       y1 = (-1*rowN(i)-s)/c;
       y2 = (-1*rowN(i)-size(img,1)*s)/c;
       plot([y1 y2],[1 size(img,1)],'-r');
   end
   
   hold off;
   
end