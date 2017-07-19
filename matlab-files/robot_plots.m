%% plot
width = 10;     % Width in inches
height = 2.5;    % Height in inches
nr=1; nc=3;
figure(1);clf;
defpos = get(0,'defaultFigurePosition');
set(gcf,'Position', [defpos(1) defpos(2) width*100, height*100]);
%%
titlestr={'white circle','grey circle','black circle'};
for k=1:3
% k=1;
subplot(nr,nc,k)
plot(ecdat.nr,ecdat.escT(:,k),'x');
uniqNr=unique(ecdat.nr);
for i=1:numel(uniqNr)
    meanesc(i)=mean(ecdat.escT(ecdat.nr==uniqNr(i),k));
end
hold on
plot(uniqNr,meanesc);
hold off
xlabel('nr of extra robots')
ylabel('exit time')
title('white circle');
end

% print('-r400','-depsc','-opengl',[path,'meanexit1'])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% collision


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% example plots of runs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
width = 10;     % Width in inches
height = 2.5;    % Height in inches
nr=1; nc=2;
figure(1);clf;
defpos = get(0,'defaultFigurePosition');
set(gcf,'Position', [defpos(1) defpos(2) width*100, height*100]);

subplot(nr,nc,1)
load('0_escape016_07-12-2017_11-17.mat');
data=data(:,6);
timeVectors=timeS;
graylvl=925;
blacklvl=750;
cols=lines(6);
white=data>=graylvl; tmp=white | [white(2:end);0];
whitel=nan(numel(data),1); whitel(tmp)=data(tmp);
gray=data<graylvl & blacklvl<=data; tmp=gray | [gray(2:end);0];
grayl=nan(numel(data),1); grayl(tmp)=data(tmp);
black=data<blacklvl; tmp=black | [black(2:end);0];
blackl=nan(numel(data),1); blackl(tmp)=data(tmp);
%
exT1ind=find(gray,1,'first');
exT2ind=find(black,1,'first');
relp=3;
exT3ind=find(black(1:end-relp)& white(relp+1:end),1,'last')+relp;
if isempty(exT3ind)
    exT3ind=numel(data);
end
hold on
ylim([min(data)*0.98,max(data)*1.02])
plot(timeVectors([exT1ind,exT1ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(2,:));
plot(timeVectors([exT2ind,exT2ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(3,:));
plot(timeVectors([exT3ind,exT3ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(6,:));

%
%plot(timeVectors(data>=968),data(data>=968),'.');
plot(timeVectors,whitel,'Color',cols(1,:));
plot(timeVectors,grayl,'Color',cols(4,:));
plot(timeVectors,blackl,'Color',cols(5,:));

plot(timeVectors(white),data(white),'.','Color',cols(1,:));
plot(timeVectors(gray),data(gray),'.','Color',cols(4,:));
plot(timeVectors(black),data(black),'.','Color',cols(5,:));
xlim([0,max(timeVectors)]);
% ticksv=sort([0:25:max(timeVectors),timeVectors([exT1ind,exT2ind,exT3ind])]);
ticksv=sort(timeVectors([exT1ind,exT2ind,exT3ind]));
xticks(ticksv);
hold off
xlabel('time in s')
ylabel('sensor')
title('0 additional robots')


subplot(nr,nc,2)
load('16_escape016_07-12-2017_11-35.mat');
data=data(:,6);
timeVectors=timeS;
graylvl=925;
blacklvl=750;
cols=lines(6);
white=data>=graylvl; tmp=white | [white(2:end);0];
whitel=nan(numel(data),1); whitel(tmp)=data(tmp);
gray=data<graylvl & blacklvl<=data; tmp=gray | [gray(2:end);0];
grayl=nan(numel(data),1); grayl(tmp)=data(tmp);
black=data<blacklvl; tmp=black | [black(2:end);0];
blackl=nan(numel(data),1); blackl(tmp)=data(tmp);
%
exT1ind=find(gray,1,'first');
exT2ind=find(black,1,'first');
relp=3;
exT3ind=find(black(1:end-relp)& white(relp+1:end),1,'last')+relp;
if isempty(exT3ind)
    exT3ind=numel(data);
end
hold on
ylim([min(data)*0.98,max(data)*1.02])
plot(timeVectors([exT1ind,exT1ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(2,:));
plot(timeVectors([exT2ind,exT2ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(3,:));
plot(timeVectors([exT3ind,exT3ind]),[min(data)*0.98,max(data)*1.02],'Color',cols(6,:));

%
%plot(timeVectors(data>=968),data(data>=968),'.');
plot(timeVectors,whitel,'Color',cols(1,:));
plot(timeVectors,grayl,'Color',cols(4,:));
plot(timeVectors,blackl,'Color',cols(5,:));

plot(timeVectors(white),data(white),'.','Color',cols(1,:));
plot(timeVectors(gray),data(gray),'.','Color',cols(4,:));
plot(timeVectors(black),data(black),'.','Color',cols(5,:));
xlim([0,max(timeVectors)]);
% ticksv=sort([0:25:max(timeVectors),timeVectors([exT1ind,exT2ind,exT3ind])]);
ticksv=sort(timeVectors([exT1ind,exT2ind,exT3ind]));
xticks(ticksv);
hold off
xlabel('time in s')
title('16 additional robots')

print('-r400','-depsc','-opengl',[path,'meanexit11'])




