%
%
%
%
%  file to image .   for gray  
%
%%   ---------------------------------------------------
clear all；clc;close all;
% -------------------------------------------------------
usr_file = 'E:\work\work\DAT\DAT\202311\ISP\DPC\matlab\dpc_patten.txt' ;
% img size 
img_w = 1920;
img_h = 1080;
% -------------------------------------------------------
%%  process ---------------------------------------------
usr_dat    = textscan(usr_file,   '%s'); 
usr_img_dat  =hex2dec(usr_dat);
usr_img = reshape(usr_img_dat, img_w, img_h );
usr_img = uint8(usr_img');
imshow(usr_img);title('user')
imwrite(usr_img,'usr_img.jpg');



