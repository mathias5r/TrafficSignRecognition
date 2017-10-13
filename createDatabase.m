clear all;
close all;
clc;
%%

for i=1:10000
    try
        image = get_picture('192.168.25.237','admin','admin');
        pwd = strcat('./Database/image',num2str(i),'.jpg');
        imshow(image);
        imwrite(image,pwd);
    catch
    end
end