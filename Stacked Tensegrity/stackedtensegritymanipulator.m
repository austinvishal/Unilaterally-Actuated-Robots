% LayeredN-plex Cylindrical Tensegrity Generator
clc; clear;
cla reset;
%% Input data
% nul=6; % Number of tensegrity layer
nul=4;
nl=nul+1; % Number of tensegrity plane
% ne=14; % ne = N-polygon
ne=4;
 dtheta=(2+ne)/2/ne*pi(); % Unit of shift angle
% dtheta=0;
radi=1.7321; % Unit radius
r=ones(1,nl)*radi; % radii of bottom, ... , top nodes
heig=6.1485/2; % Unit height
h=[0:nul]*heig; % Elevations of bottom, ... , top nodes
%% Main
phi=2*pi()/ne;
theta=[0:nul]*dtheta; % Shifting angles
% Cycler index i:1-n+1 j:1-n,1 points
for i = 1:(ne+1)
    if mod(i,ne)==0
        j(i)=ne;
    else
        j(i)=mod(i,ne);
    end
end
% Point coordinates
nodcoor=zeros(nl,ne+1,3);
for i = 1:(ne+1)
    k=j(i);
    for m = 1:nl
%         nodcoor(m,i,:)=[r(m)*cos(theta(m)+phi*(k-1)),r(m)*sin(theta(m)+phi*(k-1)),h(m)];
          nodcoor(m,i,:)=[h(m),r(m)*cos(theta(m)+phi*(k-1)),r(m)*sin(theta(m)+phi*(k-1))]; %to plot on different orientation
    end
end
hold all
% grid on
% axis normal
set(gcf,'position',[200,300,900,500]) % Windows location and size
grid off;
axis off
% view(55,5) % Azimuth and elevation view
%view(0,90) % Azimuth and elevation for plan view
view(12,15)
for m = 1:nl
% plot3(nodcoor(m,:,1),nodcoor(m,:,2),nodcoor(m,:,3),'Color','g','LineWidth',2) % cables
plot3(nodcoor(m,:,1),nodcoor(m,:,2),nodcoor(m,:,3),'Color','r','LineWidth',2)
end
for i = 1:ne
    for m1 = 1:nl-1
        brace(1,:)=nodcoor(m1,i,:); brace(2,:)=nodcoor(m1+1,i,:);
        strut(1,:)=nodcoor(m1,i,:); strut(2,:)=nodcoor(m1+1,j(i+1),:);
        plot3(brace(:,1),brace(:,2),brace(:,3),'Color','b','LineWidth',2)
%         plot3(strut(:,1),strut(:,2),strut(:,3),'Color','r','LineWidth',2)
        plot3(strut(:,1),strut(:,2),strut(:,3),'Color','k','LineWidth',2)
    end
% for m = 1:nl
%     in=m*10+i;
%     text(nodcoor(m,i,1),nodcoor(m,i,2),nodcoor(m,i,3),[' ' num2str(in)],'HorizontalAlignment','left','FontSize',10);
% end
end
% Nodes plotting
for m = 1:nl
scatter3(nodcoor(m,i,1),nodcoor(m,i,2),nodcoor(m,i,3),'filled','MarkerFaceColor','k')
end