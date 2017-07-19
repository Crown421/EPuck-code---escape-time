load('calibNE_06-29-2017_03-45.mat');
timeVectors=timeVectors(1:size(data,1));

width = 10;     % Width in inches
height = 4.8;    % Height in inches
nr=2; nc=2;
figure(1);clf;
defpos = get(0,'defaultFigurePosition');
set(gcf,'Position', [defpos(1) defpos(2) width*100, height*100]);
subplot(nr,nc,1);
plot(timeVectors(1:end-1),data(1:end-1,2));
hold on
plot(timeVectors(1:end-1),data(1:end-1,3));
plot(timeVectors(1:end-1),data(1:end-1,4));
hold off
xlim([0,max(timeVectors)]);
ylabel('sensor')
xlabel('time')
legend('left','centre','right','location','best');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(nr,nc,2);
graylvl=925;
blacklvl=750;
cols=lines(6);
data=data(:,5);
white=data>=graylvl; tmp=white | [white(2:end);0];
whitel=nan(numel(data),1); whitel(tmp)=data(tmp);
gray=data<graylvl & blacklvl<=data; tmp=gray | [gray(2:end);0];
grayl=nan(numel(data),1); grayl(tmp)=data(tmp);
black=data<blacklvl; tmp=black | [black(2:end);0];
blackl=nan(numel(data),1); blackl(tmp)=data(tmp);

exT1ind=find(gray,1,'first');
exT2ind=find(black,1,'first');
exT3ind=find(black(1:end-5)& white(6:end),1,'last')+5;
hold on
ylim([min(data)*0.98,max(data)*1.02])
% plot(timeVectors([exT1ind,exT1ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(2,:));
% plot(timeVectors([exT2ind,exT2ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(3,:));
% plot(timeVectors([exT3ind,exT3ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(6,:));

%
%plot(timeVectors(data>=968),data(data>=968),'.');
h(1)=plot(timeVectors,whitel,'Color',cols(1,:));
h(2)=plot(timeVectors,grayl,'Color',cols(4,:));
h(3)=plot(timeVectors,blackl,'Color',cols(5,:));

plot(timeVectors(white),data(white),'.','Color',cols(1,:));
plot(timeVectors(gray),data(gray),'.','Color',cols(4,:));
plot(timeVectors(black),data(black),'.','Color',cols(5,:));

xlim([0,max(timeVectors)]);
% ticksv=sort([0:25:max(timeVectors),timeVectors([exT1ind,exT2ind,exT3ind])]);
% xticks(ticksv);
plot([min(timeVectors),max(timeVectors)],[925,925],'Color',[0.65,0.65,0.65])
plot([min(timeVectors),max(timeVectors)],[750,750],'k')
hold off
legend(h,{'white','grey','black'},'Location','best')
xlabel('time')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(nr,nc,3);
load('calibNE_06-29-2017_03-45.mat');
tind=[3,30,57,119,143,168];
plot(data(1:end-1,5),'Marker','.','MarkerSize',15);
hold on
for i=1:numel(tind)
    plot([tind(i),tind(i)],[min(data(:,5)),max(data(:,5))],'r');
end
hold off

black=[data(tind(1)+1:tind(2),5);data(tind(5)+1:tind(6),5)];
grey=[data(tind(2)+1:tind(3),5);data(tind(4)+1:tind(5),5)];
white=data(tind(3)+1:tind(4),5);

calB(1)=mean(black); 
calB(2)=min(black); calB(3)=max(black); 
calG(1)=mean(grey);
calG(2)=min(grey); calG(3)=max(grey);
calW(1)=mean(white);
calW(2)=min(white); calW(3)=max(white);

disp([calB;calG;calW]);
hold on
plot(tind(1:2),[calB(1),calB(1)],'g');
plot(tind(1:2),[calB(2),calB(2)],'g');
plot(tind(1:2),[calB(3),calB(3)],'g');
plot(tind(5:6),[calB(1),calB(1)],'g');
plot(tind(5:6),[calB(2),calB(2)],'g');
plot(tind(5:6),[calB(3),calB(3)],'g');

plot(tind(2:3),[calG(1),calG(1)],'g');
plot(tind(2:3),[calG(2),calG(2)],'g');
plot(tind(2:3),[calG(3),calG(3)],'g');
plot(tind(4:5),[calG(1),calG(1)],'g');
plot(tind(4:5),[calG(2),calG(2)],'g');
plot(tind(4:5),[calG(3),calG(3)],'g');

plot(tind(3:4),[calW(1),calW(1)],'g');
plot(tind(3:4),[calW(2),calW(2)],'g');
plot(tind(3:4),[calW(3),calW(3)],'g');
hold off
xlabel('data points')
ylabel('sensor')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('calibData.mat');
subplot(nr,nc,4);
wid=0.35;
high=mean(calW(:,1)); varhigh=sqrt(var(calW(:,1))); calmeans(1)=high;
h(1)=plot([1-wid,1+wid],[high,high],'k');
hold on
h(2)=plot([1-wid,1+wid],[high+varhigh,high+varhigh],'g');
plot([1-wid,1+wid],[high-varhigh,high-varhigh],'g');
high=min(calW(:,2));
h(3)=plot([1-wid,1+wid],[high,high],'r');
high=max(calW(:,3));
plot([1-wid,1+wid],[high,high],'r');

high=mean(calG(:,1)); varhigh=sqrt(var(calG(:,1))); calmeans(2)=high;
plot([2-wid,2+wid],[high,high],'k');
plot([2-wid,2+wid],[high+varhigh,high+varhigh],'g');
plot([2-wid,2+wid],[high-varhigh,high-varhigh],'g');
high=min(calG(:,2));
plot([2-wid,2+wid],[high,high],'r');
high=max(calG(:,3));
plot([2-wid,2+wid],[high,high],'r');

high=mean(calB(:,1)); varhigh=sqrt(var(calB(:,1))); calmeans(3)=high;
plot([3-wid,3+wid],[high,high],'k');
plot([3-wid,3+wid],[high+varhigh,high+varhigh],'g');
plot([3-wid,3+wid],[high-varhigh,high-varhigh],'g');
high=min(calB(:,2));
plot([3-wid,3+wid],[high,high],'r');
high=max(calB(:,3));
plot([3-wid,3+wid],[high,high],'r');
hold off
xticks([1,2,3])
xticklabels({'white';'grey';'black'})
% xlabel('data points')
% ylabel('sensor')
legend(h,{'mean','std. dev.','extrem'},'Location','best')

% print('-r400','-depsc','-opengl',[path,'calibration'])
% save('calibData.mat','calmeans','-append')


%%  NE 1 (1)
m=1;
figure(2); clf;
load('calibNE_06-29-2017_03-45.mat');
tind=[3,30,57,119,143,168];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);


%%  NE 2 (2)
m=2;
figure(2); clf;
load('calibNE_06-29-2017_03-47.mat');
tind=[5,32,59,118,143,169];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);

%%  NW 1 (3)
m=3;
figure(2); clf;
load('calibNW_06-29-2017_03-22.mat');
tind=[2,29,56,115,141,166];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);

%%  NW 2 (4)
m=4;
figure(2); clf;
load('calibNW_06-29-2017_03-24.mat');
tind=[2,29,58,113,139,165];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);

%%  SE 1 (5)
m=5;
figure(2); clf;
load('calibSE_06-29-2017_03-12.mat');
tind=[2,29,56,128,154,179];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);

%%  SE 2 (6)
m=6;
figure(2); clf;
load('calibSE_06-29-2017_03-19.mat');
tind=[2,29,56,116,141,166];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);

%%  SW 1 (7)
m=7;
figure(2); clf;
load('calibSW_06-29-2017_02-55.mat');
tind=[1,23,50,110,135,160];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);

%%  SW 2 (8)
m=8;
figure(2); clf;
load('calibSW_06-29-2017_03-09.mat');
tind=[3,29,56,116,141,166];

[calB(m,:),calG(m,:),calW(m,:)]=calibFun(tind,data);