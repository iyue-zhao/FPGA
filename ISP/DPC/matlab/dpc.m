% Date       : 2023
% author     : qingshuangyimeng 
% function   :  DPC 
% Description:
%
% ---------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------------
clc;clear;close all;
tic;
% ----------------------------------------------------------------------------------------
Thrd_value = 30;
% --------raw parameters-------
raw_dat = imread('dpc_patten.png');
bayerFormat = 'BGGR';            % 
% -----------------------------
[height, width] = size(raw_dat);
bayerPad = zeros(height+4,width+4);
bayerPad(3:height+2,3:width+2) = raw_dat;

%  B  G  B  G  B  G   
%  G  R  G  R  G  R 
%  B  G  B  G  B  G 
%  G  R  G  R  G  R 
%  B  G  B  G  B  G 
%  G  R  G  R  G  R 
for i = 3 : 1 : height
    for j = 3 : 1 : width
        if mod(i,2) == mod(j,2) % R  / B  
			dpc_pad  =  [bayerPad(i-2, j-2)   bayerPad(i-2, j)   bayerPad(i-2, j+2) ... 
			             bayerPad(i,   j-2)                      bayerPad(i,   j+2)   ...
						 bayerPad(i+2, j-2)   bayerPad(i+2, j)   bayerPad(i+2, j+2)]  ; 
		else  % G  
			dpc_pad  =  [                          bayerPad(i-2, j) ...
                 		       bayerPad(i-1, j-1)                    bayerPad(i-1, j+1) ... 
			             bayerPad(i,   j-2)                                bayerPad(i,   j+2)   ...
						       bayerPad(i+1, j-1)                    bayerPad(i+1, j+1)   ...
							                       bayerPad(i+2, j)]  ; 
		end 	
		dpc_delta =  dpc_pad - ones(1, 8) * bayerPad(i, j);
		dpc_med   =  median(dpc_pad);
			if (  (nnz(dpc_delta > 0) == 8 ) || (nnz(dpc_delta < 0) ==  8)) ...
				&  nnz((abs(dpc_delta))> Thrd_value)==8 
				bayerPad(i, j) = dpc_med ;
			end 
	end 
end 
dpc_dat = uint8(bayerPad(3:height+2, 3:width+2));

figure();
%subplot (1,2,1);
imshow(raw_dat);   title('org patten ');
%subplot (1,2,2);
figure();
imshow(dpc_dat);   title('dpc patten');

imwrite(dpc_dat,'dpc_dat.png');




