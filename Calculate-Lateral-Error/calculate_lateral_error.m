clear;clc;close all;

% Splineで目標コース点を生成
Start = [1,1];
Mid = [5, 10];
End = [10,5];
dx = [0:.25:10];
dy = spline([Start(1,1),Mid(1,1),End(1,1)],[Start(1,2),Mid(1,2),End(1,2)],dx);
Line = [dx', dy']

% 自車の位置情報
X = 2;
Y = 7;
theta = 60;

% 前方注視距離
l_pp = 5;

% 前方注視点
X_pp = X + l_pp * cos(deg2rad(theta));
Y_pp = Y + l_pp * sin(deg2rad(theta));

% 点と直線の距離
a = 1/tan(deg2rad(theta));
b = 1;
c = -(a*X_pp+Y_pp);
d = abs(a*Line(:,1) + b*Line(:,2) + c) / sqrt(a*a + b*b)
[~, index] = min(d)

% 図示
figure
plot(X, Y, 'o');
hold on
grid on
plot(dx, dy, 'o');
plot(X_pp, Y_pp, 'o');
plot([X,X_pp],[Y,Y_pp],'k:')
plot(dx(index),dy(index),'o')
plot([X_pp,dx(index)],[Y_pp,dy(index)],'k--')
xlim([0 12])
ylim([0 12])
xlabel('X[m]')
ylabel('Y[m]')
legend('Ego Vehicle', 'target path', 'Preview Point', 'Ego Vehicle Orientation', 'nearest point', 'vertilcal line')