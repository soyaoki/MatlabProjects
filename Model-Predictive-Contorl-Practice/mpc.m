clear
close all
clc

%% 初期値
x=0
y=0
phi=0
v=0
dt=0.1
N=10
Lf = 1.5
steer_init=0
acc_init=0

ref_y=1 % [m]
ref_v=10 % [m/s]

%% 最適化
figure(2)
plot(x,y,'o')
xlabel('X[m]')
ylabel('Y[m]')
hold on;
xlim('auto')
ylim([0 ref_y+1])

figure(3)
subplot(411)
plot(0,steer_init,'o')
title('steer')
hold on
subplot(412)
plot(0,acc_init,'o')
title('acc')
hold on
subplot(413)
plot(0,v,'o')
title('vel')
hold on
subplot(414)
plot(0,phi,'o')
title('phi')
hold on
%%
for t=dt:dt:10
    count = 0;
    result=[];
%%%%%%%% 力技 %%%%%%%%
%     while count < 100
%         acc = acc_init + [0 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5];
%         acc = lowpass(acc,1,1/dt);
%         steer = steer_init + [0 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5 rand()-0.5];
%         steer = lowpass(steer,1,1/dt);
%         [val, x_hist, y_hist, phi_hist, v_hist] = calculate_control_mpc(x, y, phi, v, steer, acc, dt, N, Lf, ref_y, ref_v);
%         result=[result; val, acc, steer, x_hist, y_hist, v_hist];
%         count = count + 1;
%     end
%     
%     [~, indx] = min(result(:,1));
%     
%     figure(1)
%     subplot(411)
%     plot(result(indx,2:11)) % acc
%     title('acc')
%     subplot(412)
%     plot(result(indx,12:21)) % steer
%     title('steer')
%     subplot(413)
%     plot(result(indx,22:31),result(indx,32:41))  % x and y
%     title('x-y')
%     subplot(414)
%     plot(result(indx,42:51))  % v
%     title('vel')
%     
%     steer_init = result(indx,13);
%     acc_init = result(indx,3);
    
%%%%%%%% fmincon %%%%%%%%
    fun = @(in)for_fmincon(in, x, y, phi, v, dt, N, Lf, ref_y, ref_v)
    in0 = [zeros(N,1)+steer_init; zeros(N,1)+acc_init];
    options = optimoptions('fmincon','OptimalityTolerance',1e-30,'StepTolerance',1e-10000);
%     [in, fval] = fmincon(fun,in0,[],[]);
    [in, fval] = fmincon(fun,in0,[],[],[1 zeros(1,2*N-1);zeros(1,N) 1 zeros(1,N-1)],[steer_init,acc_init],zeros(N,2)-1,zeros(N,2)+1,[],options);
    fval
    steer_init = in(2);
    acc_init = in(N+2);
    [x, y, phi, v] = calculate_next(x, y, phi, v, steer_init, acc_init, Lf, dt );
    figure(1)
    subplot(211)
    plot(in(N+1:2*N)) % acc
    title('acc')
    subplot(212)
    plot(in(1:N)) % steer
    title('steer')
    
    figure(2)
    plot(x, y, 'o')

    figure(3)
    subplot(411)
    plot(t,steer_init,'o')
    hold on
    subplot(412)
    plot(t,acc_init,'o')
    hold on
    subplot(413)
    plot(t,v,'o')
    hold on
    subplot(414)
    plot(t,phi,'o')
    hold on
    
    pause(1)
end

function [val, x_hist, y_hist, phi_hist, v_hist] = calculate_control_mpc(x, y, phi, v, steer, acc, dt, N, Lf, ref_y, ref_v)
    
    x_hist=zeros(1,10);
    y_hist=zeros(1,10);
    phi_hist=zeros(1,10);
    v_hist=zeros(1,10);
    
    for i=1:1:N
        
        x = x + v * cos(phi) * dt;
        y = y + v * sin(phi) * dt;
        phi = phi + v/Lf * steer(i) * dt;
        v = v + acc(i);        
        
        x_hist(i) = x;
        y_hist(i) = y;
        phi_hist(i) = phi;
        v_hist(i) = v;
    end
    
    val = 100*sum((y_hist - ref_y).^2) + 10*sum((v_hist - ref_v).^2) + 10*sum((diff(steer)).^2) + 10*sum((diff(acc)).^2) + 10*sum(v_hist/Lf.*steer) + 10*sum(phi_hist);
    
end

function [x, y, phi, v] = calculate_next(x, y, phi, v, steer, acc, Lf, dt )
    x = x + v * cos(phi) * dt;
    y = y + v * sin(phi) * dt;
    phi = phi + v/Lf * steer(1) * dt;
    v = v + acc(1);
end

function out = for_fmincon(in, x, y, phi, v, dt, N, Lf, ref_y, ref_v)
    x_hist=zeros(1,10);
    y_hist=zeros(1,10);
    phi_hist=zeros(1,10);
    v_hist=zeros(1,10);
    steer = in(1:N);
    acc = in(N+1:2*N);
    
    for i=1:1:N
        
        x = x + v * cos(phi) * dt;
        y = y + v * sin(phi) * dt;
        phi = phi + v/Lf * steer(i) * dt;
        v = v + acc(i);
        
        x_hist(i) = x;
        y_hist(i) = y;
        phi_hist(i) = phi;
        v_hist(i) = v;
    end
    
%     out = 100*sum((y_hist - ref_y).^2) + 10*sum((v_hist - ref_v).^2) + 10*sum((diff(steer)).^2) + 10*sum((diff(acc)).^2) + 10*sum(v_hist/Lf.*steer') + 10*sum(phi_hist);
    d = [sum((y_hist - ref_y).^2) sum((v_hist - ref_v).^2) sum((diff(steer)).^2) sum((diff(acc)).^2) sum(abs(v_hist/Lf.*steer')) sum((0 - phi_hist).^2)]
    w = [10 10 10 10 10 10]';
    out = d*w;
    
end

