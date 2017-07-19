function [ calB, calG, calW ] = calibFun( tind, data )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
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

end

