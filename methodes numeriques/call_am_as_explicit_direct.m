% Set up les parametres
clear all;
clc;
 % Les paramètres
S=100;
Smin=S-S/2;
Smax=S+S/2;
risk=0.02;
strike=100;
sigma=0.3;
T=2;

%a=0;
%b=2*S;
a=-1.1;
b=-0.9;

% période 
N=200;
M=3*N*N;

% les pas 
h=(b-a)/(N+1);
k=T/(M+1);
h=(-Smin+Smax)/(N+1);
x=[Smin:h:Smax];
t=[0:k:T];

%Construction des matrices
B=zeros(N,N);


F=zeros(N,M);

 F(1,:)=((((sigma*x(1))^2)/(2*h*h))+ (risk*x(1))/(2*h) + (1-mean(x(1:1))/x(1)) )*k*x(1);
  F(N,:)=((((sigma*x(N))^2)/(2*h*h))+ (risk*x(N))/(2*h) - (1-mean(x(1:N))/x(N)) )*k*x(N+1);
 


%matrice U
UU=zeros(N,M);
V=zeros(N+2,M+2);
O=0;
for i=1:N
    UU(i,1)= max(mean(x(1:i)),x(i));
end

 for i=1:N-1
    B(i,i)=1+(((sigma*x(i))^2)/(h^2) +risk*x(i))*k;
    B(i,i+1)= -(((sigma*x(i))^2)/(2*h^2) +(1-mean(x(1:i))/x(i)) )*k;
    B(i+1,i)=-(((sigma*x(i+1))^2)/(2*h^2)- (1-mean(x(1:i+1))/x(i+1)) )*k;
   % B(i,1)= sin(pi*h*i),
end 
B(N,N)=1+(((sigma*x(N))^2)/(h^2)+risk*x(N))*k;

for j=1:M

 UU(:,j+1)= B*UU(:,j)+F(:,j) ;
O=O+1;
   % si dans le cas américain on ajoute:
    for i=1:N
        man= max(mean(x(1:i)),x(i));
        UU(i,j+1)=max(UU(i,j+1),man);
    end

end

s2=1;
d= abs(S-x(1));

for i=1:N+1
    temp= max(mean(x(1:i)),x(i));
    if (abs(S-temp))<d
      s2=i;
      d= S-temp;
    end
end
w=T/2 ;
s=1;
d= abs(w-t(1));

for i=1:M+2
    if (abs(w-t(i)))<d
      s=i;
      d= abs(w-t(i));
    end
end

CALL=UU(s2,s)