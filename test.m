clear;
% ssc_dcmotor
% sim('ssc_dcmotor');
% sscexplore(simlog_ssc_dcmotor)


% model = 'ee_rectifier_power_dissipated';
% open(model)
% sim(model)
% rectifierLosses = ee_getPowerLossSummary(simlog_ee_rectifier_power_dissipated.Rectifier)

model = 'DAB_IBDC_CONST'; 
open_system(model)
sim(model);
% sscexplore(simlog_DAB_IBDC_CONST)
% 
% model = 'DAB_IBDC_simscape';
% open_system(model)
% sim(model);