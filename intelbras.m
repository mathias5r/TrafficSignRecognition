clear all;
close all;

for i=1:1000

    % URL to get a camera snapshot
    url='http://192.168.25.221/cgi-bin/snapshot.cgi?1'; 
    img_file='image_cam.jpg';  % temporary file used to store the camera image
    user='admin';       % username and password used to perform authentication
    pass='1';

    % grab the camera image and store it in a local temporary file
    urlwrite(url,img_file,'Authentication','Basic','Username',user,'Password',pass);
    % show the camera image and delete the local temporary file
    imshow(imread(img_file));
    delete(img_file);

end