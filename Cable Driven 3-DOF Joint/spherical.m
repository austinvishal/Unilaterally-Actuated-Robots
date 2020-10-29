restoredefaultpath
rehash toolboxcache
close all;
clear all;
clc;

%% initialization of Cable-Driven ball joint with n+1 cable configuration
syms R1 R2 d1 d2 S1 real
syms q3 q2 q1 real
syms u1 u2 u3 u4 real
R1=114/1000; % Dimensions are in m
R2=93/1000;
d1= 180/1000;
d2=90/1000;
q1min= -0.610865; %-35 in degrees, converted into radians
q1max= 0.349066; %20;
q2min= -0.942478; %-54;
q2max= 1.0472; %60;
q3min= -1.22173; %-70;
q3max= 1.48353; %85;
aA1= [R2,0,-d2]';
aA2= [0,-R2,-d2]';
aA3= [-R2,0,-d2]';
aA4= [0,R2,-d2]';
bB1= [R1*sind(20),R1*cosd(20),d1]';
bB2= [-R1,0,d1]';
bB3= [-R1*sind(20),-R1*cosd(20),d1]';
bB4= [R1,0,d1]';
Cq3= cos(q3);
Cq2= cos(q2);
Cq1= cos(q1);
Sq3= sin(q3);
Sq2= sin(q2);
Sq1= sin(q1);

S1= [ Cq3*Cq2 Cq3*Sq2*Sq1-Sq3*Cq1 Cq3*Sq2*Cq1+Sq3*Sq1;
        Sq3*Sq2 Sq3*Sq2*Sq1+Cq3*Cq1 Sq3*Sq2*Cq1-Cq3*Sq1;
        -Sq2 Cq2*Sq3 Cq2*Cq3;];
  bA= [0,0,-d1]';   % coordinate of A with respect to static frame B
      bA1= S1*(aA1);
      bA2= S1*(aA2);
      bA3= S1*(aA3);
      bA4= S1*(aA4);
      rbAA1= bA1-bA;
      rbAA2= bA2-bA;
      rbAA3= bA3-bA;
      rbAA4= bA4-bA;
      l1_vec= vpa(simplify(bA1-bB1),4);
      l2_vec= vpa(simplify(bA2-bB2),4); %l2= bA2-vpa(simplify(bB2),4);
      l3_vec= vpa(simplify(bA3-bB3),4);
      l4_vec= vpa(simplify(bA4-bB4),4);
      %by norm
%  l1=vpa(simplify(norm(l1_vec)),4);
%  l2=vpa(simplify(norm(l2_vec)),4);
%  l3=vpa(simplify(norm(l3_vec)),4);
%  l4=vpa(simplify(norm(l4_vec)),4);

 % by distance method
l1_abs= vpa(simplify(sqrt((d1^2+d2^2)+(R1^2+R2^2)-(2*bB1'*S1*aA1))),4);
l2_abs= vpa(simplify(sqrt((d1^2+d2^2)+(R1^2+R2^2)-(2*bB2'*S1*aA2))),4);
l3_abs= vpa(simplify(sqrt((d1^2+d2^2)+(R1^2+R2^2)-(2*bB3'*S1*aA3))),4);
l4_abs= vpa(simplify(sqrt((d1^2+d2^2)+(R1^2+R2^2)-(2*bB4'*S1*aA4))),4);
u1= l1_vec/l1_abs;
u2= l2_vec/l2_abs;
u3= l3_vec/l3_abs;
u4= l4_vec/l4_abs;

%% Jacobian
J=[(cross(rbAA1,u1))   (cross(rbAA2,u2))   (cross(rbAA3,u3))   (cross(rbAA4,u4))];
s=J(1:3,1:3);

%% determination of null space vector

na5=[-adjoint(s)*J(:,4);det(s)]';
A=na5(1);
B=na5(2);
C=na5(3);
D=na5(4);

%% determination of wrench closure boundaries
eqn10= A == 0;
eqn11= B == 0;
eqn12= C == 0;
eqn13= D == 0;
%% PLOTTING
g5=figure;
set(0, 'CurrentFigure',g5)
a = axes;
%figure(5)
% fi=fimplicit3(eqn10,[-1.5 2],'b'); % b color
% fi=fimplicit3(eqn10,[0 2*pi]);
fi=fimplicit3(eqn10,[-pi pi]);
% fi=fimplicit3(eqn10,[-pi pi],'b');
% fi.EdgeColor = 'Black';
% fi.FaceAlpha = 0.5;
hold on
grid on
% fj=fimplicit3(eqn11,[0 2*pi],'m'); %m color
fj=fimplicit3(eqn11,[-pi pi]);
% fj=fimplicit3(eqn11,[-pi pi],'m');
% fj.EdgeColor = 'Black';
% fj.FaceAlpha = 0.5;
%fimplicit3(eqn11,[0 2*pi]);
hold on
% fk=fimplicit3(eqn12,[0 2*pi],'r'); % r color
fk=fimplicit3(eqn12,[-pi pi]);
% fk=fimplicit3(eqn12,[-pi pi],'r');
% fk.EdgeColor = 'Black';
% fk.FaceAlpha = 0.5;
%fimplicit3(eqn12,[0 2*pi]);
hold on
% fl=fimplicit3(eqn13,[0 2*pi],'y'); % y color
fl=fimplicit3(eqn13,[-pi pi]); 
% fl=fimplicit3(eqn13,[-pi pi],'y'); 
% fl.EdgeColor = 'Black'; %Black/none
% fl.FaceAlpha = 0.5;
%fimplicit3(eqn13,[0 2*pi]);
%figure(2)
hold on
% L = sym(0:pi/2:2*pi);
L = sym(-pi:pi/3:pi);
a.XTick = double(L);
a.YTick = double(L);
a.ZTick = double(L);
M = arrayfun(@char, L, 'UniformOutput', false);
a.XTickLabel = M;
a.YTickLabel = M;
a.ZTickLabel = M;
%  xlim([0 2*pi]); ylim([0 2*pi])
xlim([-pi pi]); ylim([-pi pi])
title('Robot Positive tension workspace of CDSJ ')
 xlabel('q1')
 ylabel('q2')
 zlabel('q3')
 
 %% Plotting points

Q=[0;0 ;0];
F=[0;0;0;0];
 for q1= -0.610865:0.4:0.349066
    for q2= -0.942478:0.4:1.0472
        for q3= -1.22173:0.4: 1.48353
            f=subs(A);
            f1=subs(B);
            f2=subs(C);
            f3=subs(D);
            if ((f>0)) &&(f1>0)&&(f2>0) &&(f3>0) || ((f<0) && (f1<0) && (f2<0)&& (f3<0))
         
                Q1=[q1;q2; q3];
             %Q1=[theta1_pos;theta2_pos]
                Q=[Q,Q1];
                %  Q=cat(2,Q,Q1)
                F_new=[f;f1;f2;f3];
                F_new=cat(2,F,F_new);
        else
                %% ignore those values. find a way to do it neatly
                disp('out of workspace')
        end
        %end
         %   end
        %end
        end
    end
end
c=length(Q);
for i=1:1:c
    Qx(i)=Q(1,i);
    Qy(i)=Q(2,i);
    Qz(i)=Q(3,i);
  
end
%figure(5)
set(0, 'CurrentFigure',g5)
plot3(Qx,Qy,Qz,'ok') %* for asterix
grid on
hold off