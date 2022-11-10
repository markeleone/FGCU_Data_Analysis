% Tilt Current Meter Analysis
% By Mark Leone for Adam Catasus (FGCU)
% Created 11/2/2022
% 11/2/2022- added initial code for e/w n/s scatter plots
% 11/8/2022- added code to compare two sites and for outlier removal and
% averaging 

%% Load in Data from CSV

%file = "C:\Users\markl\OneDrive\Desktop\Parsons Lab\PhysicalOce\Edison_TCM_Sept2022.csv";
file = "C:\Users\markl\OneDrive\Desktop\Parsons Lab\PhysicalOce\240 Ledge Tilt Meter (9.2022) - Current Raw Data.xlsx";

tbl = readtable(file, 'NumHeaderLines', 1);

t = table2array(tbl(:,1)); %time, ISO 8601
speed = table2array(tbl(:,2)); %speed, (cm/s)
head = table2array(tbl(:,3)); % heading (degrees)
v = table2array(tbl(:,4)); % velocity-N (cm/s)
u = table2array(tbl(:,5)); % velocity-E (cm/s)

t = cell2mat(t);

dt = datetime(t,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS');

%% Plot Speed over time
figure
scatter(dt,speed,'filled')
xlabel('Time')
ylabel('Speed (cm/s)')
title('240 Ledge Current Speeds Sept 2022')

%% Plot speed over time with U as color axis
f = figure;
c = u;
colormap(f,m_colmap('diverging',256));

scatter(dt,speed,[],c,'filled')
xlabel('Time','FontSize',16)
ylabel('Speed (cm/s)','FontSize',16)
title('240 Ledge Current Speeds September 2022','FontSize',20)
colorbar


h = colorbar('eastoutside'); 
h.FontSize = 18; %h.Ticks = 0.85:0.1:1.15;

ylabel(h,'East speed (cm/s)','FontSize',20);


%% Plot speed over time with V as color axis
f = figure;
c = v;
colormap(f,m_colmap('diverging',256));

scatter(dt,speed,[],c,'filled')
xlabel('Time','FontSize',16)
ylabel('Speed (cm/s)','FontSize',16)
title('240 Ledge Current Speeds September 2022','FontSize',20)
colorbar


h = colorbar('eastoutside'); 
h.FontSize = 18; %h.Ticks = 0.85:0.1:1.15;

ylabel(h,'North speed (cm/s)','FontSize',20);

%% Time averaging across 10 minutes and replotting

% cnt = 0;
% num = 0;
% for i=1:length(speed)
%     cnt = cnt +1;
%     num = num + 10;
%     dtn(cnt) = mean(dt(num:));
%     speedn(cnt) = mean(speed(i:)); 
% end

% removing outlier
[speedm,TFrm] = rmoutliers(speed,"movmedian",minutes(20),"SamplePoints",dt); %'20-min moving median outlier removal'
dtp = dt(~TFrm); %align indices

%time averaging
m = 60; %number of minutes to average over
r = rem(length(dtp),m); % find remainder so we can remove straggling elements
dts = reshape(dtp(1:length(dtp)-r),m,(length(dtp)-r)/m); %reshape vector to matrix 
dtn = mean(dts); %time averaged dt for every m minutes

speeds = reshape(speedm(1:length(speedm)-r),m,(length(speedm)-r)/m); %reshape vector to matrix 
speedn = mean(speeds); %time averaged speed for every m minutes


figure
hold on
scatter(dt,speed,'o')
scatter(dt(~TFrm),speedm,"filled")
plot(dtn,speedn,'-','LineWidth',2,'color',"black")
xlabel('Time')
ylabel('Speed (cm/s)')
legend('1-min resolution (raw)','Outliers Removed','Hourly Average','Location','Northwest')
title('240 Ledge Current Speeds Sept 2022')

%% Edison vs 240 Speeds

efile = "C:\Users\markl\OneDrive\Desktop\Parsons Lab\PhysicalOce\Edison_TCM_Sept2022.csv";

etbl = readtable(efile, 'NumHeaderLines', 1);

et = table2array(etbl(:,1)); %time, ISO 8601
espeed = table2array(etbl(:,4)); %speed, (cm/s)
ehead = table2array(etbl(:,5)); % heading (degrees)
ev = table2array(etbl(:,6)); % velocity-N (cm/s)
eu = table2array(etbl(:,7)); % velocity-E (cm/s)

et = cell2mat(et);

edt = datetime(et,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS');

% Plot Speed over time
figure
hold on
scatter(edt,espeed,'filled')
scatter(dt,speed,'filled')
xlabel('Time','FontSize',14)
ylabel('Speed (cm/s)','FontSize',14)
legend('Edison Reef','240 Ledge','Location','Northwest','FontSize',14)
title('Current Speeds Sept 2022','FontSize',24)

