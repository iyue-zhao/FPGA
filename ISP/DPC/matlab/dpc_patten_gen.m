% -----------------------------------------
clc;clear;close all;
tic;
% -----------------------------------------
% patten generate 
for i=1:1080 
    for j=1:1920 
        rand_dat = randi([120,150]);
        %insert dead pixels 
        if (i == 100 | i== 200 | i == 300 | i== 400 | i == 500 | i== 600) ...
												&(j==100 | j == 111)
												
            rand_dat = 250 ;
        elseif   (i == 1 )&(j==2 )
            rand_dat = 100 ;
        elseif (i == 100 | i== 200 | i == 300 | i== 400 | i == 500 | i== 600)...
		                                        &(j==131 | j == 140)
												
            rand_dat = 10 ;
        end 
        patten(i,j)= rand_dat ;
    end
end

patten = uint8(patten);
figure ;
imshow(patten);
imwrite(patten,'dpc_patten.png');









