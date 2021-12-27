data=R_theta_array_t; %取甚麼data 進行FFT
datasize=size(data);
L=datasize(1);
Fs=1/sample_rate;

Y = fft(data);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

%  畫圖 比較目前 median filter 後的數據圖的 頻譜 與原始頻譜的差異
%  觀察結果應該是要使用low pass filter 會比較合適
f1=figure;
    subplot(2,1,1)
    plot(f,P1) 
    title('Single-Sided Amplitude Spectrum of S(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')

data=dR_realPoint11;%取甚麼data 進行FFT
datasize=size(data);
L=datasize(1);
Fs=1/sample_rate;

Y = fft(data);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


f = Fs*(0:(L/2))/L;
    subplot(2,1,2)
    plot(f,P1) 
    title('Single-Sided Amplitude Spectrum of S(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')


data=R_theta_array_filt_t; % 取 甚麼 data 進去 lowpass high pass 並繪製FFT diagram
data = filter(Num_L,1,data);
datasize=size(data);
L=datasize(1);
Fs=1/sample_rate;

Y = fft(data);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
f2=figure;
    plot(f,P1) 
    title('Single-Sided Amplitude Spectrum of S(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')


f3 = figure;
filt_data=data; % 讀取 low pass high pass filter 與原始資料的比較
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
    plot(x2, filt_data,'-r');
    hold on
    title('delta R filt')
    legend('delta R filt')