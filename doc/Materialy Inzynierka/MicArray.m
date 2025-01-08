clear all;
close all

%% Decyzja na temat bliskiego, czy dalekiego pola detekcji

% Zależy nam na wykrywaniu drgań w urządzeniach elektronicznych, których rozmiary
% Nie są większe niż 20x20cm. Docelową dokładnością jest ~1cm może mniej.
% Czas propagacji fali dźwiękowej w powietrzu w temperaturze 20* to około
% 343,8m/s. Wizualizacja ma się dziać w paśmie audio. Powiedzmy 20Hz 20kHz
% arbitralnie określone wstępnie. Długości fali dla tych częstotlowości
v = 343.8               %m/s
f1=100;                 %Hz
f2=20e3;                %Hz
lambda1 = v/f1      
lambda2 = v/f2
%Długości fali jakie wychodzą to 17.19m i 0.172m->17.2cm
%Pole dalekie więc odpada. Nawet gdy trochę zwiększymy graniczną
%częstotliwość dolną. Też nam zależy na częstotliwościach >100Hz a dla
%100Hz to nadal 3.5m

%Zostaje więc pole bliskie. 
%Szyk mikrofonów jest ograniczony do jednej płaszczyzny

%Określenie wymaganej rozdzielczości czasowej pomiarów w celu osiągnięcia
%wymaganej dokładności

%Czas pomiarów będzie miał największe znaczenie dla częstotliwości górnych
%detekcji, bo wtedy deltaT będzie się najbardziej przekładała na zmianę
%fazy sygnału długość fali dla częstotliwości 20kHz to 17.2cm
%Zakładana dokładność to ~1cm. 1cm fala dźwiękowa przebywa w czas
accuracy    = 0.01 %[m] 1cm
deltaT      = accuracy/v/2
%Otrzymujemy wymaganą rozdzielczość czasową pomiaru 14us czyli co jest
%osiągalne na tanich systemach mikrokontrolerowych np z wbudowanymi
%przetwornikami ADC STM32L476RGT6 posiadającymi czasy próbkowania tak
%niskie jak paredziesiąt ns. Jednak próbkowane będzie więcej niż jeden
%sygnał więc w rzeczywistości więcej i większym wyzwaniem będzie pewnie
%próbkowanie w tych sygnałów precyzyjnie w danym momencie


%Przykładowy układ mikrofonów w płaszczyźnie 2D
%źródło sygnału sinusoidalnego generowanego izotropowo z pewnego punktu w
%przestrzeni s(t) = sin(2*pi*f*t)

%Sygnał odebrany w pewnej odległości od tego źródła można wyrazić x(t) =
%sin(2*pi*f*(t-d/v)) t to czas d to odległość


% ^          s(t)
% y          
% ^  x--5cm--x--5cm--x
%   --->x
f=100;
fs = 40e3; %Próbkowanie
ts = 1/f; %Czas pomiaru
t = linspace(0,ts,ts*fs);
%xses = linspace(-0.05,0.15,0.01)
xstart = -0.30
ystart = 0
xses = (xstart:0.005:0.30)
yses = (ystart:0.005:0.50)
xiter = 1;
yiter = 1;

%yses = linspace(0,0.20,0.01)
outputStrength = zeros([length(xses) length(yses)])


sourcePosition = [0.025 0.05] ;
sourcePositionONGRAPH = round((sourcePosition+abs([xstart ystart]))*200);
mic1Pos = [0 0] ;
mic1PosONGRAPH = round((mic1Pos+abs([xstart ystart]))*200);
mic2Pos = [0.05 0] ;
mic2PosONGRAPH = round((mic2Pos+abs([xstart ystart]))*200);
mic3Pos = [0.1 0] ;
mic3PosONGRAPH = round((mic3Pos+abs([xstart ystart]))*200);
for x = xses
    for y = yses

sourcePositionlooped = [x y] ;
dS1 = norm(sourcePositionlooped-mic1Pos);
dS2 = norm(sourcePositionlooped-mic2Pos);
dS3 = norm(sourcePositionlooped-mic3Pos);



s1=sin(2*pi*f*(t-dS1/v));
s2=sin(2*pi*f*(t-dS2/v));
s3=sin(2*pi*f*(t-dS3/v));

coeff2 = round(getCoeff_mic(mic1Pos,mic2Pos,fs,v,sourcePosition));
s2_shifted = circshift(s2,coeff2);
s2_shifted([1:coeff2,end+coeff2+1:end]) = 0;

coeff3 = round(getCoeff_mic(mic1Pos,mic3Pos,fs,v,sourcePosition));
s3_shifted = circshift(s3,coeff3);
s3_shifted([1:coeff3,end+coeff3+1:end]) = 0;

%hold on;
%plot(t,s1)
%plot(t,s2_shifted)
%plot(t,s3)
%plot(t,s3_shifted)
%legend()


%Wyrównanie fazy każdego z mikrofonów na częstotliwości f i jednolitego
%dystansu d. W skrócie opis: Jeśli fazy z mikrofonów 1 i 3 są takie same to
%dystans do źródła jest taki sam ETC. Sygnałem o "zerowej fazie jest ten z
%mikrofonu 1" więc jego nie przesuwamy
%Różnica czasu wywodzi się z różnicy dystansu od źródła dźwięku więc

%Jak sygnały są już w fazie, to dokonujemty kowariancji z sygnałem
%pierwszym pozostałych sygnałów i tyle.
%Miara out w faktycznej funkcji położenia źródła 1/(suma różnic faz)

%outputStrength(xiter,yiter) = (norm(conv(s1,flip(s2_shifted))+conv(s1,flip(s3_shifted))));
[c, lags] = xcorr(s1, s2_shifted);
[~, I] = max(abs(c));
timeLag = lags(I);
phaseDifference1 = (timeLag / fs) * f * 360;

[c2, lags2] = xcorr(s1, s3_shifted);
[~, I2] = max(abs(c));
timeLag2 = lags2(I2);
phaseDifference2 = (timeLag2 / fs) * f * 360;

%disp(['Phase Difference: ' num2str(phaseDifference1) ' degrees']);
%disp(['Phase Difference: ' num2str(phaseDifference2) ' degrees']);
outputStrength(xiter,yiter) = abs(phaseDifference1)+abs(phaseDifference2);

yiter=yiter+1;
    end
    yiter = 1;
xiter=xiter+1;
end
outputStrength;

%hold on;
%plot(t,s1)
%plot(t,s2)
%plot(t,s3)


imshow(outputStrength',[]);

axis on;
hold on;
plot(sourcePositionONGRAPH(1)+1,sourcePositionONGRAPH(2)+1, 'r+', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
plot(mic1PosONGRAPH(1)+1,mic1PosONGRAPH(2)+1, 'g+', 'MarkerSize', 10, 'LineWidth', 2);
plot(mic2PosONGRAPH(1)+1,mic2PosONGRAPH(2)+1, 'g+', 'MarkerSize', 10, 'LineWidth', 2);
plot(mic3PosONGRAPH(1)+1,mic3PosONGRAPH(2)+1, 'g+', 'MarkerSize', 10, 'LineWidth', 2);


function timeShiftN = getCoeff_mic(mic1Pos,posMic2,fs,v,pos)
    d1 = norm(mic1Pos-pos);
    d2 = norm(posMic2-pos);
    d = d1-d2;
    timeShiftN = d/v*fs;
end



