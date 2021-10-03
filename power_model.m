clear;
model = 'DAB_IBDC_CONST'; 
open_system(model)
simlog_DAB_IBDC_CONST=sim(model);
lossesCell=pe_getPowerLossTimeSeries(simlog_DAB_IBDC_CONST,0.010,0.025);