% clear;
% % Resursive讀檔
% fileFolder=fullfile('.\DATASET\MOSFET\');
% dirOutput=dir(fullfile(fileFolder,'*.mat'));
% fileNames={dirOutput.name}';
% file_num=size(fileNames);
% fileName_array=string(zeros(file_num(1),1));
% fileName_split_array=string(zeros(file_num(1),5));
% for i=1:file_num(1)
%     s=fileNames{i,1};
%     fileName_array(i,1)=convertCharsToStrings(s);
%     split_file_name=split(fileName_array(i,1),["_",".mat"]);
%     split_size=size(split_file_name);
%     fileName_split_array(i,1:split_size(1))=split_file_name;
% end 
% % 讀單一顆mosfet 資料 可能包含多筆資訊 因為量測資料被拆分 run1 run2......
% read_file_array=string(zeros(10,1));
% j=1;
% for i=1:1:file_num(1)
%    if fileName_split_array(i,2)=="11"
%        read_file_array(j,1)=fileName_array(i,1);
%        j=j+1;
%    end
% end
% j=1;
% 
% %       debug 參數初始化


% % % 開始進行讀取資料 處理 Data Processing............
% for read_i=1:10
%     if(read_file_array(read_i,1)=="0")
%         break;
%     else
%         matfile=read_file_array(read_i,1);
%         disp(string(matfile)+" data processing ......");
%         data = load('.\DATASET\MOSFET\'+matfile,'-mat');
% 
%         
% % % %     %初始化
%         q=size(data.measurement.transient);
%         data_numbers=q(2);% 秒
%         q2=size(data.measurement.transient(1).timeDomain.drainSourceVoltage);
%         transient_sample_scale=q2(2);
%         sample_rate=data.measurement.transient(1).timeDomain.dt;
%         
%         Vds_array= zeros(data_numbers,transient_sample_scale);
%         ID_array= zeros(data_numbers,transient_sample_scale);
%         Gate_signal_array=zeros(data_numbers,transient_sample_scale);
%         
%         Vds_expand_array=zeros(data_numbers*transient_sample_scale,1);
%         ID_expand_array=zeros(data_numbers*transient_sample_scale,1);
%         Gate_signal_expand_array=zeros(data_numbers*transient_sample_scale,1);
% 
% %     % % % DATE 轉換成STRING 並進行 詞的拆解  %獲取aging 的時長
%         test=data.measurement.transient(1).date;
%         a=convertCharsToStrings(test);
%         starttime=split(a,[" ",":"]);
%         start_hr =str2num(starttime(2));
%         start_min=str2num(starttime(3));
%         start_sec=starttime(4);
%         
%         endtime=split(convertCharsToStrings(data.measurement.transient(data_numbers).date),[" ",":"]);
%         end_hr =str2num( endtime(2) );
%         end_min=str2num( endtime(3) );
%         end_sec=endtime(4);
%         
%         duration=(end_hr-start_hr-1)*60+(end_min+60-start_min);
% %       用到 median 相關參數宣告 初始化
% %       medain size 在 3*q(2)~以上會有明顯的綠波效果 
%         med_size=q2(2);
%         vds_buffer=zeros(med_size,1);
%         ID_buffer=zeros(med_size,1);
%         R_buffer=zeros(med_size,1);
% %     % 讀取數據圖轉為二維陣列 
%         
%         for i= 1: data_numbers
%             Vds_array(i,:)=data.measurement.transient(i).timeDomain.drainSourceVoltage;
%             ID_array(i,:)=data.measurement.transient(i).timeDomain.drainCurrent;
%             Gate_signal_array(i,:)=data.measurement.transient(i).timeDomain.gateSignalVoltage;
%         end
% 
% %     % EXPAND 數據圖
%         for i= 1: data_numbers
%             Vds_expand_array((i-1)*transient_sample_scale+1:i*transient_sample_scale,1)=Vds_array(i,:);
%             ID_expand_array((i-1)*transient_sample_scale+1:i*transient_sample_scale,1)=ID_array(i,:);
%             Gate_signal_expand_array((i-1)*transient_sample_scale+1:i*transient_sample_scale,1)=Gate_signal_array(i,:);
%         end
% %     % filter ON STATE 
% %     % compute the average values for both the ON and OFF stages
%         Gate_signal_mean=mean(Gate_signal_expand_array);
%         ON_indices_array=find(Gate_signal_expand_array>=Gate_signal_mean);
%         h=size(ON_indices_array);
%         ON_state_data_numbers=h(1);
%         Vds_expand_array=Vds_expand_array(ON_indices_array);
%         ID_expand_array=ID_expand_array(ON_indices_array);
%         if(read_i==2)
%             ID_debug_ON_array=ID_expand_array;
%         end
%         % % 根據 onstate 數量 create parameter for new array
%         R_array=zeros(ON_state_data_numbers,1);
%         Zk_array=zeros(ON_state_data_numbers,1);
%         R_theta_array=zeros(ON_state_data_numbers,1);
% 
% %        捨去一開始的幾筆資料
%         discard_num=1000*100;
%         Vds_expand_array=Vds_expand_array(discard_num:end,1);
%         ID_expand_array=ID_expand_array(discard_num:end,1);
%         ON_state_data_numbers=ON_state_data_numbers-discard_num+1;
% 
% %         % % % 計算出Rtheta
%         R_array=Vds_expand_array./ID_expand_array;
%         if(read_i==1)
%             R_nominal=R_array(1); % R nominal 定義
%         end
%         Zk_array=R_array-R_nominal;%  Degration resistance =Nominal resistance - Operation resistance
%         R_theta_array=(Zk_array/R_nominal)*1;
% 
%         ON_state_data_before_filt_numbers=ON_state_data_numbers;
% 
% % %     % filter value< mean-sigma  STATE
% %         m_2s_Vds_ind_array=find(Vds_expand_array>=(mean(Vds_expand_array)-1*std(Vds_expand_array)));% Vds 有低峰值 glitch
% %         m_2s_ID_ind_array=find(ID_expand_array<=(mean(ID_expand_array)+1*std(ID_expand_array))); % ID 有 高峰值 glitch
% %         m_2s_R_ind_array=find(R_array>=(mean(R_array)-2*std(R_array)));
% %         [val,pos]=intersect(m_2s_Vds_ind_array,m_2s_ID_ind_array); % 找出 上面兩個 arrary 的交集 
% % %         h1=size(val);
% %         h1=size(m_2s_R_ind_array);
% %         ON_state_data_numbers=h1(1);
% % %         Vds_expand_array=Vds_expand_array(val);
% % %         ID_expand_array=ID_expand_array(val);
% %         Vds_expand_array=Vds_expand_array(m_2s_R_ind_array);
% %         ID_expand_array=ID_expand_array(m_2s_R_ind_array);
% %         R_array=R_array(m_2s_R_ind_array);
% 
% 
% 
% 
% 
%         % % 根據 sigma filter 後 數量 create parameter for new array 用來作中值濾波
%         array_filter_size=floor(ON_state_data_numbers/med_size);
%         Vds_med_array=zeros(array_filter_size,1);
%         ID_med_array=zeros(array_filter_size,1);
% 
%         R_array_filt=zeros(array_filter_size,1);
%         Zk_array_filt=zeros(array_filter_size,1);
%         R_theta_array_filt=zeros(array_filter_size,1);
% 
% 
%         % % median filter 原有的size 會縮小為原本的 1/med_num 
% 
%         j=0;
%         for i= 1: ON_state_data_numbers
%             if (i>=med_size && mod(i,med_size)==0)
%                 for l=1:med_size
%                     vds_buffer(l)=Vds_expand_array(med_size*j+l);
%                     ID_buffer(l)=ID_expand_array(med_size*j+l);
%                 end
%             end
%             if (mod(i,med_size)==0)
%                 j=j+1;
%         % filter type 
%                 Vds_med_array(j,1)=mean(vds_buffer);
%                 ID_med_array(j,1)=mean(ID_buffer);
%             end
%         end
% 
% %         % % % 計算出Rtheta filt
%         j=0;
%         for i= 1: ON_state_data_numbers
%             if (i>=med_size && mod(i,med_size)==0)
%                 for l=1:med_size
%                    R_buffer(l)=R_array(med_size*j+l);
%                 end
%             end
%             if (mod(i,med_size)==0)
%                 j=j+1;
%         % filter type 
%                 R_array_filt(j,1)=mean(R_buffer);
%             end
%         end
% %         R_nominal_filt 定義
%         if(read_i==1)
%             R_nominal_filt=R_array_filt(1);
%         end
%         Zk_array_filt=R_array_filt-R_nominal_filt;
%         R_theta_array_filt=(Zk_array_filt/R_nominal_filt)*1;
% 
% 
% 
% 
% %         % % % array 堆疊
%         if read_i==1
%             duration_t=duration;
%     
%             Vds_expand_array_t=Vds_expand_array;
%             ID_expand_array_t=ID_expand_array;
%             Vds_med_array_t=Vds_med_array;
%             ID_med_array_t=ID_med_array;
%             
%             R_array_t=R_array;
%             R_array_filt_t=R_array_filt;
%             Zk_array_t=Zk_array;
%             Zk_array_filt_t=Zk_array_filt;
%             R_theta_array_t=R_theta_array;
%             R_theta_array_filt_t=R_theta_array_filt;
%             ON_state_data_numbers_t=ON_state_data_numbers;
%             array_filter_size_t=array_filter_size;
%             ON_state_data_before_filt_numbers_t=ON_state_data_before_filt_numbers;
% 
%         else
%             duration_t=duration+duration_t;
% 
%             Vds_expand_array_t=cat(1,Vds_expand_array_t,Vds_expand_array);
%             ID_expand_array_t=cat(1,ID_expand_array_t,ID_expand_array);
%             Vds_med_array_t=cat(1,Vds_med_array_t,Vds_med_array);
%             ID_med_array_t=cat(1,ID_med_array_t,ID_med_array);
%             
%             R_array_t=cat(1,R_array_t,R_array);
%             R_array_filt_t=cat(1,R_array_filt_t,R_array_filt);
%             Zk_array_t=cat(1,Zk_array_t,Zk_array);
%             Zk_array_filt_t=cat(1,Zk_array_filt_t,Zk_array_filt);
%             R_theta_array_t=cat(1,R_theta_array_t,R_theta_array);
%             R_theta_array_filt_t=cat(1,R_theta_array_filt_t,R_theta_array_filt);
%             ON_state_data_numbers_t=ON_state_data_numbers+ON_state_data_numbers_t;
%             array_filter_size_t=array_filter_size+array_filter_size_t;
%             ON_state_data_before_filt_numbers_t=ON_state_data_before_filt_numbers+ON_state_data_before_filt_numbers_t;
%         end
%     end
% end


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
% x=histogram(freq_array(26,:),unique(freq_array(26,:)));
% A = [1 3 5 3 1 5 3 1 1 3 5];
% count = histogram(A,unique(A));
% Y = [1:6];
% max_freq=max(freq_array(26,:));
% min_freq=min(freq_array(26,:));

% %PLOT 原始數據圖
% 
f1 = figure;
subplot(2,1,1);
    x=linspace(0,duration_t,ON_state_data_numbers_t);
    yyaxis left
    plot(x,Vds_expand_array_t,'-b')
    % plotyy(x, Vds_expand_array, x,ID_expand_array);% 沒有 filter 的
    yyaxis right
    plot(x,ID_expand_array_t,'-g')
    hold on;
    plot(x,R_array_t,'-r')
    legend('VDS','ID','R')
    title('原始數據圖 VDS IDS')
% % % % %PLOT
% % % % 自行定義filter 每med num筆 取中間值
% f2 = figure;
if med_size< transient_sample_scale
    x=linspace(0,duration_t,array_filter_size_t);
    disp("med_size< transient_sample_scale")
else
    x=linspace(0,duration_t,array_filter_size_t);
end
subplot(2,1,2);
    yyaxis left
    plot(x,Vds_med_array_t,'-b');
    axis([0 duration_t 0 8]);
    hold on;
    plot(x,ID_med_array_t,'-g');
    yyaxis right
    
    plot(x,R_array_filt_t,'-r');
% axis([0 duration_t 0 ceil(max([max(ID_med_array) max(Vds_med_array)]))]);

title('median filter 後數據 VDS IDS')
legend('VDS filtered','ID filtered','R filtered')

% % % % %PLOT delta R
f2 = figure;
x1=linspace(0,duration_t,ON_state_data_before_filt_numbers_t);
x2=linspace(0,duration_t,array_filter_size_t);
subplot(2,1,1);
% plotyy(x1, R_theta_array, x2,R_theta_array_filt);
    plot(x1, R_theta_array_t,'-b');
    title('delta R')
    legend('delta R')
% % PLOT delta  filter R
% % f4 = figure;
subplot(2,1,2);
    plot(x2, R_theta_array_filt_t,'-r');
    
%     axis([0 duration_t -0.04 0.1]);
    title('delta R filt')
    legend('delta R filt')

% % % % Paper 提供的數據
w=size(dR_realPoint11);
x1=linspace(0,duration_t,w(2));
w9=size(dR_realPoint9);
x2=linspace(0,duration_t,w9(2));
f3 = figure;
    plot(x1, dR_realPoint11,'-b');
%     hold on
%     plot(x2, dR_realPoint9,'-r');
%     title('delta R Paper')
%     legend('delta R11 Paper','delta R9 Paper')
