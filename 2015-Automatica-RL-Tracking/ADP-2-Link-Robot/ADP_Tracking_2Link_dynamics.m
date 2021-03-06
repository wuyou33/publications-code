function xout=ADP_Tracking_2Link_dynamics(t,z,basis,tf,n,R,Q,Vc,...
    L,etaa1,etaa2,etac,lambda,v,pecutoff)
%% Destack
x = z(1:n);
WcH = z(n+1:n+L);
WaH = z(n+L+1:n+2*L);
Gamma = reshape(z(n+2*L+1:n+2*L+L*L),L,L);
% if min(real(eig(Gamma)))<0.1
%     Gamma = 100*eye(L);
% end

%% Dynamics
xd = [(1/2)*cos(2*t); (1/3)*cos(3*t); -sin(2*t); -sin(3*t)];
h = [xd(3); xd(4); -4*xd(1); -9*xd(2)];
e = x-xd;
Z = [e;xd];

p1 = 3.473;
p2 = .196;
p3 = .242;
fd1 = 5.3;
fd2 = 1.1;
fs1 = 8.45;
fs2 = 2.35;
M = [p1+2*p3*cos(x(2)) p2+p3*cos(x(2));
     p2+p3*cos(x(2))   p2             ];
Minv = (1/(p2^2 - p1*p2 + p3^2*cos(x(2))^2))*...
       [-p2               p2+p3*cos(x(2))  ;...
         p2+p3*cos(x(2)) -p1-2*p3*cos(x(2))];
Vm = [-p3*sin(x(2))*x(4) -p3*sin(x(2))*(x(3)+x(4));
       p3*sin(x(2))*x(3)  0                       ];
Fd = diag([fd1,fd2]);
Fs = [fs1*tanh(x(3));fs2*tanh(x(4))];
f = [x(3); x(4); Minv*((-Vm - Fd)*[x(3); x(4)]-Fs)];
g = [0 0; 0 0; Minv]; 
Md = [p1+2*p3*cos(xd(2)) p2+p3*cos(xd(2));
      p2+p3*cos(xd(2))   p2              ];
Vmd = [-p3*sin(xd(2))*xd(4) -p3*sin(xd(2))*(xd(3)+xd(4));
        p3*sin(xd(2))*xd(3)  0                          ];
Fsd = [fs1*tanh(xd(3));fs2*tanh(xd(4))];
fd = [xd(3); xd(4); Md\((-Vmd - Fd)*[xd(3); xd(4)]-Fsd)];
gplusd = [0 0; 0 0; Md']';
ud = gplusd*(h-fd);
F = [f-h+g*ud;h];
G = [g;zeros(size(g))];
if basis == 1
    phi = [(1/2)*Z(1)^2;...
           (1/2)*Z(2)^2;...
           (1/2)*Z(3)^2;...
           (1/2)*Z(4)^2;...
           (1/2)*Z(1)^2*Z(2)^2;...
           (1/2)*Z(1)^2*Z(5)^2;...
           (1/2)*Z(1)^2*Z(6)^2;...
           (1/2)*Z(1)^2*Z(7)^2;...
           (1/2)*Z(1)^2*Z(8)^2;...
           (1/2)*Z(2)^2*Z(5)^2;...
           (1/2)*Z(2)^2*Z(6)^2;...
           (1/2)*Z(2)^2*Z(7)^2;...
           (1/2)*Z(2)^2*Z(8)^2;...
           (1/2)*Z(3)^2*Z(4)^2;...
           (1/2)*Z(3)^2*Z(5)^2;...
           (1/2)*Z(3)^2*Z(6)^2;...
           (1/2)*Z(3)^2*Z(7)^2;...
           (1/2)*Z(3)^2*Z(8)^2;...
           (1/2)*Z(4)^2*Z(5)^2;...
           (1/2)*Z(4)^2*Z(6)^2;...
           (1/2)*Z(4)^2*Z(7)^2;...
           (1/2)*Z(4)^2*Z(8)^2];
       
    phi_p = [Z(1)   0      0      0      0      0      0      0      ;...        
             0      Z(2)   0      0      0      0      0      0      ;...   
%              0      0      Z(3)   0      0      0      0      0      ;...
%              0      0      0      Z(4)   0      0      0      0      ;...
             Z(3)   0      Z(1)   0      0      0      0      0      ;...
             Z(4)   0      0      Z(1)   0      0      0      0      ;...
             0      Z(3)   Z(2)   0      0      0      0      0      ;...
             0      Z(4)   0      Z(2)   0      0      0      0      ;...         
             Z(1)*Z(2)^2 Z(2)*Z(1)^2 0           0           0           0           0           0           ;...
             Z(1)*Z(5)^2 0           0           0           Z(5)*Z(1)^2 0           0           0           ;...  
             Z(1)*Z(6)^2 0           0           0           0           Z(6)*Z(1)^2 0           0           ;...
             Z(1)*Z(7)^2 0           0           0           0           0           Z(7)*Z(1)^2 0           ;...
             Z(1)*Z(8)^2 0           0           0           0           0           0           Z(8)*Z(1)^2 ;...
             0           Z(2)*Z(5)^2 0           0           Z(5)*Z(2)^2 0           0           0           ;...  
             0           Z(2)*Z(6)^2 0           0           0           Z(6)*Z(2)^2 0           0           ;... 
             0           Z(2)*Z(7)^2 0           0           0           0           Z(7)*Z(2)^2 0           ;...
             0           Z(2)*Z(8)^2 0           0           0           0           0           Z(8)*Z(2)^2 ;...
%              0           0           Z(3)*Z(4)^2 Z(4)*Z(3)^2 0           0           0           0           ;...
             0           0           Z(3)*Z(5)^2 0           Z(5)*Z(3)^2 0           0           0           ;...
             0           0           Z(3)*Z(6)^2 0           0           Z(6)*Z(3)^2 0           0           ;...
             0           0           Z(3)*Z(7)^2 0           0           0           Z(7)*Z(3)^2 0           ;...
             0           0           Z(3)*Z(8)^2 0           0           0           0           Z(8)*Z(3)^2 ;...
             0           0           0           Z(4)*Z(5)^2 Z(5)*Z(4)^2 0           0           0           ;...
             0           0           0           Z(4)*Z(6)^2 0           Z(6)*Z(4)^2 0           0           ;...
             0           0           0           Z(4)*Z(7)^2 0           0           Z(7)*Z(4)^2 0           ;...
             0           0           0           Z(4)*Z(8)^2 0           0           0           Z(8)*Z(4)^2 ];
else
    phi=(1-exp(-2*(Vc'*x)))./(1+exp(-2*(Vc'*x)));
    phi_p = diag(4*exp(-2*Vc'*[1;Z])./(1+exp(-2*Vc'*[1;Z])).^2)*Vc(2:end,:)';
end
mu=-0.5*(R\G')*phi_p'*WaH;
pe1 = 3*0.85*(tanh(2*t)*(20*sin(sqrt(232)*pi*t)*cos(sqrt(20)*pi*t) + 6*sin(18*exp(2)*t)+ 20*cos(40*t)*cos(21*t)));
pe2 = 0.01*(tanh(2*t)*(20*sin(sqrt(132)*pi*t)*cos(sqrt(10)*pi*t) + 6*sin(8*exp(1)*t)+ 20*cos(10*t)*cos(11*t)));
pe = [pe1;pe2];
if t<=tf*pecutoff
    munew = mu + pe;
else
    munew = mu;
end

%% ADP
omega = phi_p*(F+G*mu);
r = e'*Q*e + mu'*R*mu;
delta = WcH'*omega + r;
psi = omega/sqrt(1+v*omega'*Gamma*omega);
rho = (1+v*omega'*(Gamma)*omega);
Gsigma = phi_p*G*(R\G')*phi_p';
WcHD = -etac*Gamma*omega*delta/rho;
GammaD = reshape(etac*(lambda*Gamma-Gamma*(psi*psi')*Gamma),L*L,1);
WaHD = etaa1*(WcH-WaH)-etaa2*WaH;%+etac*Gsigma'*WaH*omega'*WcH/(4*rho);
u = munew+ud;
xD = f+g*u;

%% Output
xout=[xD;WcHD;WaHD;GammaD];