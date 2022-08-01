%Vehicle Params
m=1500;
I=2500;
lf=1.1;
lr=1.6;
l=lf+lr;
Kf=55000; Kr=60000;
cf=Kf; cr=Kr;
V=100/3.6;
A=-m*(lf*Kf-lr*Kr)/2/l/l/Kr/Kf;
n=18.7;
tau=0.1;

%状態方程式マトリクス
a11=-2*(cf+cr)/m;
a12=-1-2*(lf*cf-lr*cr)/m;
a21=-2*(lf*cf-lr*cr)/I;
a22=-2*(lf*lf*cf+lr*lr*cr)/I;
b11=2*cf/m;
b21=2*lf*cf/I;

%Steering
y0=2.0; 
tp=0.5; %前方注視時間
lp=tp*V; %前方注視距離
h1=2*V/lp/lp; %横位置偏差から目標ヨーレイト
h=(1+A*V*V)*l/V; %目標ヨーレイトから目標舵角

% 一次予測モデル（y_des → y_c）
num = [0 h1*V]
den = [tau 1 h1*V*lp h1*V]

sys_near = tf(num,den)

% 一次予測モデル（y_des → y_c）
tp=0.5*3; %前方注視時間
lp=tp*V; %前方注視距離
h1=2*V/lp/lp; %横位置偏差から目標ヨーレイト
h=(1+A*V*V)*l/V; %目標ヨーレイトから目標舵角

num = [0 h1*V]
den = [tau 1 h1*V*lp h1*V]

sys_far = tf(num,den)

% 極の表示
figure
pzplot(sys_near, sys_far)

% ???
figure
rlocus(sys_near)
figure
rlocus(sys_far)

% bode線図
figure
bode(sys_near)
figure
bode(sys_far)

% ステップ応答
step(sys_near,sys_far)

% 安定余裕
disp("statily of near model")
marg = allmargin(sys_near);
GainMargins_dB = mag2db(marg.GainMargin)
marg.PhaseMargin

disp("statily of far model")
marg = allmargin(sys_far);
GainMargins_dB = mag2db(marg.GainMargin)
marg.PhaseMargin

%%
%Vehicle Params
m=1500;
I=2500;
lf=1.1;
lr=1.6;
l=lf+lr;
Kf=55000; Kr=60000;
cf=Kf; cr=Kr;
V=100/3.6;
A=-m*(lf*Kf-lr*Kr)/2/l/l/Kr/Kf;
n=18.7;
tau=0.1;

%状態方程式マトリクス
a11=-2*(cf+cr)/m;
a12=-1-2*(lf*cf-lr*cr)/m;
a21=-2*(lf*cf-lr*cr)/I;
a22=-2*(lf*lf*cf+lr*lr*cr)/I;
b11=2*cf/m;
b21=2*lf*cf/I;
G_d2g = 5 % turned
G1 = 2.5 % [rad/m]
G2 = -1.5 % [rad*s/m]
tau = 0.1 % [s]
V = 30/3.6 % [m/s]

num = [0 V*G_d2g*G1/n]
den = [tau 1 -V*G_d2g*G2/n V*G_d2g*G1/n]

sys = tf(num,den)
% 極の表示
figure
pzplot(sys)
pole(sys)
% ???
figure
rlocus(sys)
% bode線図
figure
bode(sys)
% ステップ応答
step(sys)
% 安定余裕
disp("statily of system")
marg = allmargin(sys);
GainMargins_dB = mag2db(marg.GainMargin)
marg.PhaseMargin

time=10;
sensitivity_e = 0.01;
sensitivity_y_dot = 0.01;
sim('e_and_y_dot')
figure
plot(y_des);hold on;
plot(y_c);

%% 不感帯を含めて線形化できる？

mdl = 'e_and_y_dot'

io(1) = linio([mdl '/Step'],1,'input')
io(2) = linio([mdl '/Integrator1'],1,'output')

setlinio(mdl, io)
set_param(mdl, 'ShowLinearizationAnnotations','on')

linsys = linearize(mdl, io)
linsys_tf = tf(linsys)

figure
w = logspace(-1, 1, 1000);
bode(linsys,w)

figure
step(linsys,10)