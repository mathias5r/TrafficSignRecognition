% Author: Mathias Silva da Rosa
% Get picture from a Intelbras Camera specified by IP, user and 
% password.
%   Average runtime: 400ms 

%%
function [picture] =  get_picture(IP,user,password)

    url= strcat('http://',IP,'/cgi-bin/snapshot.cgi?1'); 
    img_file='image_cam.jpg';  % temporary file used to store the camera image
    urlwrite(url,img_file,'Authentication','Basic','Username',user,'Password',password);
    picture = imread(img_file);

end