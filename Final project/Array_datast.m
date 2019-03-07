clc
close all;
clear all;
%sturcture中有name這個子結構，其中name的結構為 1*1 cell
file = struct('name',...    
    {'N7-1-25nJ'});


    filename_c = [file.name '-Z' int2str(1) '.mat'];
    load(filename_c);
    %load 進來是3維(x_axis, y_axis, 反覆次數)
    %我們要將這些data建立成四維陣列來包括9個z軸上的資料。
    data(:,:,:) = y;
a=size(data)
data_sum=zeros(100,186);
for i = 1:a(3)
    data_sum(:,:) = data_sum(:,:)+data(:,:,i);
end

data = data_sum;
data_avg = data./a(3);

[x, y] = meshgrid(1:1:186,1:1:100);
%z = data_avg(x,y);
%mesh(x,y,data_avg);hold on;
surf(x,y,data_avg); box on; set(gca,'FontSize', 16); zlabel('z');
%set(gca,color,'r')
colorbar;
colormap(hot);
xlim([-4 4]); xlabel('x'); ylim([-4 4]); ylabel('y');
hold on;
imagesc(data_avg); axis square; xlabel('x'); ylabel('y');