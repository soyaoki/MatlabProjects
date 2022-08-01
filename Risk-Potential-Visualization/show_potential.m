clear;clc;close all;

figure;
U=zeros(50,50);
x_o=10; % X[m]
y_o=10; % Y[m]
yaw=pi/2; % theta[rad]
v=0; % v[m/s]
show_static_risk(U,x_o,y_o);
show_dynamic_risk(x_o,y_o,yaw,v);
plot(x_o,y_o,'ko');hold on;
quiver(x_o,y_o,v*cos(yaw),v*sin(yaw),'LineStyle','-','Color','k')
hold off;grid on;
xlabel('X[m]');ylabel('Y[m]');

dt = 0.1;
omega= pi/18; % [rad/s]
alfa= 3; % [m/s^2]

for t=1:dt:5
    U=zeros(50,50);
    x_o=x_o+v*cos(yaw)*dt; % X[m]
    y_o=y_o+v*sin(yaw)*dt; % Y[m]
    yaw=yaw-omega*dt;
    v=v+alfa*dt;
    show_static_risk(U,x_o,y_o);
    show_dynamic_risk(x_o,y_o,yaw,v);
    plot(x_o,y_o,'ko');hold on;
    quiver(x_o,y_o,v*cos(yaw),v*sin(yaw),'LineStyle','-','Color','k');
    hold off;grid on;
    xlabel('X[m]');ylabel('Y[m]');
    pause(0.1)
end