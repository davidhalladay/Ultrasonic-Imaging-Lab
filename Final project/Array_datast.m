clc
close all;
clear all;
%sturcture����name�o�Ӥl���c�A�䤤name�����c�� 1*1 cell
file = struct('name',...    
    {'N7-1-25nJ'});


    filename_c = [file.name '-Z' int2str(1) '.mat'];
    load(filename_c);
    %load �i�ӬO3��(x_axis, y_axis, ���Ц���)
    %�ڭ̭n�N�o��data�إߦ��|���}�C�ӥ]�A9��z�b�W����ơC
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