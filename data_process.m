% clear;
% matfile='./DATASET/MOSFET/Test_26_run_1.mat';
% data = load(matfile,'-mat');

% data_numbers=39223;% 39223秒
% sample_rate=2e-6;
% transient_sample_scale=500;
% Vds_array= zeros(data_numbers,transient_sample_scale);
% ID_array= zeros(data_numbers,transient_sample_scale);
% time=zeros(data_numbers*transient_sample_scale,1);
% for i= 1: 39223
%     Vds_array(i,:)=data.measurement.transient(i).timeDomain.drainSourceVoltage;
%     ID_array(i,:)=data.measurement.transient(i).timeDomain.drainCurrent;
% end

test=data.measurement.transient(1).date;
a=convertCharsToStrings(test);
b=split(a,[" ",":"]);