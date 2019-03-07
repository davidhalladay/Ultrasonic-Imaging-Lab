%%
% 步驟：
% 1. 將數據先經過濾波
% 2. 進行最大值投影(with hilbert transformation)
% 3. removal & gif 製圖
% file size 'N7-1-25nJ' = [100×186×100 double]
%
%%
clc;
close all;
clear all;
fileconame = 'N7-1-25nJ';
filenumber = 1;

Cutsample = 10:170;
DR = 30; 
%fc = 30;                    % MHz, 探頭中心頻率
%fs = 200;                   % required to set up at GageSetup.m
%Vsound = 1500;

%cut-off freq. w1=0.05 , w2=0.40
%window-based FIR filter design 
b =  fir1(50,[0.05 0.40],'bandpass'); 

for i = 1:9
    filename=[fileconame '-Z' int2str(i) '.mat'];
    load(filename);
    %save the 3D array data dim.
    [x_line y_line Nframe] = size(y);
    
    for k = 1:Nframe  %for Nframe=100
        for j = 1:x_line
            
            %在二維陣列中，將每筆資料做bandpass filter濾波，結果為2 dims.
            filt_Data(:,j) = conv(y(j,:,k)',b,'same');  
        end
        %[Maximum projection] 將filt_Data做hilbert transformation
        DM_Data(:,:,k) = abs(hilbert(filt_Data));
        %pickup the sample 10~100 to find the Max. in the each column of a
        %two dim. maxtrix
        project(:,k,i)  = max(DM_Data(Cutsample,:,k));   
    end
end
save(['projection_' fileconame '.mat'],'project')
%%
close all

%save the 3D array data dim.
%%%%%%%%%%%%%%%%%%%%%%%%%%%
	c = 1.5; % mm/us
	fs = 200; % MHz
	dz = fs^-1*c; % mm
    Vpp = 0.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
z_range  = 30;
dx = 160*(Vpp*2)/x_line;  %for Nscanline=100,Vpp=0.5 dx=1.6
dy = 160*(Vpp*2)/y_line;
x_axis = (0:x_line-1)*dx; % mm  % one-dim array 0~160 (not contain 160)
y_axis = (0:y_line-1)*dy;   %2D array 160*160 
z_axis = linspace(0,z_range,Nframe);
dt = 0.2;

DR=30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%

project_max = max(project(:));
project_nor = project/project_max;
%convert mag. to dB type
project_db = mag2db(project_nor);
project_db= project_db + DR;
%找出在經過mag.dB converter & 平移 DR之後，仍然小於0的數字，存取位置，。並設成0。
f = find( project_db <  0 );
project_db(f) =  0;
img_3D = zeros(100,100,Nframe); % img == 3D zero arrays


%filename=['projection_' fileconame '.mat'];
%load(filename)
[Xscanline Yscanline Nframe] = size(project_db);       
for i = 1: Nframe
    A(:,:,i) = fliplr(project_db(:,:,i));
end


temp=A;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
name = ['N7-1-25nJ.gif'];
for n= 1:Nframe
	removal(:,:) = double(bwareaopen(temp(:,:,n),7)); %後面數字控制相連的pixel
	[row column]=find(removal(:,:));
	for i=1:length(row)
        img_3D(row(i),column(i),n)=temp(row(i),column(i),n);
    end            
	image(x_axis,y_axis,img_3D(:,:,n))
	xlabel('X position (μm)','fontsize',16)
	ylabel('Y position (μm)','fontsize',16)
	title([' Z = ' int2str((n-1)*2) 'um'],'fontsize',14)
	colormap(gray(DR));colorbar;
	set(gca,'fontsize',14);
	axis square
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%
	shg  %make the current figure visible and raises it above all other figures.
	drawnow %update figures and processes any pending cakkbacks.
    frame = getframe(1);  %save the frame date in the frame
    im = frame2im(frame); %return img date associated with movie frame
	[imind,cm] = rgb2ind(im,256); %convert RGB img to indexed img
%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if n == 1;
        imwrite(imind,cm,name ,'gif', 'Loopcount',inf,'delaytime',dt);
    else
        imwrite(imind,cm,name ,'gif','WriteMode','append','delaytime',dt);
    end
end
        
                  
%%%%%%%%%%%%%%%%%%%%%%%%reference%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for i = 1:9
%   for n = 1:filenumber
        % fliplr flip array left to right. # size(A)=100,100,3
%       A(:,:,) = fliplr(project_db(:,:,1));
%       temp = [A(:,:,1)+A(:,:,2)+A(:,:,3)]/3
        

%       temp=zeros(100,100);
        
%       figure about temp(average(A))  #A is the flip of project_db
%       figure,image(x_axis,y_axis, temp );
%       colormap(gray(DR));colorbar;
%           xlabel('X position (μm)','fontsize',16);
%           ylabel('Y position (μm)','fontsize',16);
%           title(' figure 1 ');
%           set(gca,'fontsize',14);
%           axis square;
%           hold;
%   end
%end


%              removal = double(bwareaopen(img(:,:,1),9)); %後面數字控制相連的pixel
%                 [row column]=find(removal);
%                 for i=1:length(row)
%                 removal(row(i),column(i))=img(row(i),column(i),n);
%                 end
%                 figure,image(x_axis,y_axis,removal)   
%                 xlabel('X position (μm)','fontsize',16)
%                 ylabel('Y position (μm)','fontsize',16)
%                 title([' Z = ' int2str((n-1)*2) 'um'],'fontsize',14)
%                 colormap(gray(DR));colorbar;
%                 set(gca,'fontsize',14);
%                 axis square+
%                 img(:,:,19)=0.5*img(:,:,19);
%                 figure,image(x_axis,y_axis,img(:,:,19))
%                 xlabel('X position (μm)','fontsize',16)
%                 ylabel('Y position (μm)','fontsize',16)
%                 colormap(gray(DR));colorbar;
%                 set(gca,'fontsize',14);
%                 axis square
          