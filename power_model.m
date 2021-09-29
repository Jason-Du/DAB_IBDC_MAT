model = 'DAB_IBDC_CONST'; 
open_system(model);
sim(model);
lossesCell=pe_getPowerLossTimeSeries(simlog_DAB_IBDC_SPS);