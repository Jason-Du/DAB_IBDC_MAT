
time=out.logsout{1}.Values.Time;
signal_num=2;
Charge=0;
Current=0;
ESR_Voltage=0;
Cross_Voltage=0;
Source_Voltage=0;
for i =1:signal_num
     if (out.logsout{i}.Name=="Charge")
         Charge=out.logsout{i}.Values.Data;
       %  disp(["GeT",num2str(i)])
     elseif(out.logsout{i}.Name=="I")
         Current=out.logsout{i}.Values.Data;
     elseif(out.logsout{i}.Name=="V_Cross")
         Cross_Voltage=out.logsout{i}.Values.Data;
     elseif(out.logsout{i}.Name=="V_Source")
         Source_Voltage=out.logsout{i}.Values.Data;
     elseif(out.logsout{i}.Name=="V_ESR")
         ESR_Voltage=out.logsout{i}.Values.Data;
     end    
end
