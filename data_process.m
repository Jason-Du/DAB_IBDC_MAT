% clear;
% 讀檔
% matfile='./DATASET/MOSFET/Test_11_run_1.mat';
% data = load(matfile,'-mat');
% %初始化
% data_numbers=39223;% 39223秒
% med_size=500;
% sample_rate=2e-6;
% transient_sample_scale=500;
% Vds_array= zeros(data_numbers,transient_sample_scale);
% ID_array= zeros(data_numbers,transient_sample_scale);
% R_array=zeros(data_numbers,transient_sample_scale);
% Zk_array=zeros(data_numbers,transient_sample_scale);
% R_theta_array=zeros(data_numbers,transient_sample_scale);
% Vds_med_array=zeros(floor((data_numbers*transient_sample_scale)/med_size),1);
% ID_med_array=zeros(floor((data_numbers*transient_sample_scale)/med_size),1);
% R_theta_array_filt=zeros(data_numbers,1);
% Vds_expand_array=zeros(data_numbers*transient_sample_scale,1);
% ID_expand_array=zeros(data_numbers*transient_sample_scale,1);
% 
% vds_buffer=zeros(med_size,1);
% ID_buffer=zeros(med_size,1);
% 
% time=zeros(data_numbers*transient_sample_scale,1);

% 讀取數據圖轉為二為陣列 
% j=0;
% 
% for i= 1: data_numbers
%     Vds_array(i,:)=data.measurement.transient(i).timeDomain.drainSourceVoltage;
%     ID_array(i,:)=10*data.measurement.transient(i).timeDomain.drainCurrent;
% end

% % EXPAND 數據圖
% for i= 1: data_numbers
%     Vds_expand_array((i-1)*500+1:i*500,1)=Vds_array(i,:);
%     ID_expand_array((i-1)*500+1:i*500,1)=ID_array(i,:);
% end
% % median filter 原有的size 會縮小為原本的 1/med_num 倍
% for i= 1: data_numbers*transient_sample_scale
%     if (i>=med_size && mod(i,med_size)==0)
%         for l=1:med_size
%             vds_buffer(l)=Vds_expand_array(med_size*j+l);
%             ID_buffer(l)=ID_expand_array(med_size*j+l);
%         end
%     end
%     if (mod(i,med_size)==0)
%         j=j+1;
%         Vds_med_array(j,1)=median(vds_buffer);
%         ID_med_array(j,1)=median(ID_buffer);
%     end
% end
% 分析資料 VDS值 <4 者
%  k=find(Vds_expand_array<4);
%  length(k)


% % 計算出Rtheta
% R_array=Vds_array./ID_array;
% % R_array=Vds_med_array./ID_med_array;% R mid
% Zk_array=1.98-R_array;%  Degration resistance =Nominal resistance - Operation resistance
% R_theta_array=(Zk_array/1.98)*100;
% for i= 1: data_numbers
%     R_theta_array_filt(i,1)=median(R_theta_array(i,:));
% end

% DATE 轉換成STRING 並進行 詞的拆解  %獲取aging 的時長
% test=data.measurement.transient(1).date;
% a=convertCharsToStrings(test);
% starttime=split(a,[" ",":"]);
% start_hr =str2num(starttime(2));
% start_min=str2num(starttime(3));
% start_sec=starttime(4);
% 
% endtime=split(convertCharsToStrings(data.measurement.transient(data_numbers).date),[" ",":"]);
% end_hr =str2num( endtime(2) );
% end_min=str2num( endtime(3) );
% end_sec=endtime(4);
% 
% duration=(end_hr-start_hr)*60+(end_min+60-start_min);


% Recursive reading the file in the folder
% 讀出frequency sample rate
% data_size=0;
% fileFolder=fullfile('.\DATASET\MOSFET\');
% dirOutput=dir(fullfile(fileFolder,'*.mat'));
% fileNames={dirOutput.name}';
% file_num=size(fileNames);
% freq_array=zeros(file_num(1),39358);
% trasient_size_array=zeros(file_num(1),1);
% for j=1:file_num(1)
%     j
%     matfile='./DATASET/MOSFET/'+convertCharsToStrings(fileNames{j,1});
%     data = load(matfile,'-mat');
%     data_size=data.measurement.transient;
% % GET the transient size in each file
%     y=size(data_size);
%     trasient_size_array(j,1)=y(2);
% 
% % GET the freq in each transient size
%     for k=1:y(2)
%         freq_array(j,k)=data.measurement.transient(k).timeDomain.dt;
%     end
% end
% 繪製histogram 圖形
x=histogram(freq_array(26,:),unique(freq_array(26,:)));
A = [1 3 5 3 1 5 3 1 1 3 5];
count = histogram(A,unique(A));
Y = [1:6];
max_freq=max(freq_array(26,:));
min_freq=min(freq_array(26,:));

% %PLOT
% plotyy(x, Vds_expand_array, x,ID_expand_array);% 沒有 filter 的
% %matlab 定義filter
% x=linspace(0,120,data_numbers*transient_sample_scale);
% plot(x, medfilt1(Vds_expand_array,500));
% hold on;
% plot(x,medfilt1(ID_expand_array,500));

% 自行定義filter 每med num筆 取中間值
% x=linspace(0,duration/((transient_sample_scale)/med_size),(data_numbers*transient_sample_scale/med_size));
% plot(x,Vds_med_array);
% hold on;
% plot(x,ID_med_array);
% axis([0 duration/((transient_sample_scale)/med_size) 0 6]);


