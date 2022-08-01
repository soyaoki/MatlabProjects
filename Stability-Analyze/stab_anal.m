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

%��ԕ������}�g���N�X
a11=-2*(cf+cr)/m;
a12=-1-2*(lf*cf-lr*cr)/m;
a21=-2*(lf*cf-lr*cr)/I;
a22=-2*(lf*lf*cf+lr*lr*cr)/I;
b11=2*cf/m;
b21=2*lf*cf/I;

%Steering
y0=2.0; 
tp=0.5; %�O����������
lp=tp*V; %�O����������
h1=2*V/lp/lp; %���ʒu�΍�����ڕW���[���C�g
h=(1+A*V*V)*l/V; %�ڕW���[���C�g����ڕW�Ǌp

% �ꎟ�\�����f���iy_des �� y_c�j
num = [0 h1*V]
den = [tau 1 h1*V*lp h1*V]

sys_near = tf(num,den)

% �ꎟ�\�����f���iy_des �� y_c�j
tp=0.5*3; %�O����������
lp=tp*V; %�O����������
h1=2*V/lp/lp; %���ʒu�΍�����ڕW���[���C�g
h=(1+A*V*V)*l/V; %�ڕW���[���C�g����ڕW�Ǌp

num = [0 h1*V]
den = [tau 1 h1*V*lp h1*V]

sys_far = tf(num,den)

% �ɂ̕\��
figure
pzplot(sys_near, sys_far)

% ???
figure
rlocus(sys_near)
figure
rlocus(sys_far)

% bode���}
figure
bode(sys_near)
figure
bode(sys_far)

% �X�e�b�v����
step(sys_near,sys_far)

% ����]�T
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

%��ԕ������}�g���N�X
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
% �ɂ̕\��
figure
pzplot(sys)
pole(sys)
% ???
figure
rlocus(sys)
% bode���}
figure
bode(sys)
% �X�e�b�v����
step(sys)
% ����]�T
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

%% �s���т��܂߂Đ��`���ł���H

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