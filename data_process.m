% clear;
% 讀檔
% matfile='./DATASET/MOSFET/Test_26_run_1.mat';
% data = load(matfile,'-mat');
% 初始化
data_numbers=39223;% 39223秒
sample_rate=2e-6;
transient_sample_scale=500;
Vds_array= zeros(data_numbers,transient_sample_scale);
ID_array= zeros(data_numbers,transient_sample_scale);
R_array=zeros(data_numbers,transient_sample_scale);
Zk_array=zeros(data_numbers,transient_sample_scale);
R_theta_array=zeros(data_numbers,transient_sample_scale);
Vds_med_array=zeros(data_numbers,1);
ID_med_array=zeros(data_numbers,1);
R_theta_array_filt=zeros(data_numbers,1);
Vds_expand_array=zeros(data_numbers*transient_sample_scale,1);
ID_expand_array=zeros(data_numbers*transient_sample_scale,1);

time=zeros(data_numbers*transient_sample_scale,1);

% 讀取數據圖轉為二為陣列
for i= 1: data_numbers
    Vds_array(i,:)=data.measurement.transient(i).timeDomain.drainSourceVoltage;
    ID_array(i,:)=10*data.measurement.transient(i).timeDomain.drainCurrent;
    Vds_med_array(i,1)=median(data.measurement.transient(i).timeDomain.drainSourceVoltage);
    ID_med_array(i,1)=median(data.measurement.transient(i).timeDomain.drainCurrent);
end
% EXPAND 數據圖
for i= 1: data_numbers
    Vds_expand_array((i-1)*500+1:i*500,1)=Vds_array(i,:);
    ID_expand_array((i-1)*500+1:i*500,1)=ID_array(i,:);
end
%PLOT
x=linspace(0,120,data_numbers*transient_sample_scale);
plotyy(x, Vds_expand_array, x,ID_expand_array); 
% % 計算出Rtheta
% R_array=Vds_array./ID_array;
% % R_array=Vds_med_array./ID_med_array;% R mid
% Zk_array=1.98-R_array;%  Degration resistance =Nominal resistance - Operation resistance
% R_theta_array=(Zk_array/1.98)*100;
% for i= 1: data_numbers
%     R_theta_array_filt(i,1)=median(R_theta_array(i,:));
% end

% DATE 轉換成STRING 並進行 詞的拆解
% test=data.measurement.transient(1).date;
% a=convertCharsToStrings(test);
% b=split(a,[" ",":"]);

% Recursive reading the file in the folder 讀出frequency sample rate
% fileFolder=fullfile('.\DATASET\MOSFET\');
% dirOutput=dir(fullfile(fileFolder,'*.mat'));
% fileNames={dirOutput.name}';
% g=size(fileNames);
% freq_array=zeros(g(1),1);
% for j=1:g(1)
%     j
%     matfile='./DATASET/MOSFET/'+convertCharsToStrings(fileNames{j,1});
%     data = load(matfile,'-mat');
%     freq_array(j,1)=data.measurement.transient(1).timeDomain.dt;
% end


