clear all;
close all;

clear all;
close all;

vs = 34300; %cm/s
omega = 1000.*2.*pi;%Hz
%Grid size
si = 50; %cm
D = zeros(100,100);
Dsize = size(D);
xd = Dsize(1);
yd = Dsize(2);

rs = [2 1];%cm
rn = [-1 0; 0 0; 1 0];%cm
rf = [0 1]
%delta_dist = vecnorm(source_real-mics,2,2);

for x = 1:xd
    for y = 1:yd
        for n = 1:length(rn)
        D(x,y) = D(x,y) + exp(-j.*omega.*vecnorm([x,y]-rn(n),2,2)./vs).*exp(-j.*omega.*vecnorm(rf-rn(n),2,2)./vs);
        end
    end
end






