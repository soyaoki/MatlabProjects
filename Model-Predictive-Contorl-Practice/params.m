% Vehicle Params
m=1500;
I=2500;
lf=1.1;
lr=1.6;
l=lf+lr;
Kf=55000; Kr=60000;
cf=Kf; cr=Kr;
V=100/3.6;
A=-m*(lf*Kf-lr*Kr)/2/l/l/Kr/Kf
n=18.7;
tau=0.1;
dt=0.1;

%% 状態方程式マトリクス(車輌固定座標系)
a11=-2*(cf+cr)/m/V;
a12=-1-2*(lf*cf-lr*cr)/m/V/V;
a21=-2*(lf*cf-lr*cr)/I;
a22=-2*(lf*lf*cf+lr*lr*cr)/I/V;
b11=2*cf/m/V;
b21=2*lf*cf/I;

A=[a11 a12;a21 a22];
B=[b11;b21];
C=[1 0];
D=[0];

sys = ss(A,B,C,D)
sys = ss(A,B,C,D,dt)

%% 状態方程式マトリクス(地上固定座標系)
a11=-2*(lf*lf*cf+lr*lr*cr)/I/V;
a12=2*(lf*cf-lr*cr)/I;
a13=-2*(lf*cf-lr*cr)/I/V;
a31=-2*(lf*cf-lr*cr)/m/V;
a32=2*(cf+cr)/m;
a33=-2*(cf+cr)/m/V;
b11=2*lf*cf/I/n;
b31=2*cf/m/n;

A=[a11 a12 a13 0; 1 0 0 0; a31 a32 a33 0; 0 0 1 0];
B=[b11;0;b31;0];
C=[0 1 0 0; 0 0 0 1];
D=[0; 0];

sys = ss(A,B,C,D)
sys = ss(A,B,C,D,dt)