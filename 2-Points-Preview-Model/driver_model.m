%Vehicle Params
m=1500;
I=2500;
lf=1.1;
lr=1.6;
l=lf+lr;
Kf=55000;
Kr=60000;
V=100/3.6;
A=-m*(lf*Kf-lr*Kr)/2/l/l/Kr/Kf;
n=18.7;

%Steering
y0=2.0; 
tp=0.5; %前方注視時間
lp=tp*V; %前方注視距離
h1=2*V/lp/lp; %横位置偏差から目標ヨーレイト
h=(1+A*V*V)*l/V; %目標ヨーレイトから目標舵角

h*n %目標ヨーレイトから目標ハンドル操舵角

%Params
omega= 10.8 %[Hz]、応答性
xi= 2.0 %収束性
Tp1=1.2
lp1=Tp1*V
Tp2=2*(1-xi*omega*Tp1)/(-omega*omega*Tp1+2*omega*xi)
lp2=Tp2*V
%lp1=0.8;
%lp2=1.2;
k=Tp2/Tp1
tau=0.0

G1=omega*omega*(xi*xi*(1+k)-k+xi*(xi*xi*(1+k)*(1+k)-2*k)^(1/2))/V/(1-k)
G1=2*omega*omega*(1-2*xi*xi)/V/(Tp1*Tp1*omega*omega-4*omega*xi*Tp1+2)
G2=omega*omega*(1-xi*xi*(1+k)-xi*(xi*xi*(1+k)*(1+k)-2*k)^(1/2))/V/(1-k)
G2=omega*omega*(omega*Tp1-2*xi)^2/V/(Tp1*Tp1*omega*omega-4*omega*xi*Tp1+2)

%Simualation
dt=0.001;
tf=10;
sim('dm_1_and_2points')
