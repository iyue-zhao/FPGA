



%%  file head  ----------------------------------------------
clear all;clc;close all;
 %%  user setting -------------------------------------------------
img = imread('dpc_patten.png');
%% ----------------------------------------
[m,n,k]=size(img);
u_dat = uint8(img);
if k==1
    print_dat = u_dat' ;
    fid = fopen('dpc_patten.txt','wt');
    for i=1: (m*n) 
        fprintf(fid,'%.2x\n',print_dat(i));  
        end 
    fclose(fid);
    print_img= u_dat ;
	end 
%%  display ---------------------------------------------
figure,
subplot(1,1,1),imshow(print_img);
title('org')
%% ------------------------------------------------------


