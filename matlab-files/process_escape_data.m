function [ ecdat ] = process_escape_data( graylvl, blacklvl, filename )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% graylvl=940;
% blacklvl=794;
% data=readings(:,5);
load('escape_data.mat','ecdat');
m = find(strcmp([ecdat.names{:}], filename),1); % single line engine
if isempty(m) 
    m=length(ecdat.names)+1;
    ecdat.names{m}=filename;
end
if numel(m)>1
    error('double entry in file name list')
end
ecdat.nr(m)=str2double(regexp(filename,'(^\d+)','match'));

load(['data/',filename],'data','timeS');
meansense=data(:,6);

cols=lines(6);
white=meansense>=graylvl; tmp=white | [white(2:end);0];
whitel=nan(numel(meansense),1); whitel(tmp)=meansense(tmp);
gray=meansense<graylvl & blacklvl<=meansense; tmp=gray | [gray(2:end);0];
grayl=nan(numel(meansense),1); grayl(tmp)=meansense(tmp);
black=meansense<blacklvl; tmp=black | [black(2:end);0];
blackl=nan(numel(meansense),1); blackl(tmp)=meansense(tmp);
%
figure(1); clf;

exT1ind=find(gray,1,'first');
exT2ind=find(black,1,'first');
relp=3;
exT3ind=find(black(1:end-relp)& white(relp+1:end),1,'last')+relp;
if isempty(exT3ind)
    exT3ind=numel(meansense);
end
hold on
ylim([min(meansense)*0.98,max(meansense)*1.02])
plot(timeS([exT1ind,exT1ind]),[min(meansense)*0.98,max(meansense)*1.02],'Color',cols(2,:));
plot(timeS([exT2ind,exT2ind]),[min(meansense)*0.98,max(meansense)*1.02],'Color',cols(3,:));
plot(timeS([exT3ind,exT3ind]),[min(meansense)*0.98,max(meansense)*1.02],'Color',cols(6,:));

%
%plot(timeS(meansense>=968),meansense(meansense>=968),'.');
plot(timeS,whitel,'Color',cols(1,:));
plot(timeS,grayl,'Color',cols(4,:));
plot(timeS,blackl,'Color',cols(5,:));

plot(timeS(white),meansense(white),'.','Color',cols(1,:));
plot(timeS(gray),meansense(gray),'.','Color',cols(4,:));
plot(timeS(black),meansense(black),'.','Color',cols(5,:));

xlim([0,max(timeS)]);
% ticksv=sort([0:25:max(timeS),timeS([exT1ind,exT2ind,exT3ind])]);
ticksv=sort(timeS([exT1ind,exT2ind,exT3ind]));
xticks(ticksv);

hold off

ecdat.escT(m,:)=timeS([exT1ind,exT2ind,exT3ind]);
ecdat.thres(m,:)=[graylvl, blacklvl];
ecdat.msense{m}=meansense;

if size(data,2)==10
%     ecdat.collcount(m,:)=data(end,9:10);
    ecdat.collcount{m}=data([exT1ind,exT2ind,exT3ind],9:10);
    ecdat.colls{m}=data(:,9:10);
else
%     ecdat.collcount(m,:)=[NaN,NaN];
    ecdat.collcount{m}=NaN;
    ecdat.colls{m}=NaN;
end

save('escape_data','ecdat');

end

