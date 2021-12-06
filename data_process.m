% clear;
% matfile='./DATASET/MOSFET/MOSFET/Test_26_run_1.mat';
% data = load(matfile,'-mat');
data_numbers=39223;
Vds_array= zeros(data_numbers,500);
ID_array= zeros(data_numbers,500);
for i= 1: 39223
    Vds_array(i,:)=data.measurement.transient(i).timeDomain.drainSourceVoltage;
    ID_array(i,:)=data.measurement.transient(i).timeDomain.drainCurrent;
end