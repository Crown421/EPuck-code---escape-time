%% Programme to obtain bluetooth data from multiple e-puck robots
% don't forget to switch off the bootloader before using this programme

% old code (potentially useful)

% s.StopBits=1;
% s.ReadAsyncMode = 'continuous';
% stateVector = [];
% stateVector = [stateVector tempVector(1)];
% timeStepVector = [];
% timeStepVector(i) = toc;

% s=instrfindall 
% for i=1:length(s)
% flushinput(s(i)); fscanf(s(i), '%s',3)
% end


 

tic
delete(instrfind)
instrreset
clear;

% first batch
%['COM18'; 'COM24'; 'COM4 '; 'COM36'; 'COM14'] 
%  3275     3214     3300     3281     3303  

% second batch
%['COM6 '; 'COM8 '; 'COM10'; 'COM12'; 'COM16'] 
%  3301     3305     3280     3133     3111


%coms = ['COM6 '; 'COM8 '; 'COM10'; 'COM12'; 'COM16'];
coms = {'COM9'};
%coms = {'COM13'};
s=cell(length(coms));

for i=1:size(coms,1) 
    
    % ensures that COM's with single digit numbers are read properly 
%     if(isspace(coms(i,5)))
%         stringLength = 4;
%     else
%         stringLength = 5;
%     end    
    
    s{i} = serial(coms{i});
    s{i}.Baudrate=115200;
    s{i}.InputBufferSize = 100;
    test = 1;
    while test
        fclose(s{i});
        try
            fopen(s{i});
            test = 0;
            s{i}.Status
        catch ME 
            getReport(ME)
            pause(1);
            fprintf('%s failed\n', coms{i});
            allInstruments = instrfindall;
            %%delete(allInstruments(find(strcmp(allInstruments.Port, coms{i}))));
            delete(allInstruments(strcmp(allInstruments.Port, coms{i})));
            s{i} = serial(coms{i}); %#ok<TNMLP>
            s{i}.Baudrate=115200;
            s{i}.InputBufferSize = 100;
        end
    end   
    serialVector = instrfindall;
end   
if numel(s)~=size(serialVector,2); error('not same number of serials and found serials'); end

toc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% let it run

%init state vectors
numberOfRobots = size(serialVector,2);
%initStateVector = [];
%prevStateVector = [];
%prevStateVector = initStateVector;

%
% obtain a continuous stream of state information
runbool=true;
first=true;
k = zeros(numberOfRobots,1);
t = 0;
i = 1;
temp = [];
timeVectors = zeros(numberOfRobots,10);
timeStepVector = [];
readings=[];
misses=0;
while(runbool)    
    tic
    
    tempVector = [];
    for j=1:numberOfRobots
        if first
            initState = [];
            while(isempty(initState))
                fwrite(serialVector(j),'1');
                pause(0.00001);
                flushinput(serialVector(j));
                initState = fscanf(serialVector(j),'%s');
            end
            fprintf('Got: %s from %s',initState,coms{i});
            first=false;
        end
        
        flushinput(serialVector(j));
        temp = fscanf(serialVector(j),'%s');
        if ~isempty(temp)
            %readings(i,1:8)=strread(temp,'%d',8,'delimiter',',');
            %disp(readings(i,1:8));
            readings=[readings,temp];
            disp(temp);
            k(j)=k(j)+1;
            timeVectors(j,k(j)) = t;
            t = t+toc;
            disp(t);
            timeStepVector(i) = toc;
            misses=0;
            %if all(~readings(i,1:8))
            %if contains(temp,'0, 0, 0, 0, 0')
            %    runbool=0;
            %    break;
            %end
            
            i = i + 1;
        else
            misses=misses+1;
        end
        if misses>=2
            runbool=0;
        end
    end
    
%     for j=1:numberOfRobots
%         if (~strcmp(tempVector(j),'Z') && ~strcmp(tempVector(j),prevStateVector(j))) % checks whether buffer isn't empty and compares the current and previous states
%             prevStateVector(j);
%             tempVector(j);
%             prevStateVector(j) = tempVector(j);
%             k(j)=k(j)+1;
%             timeVectors(j,k(j)) = t
%             'state changed';
%         end
%     end
    
end
disp('left while loop');

% close serial ports
%%
for i=1:numel(s)
    fclose(s{i});
end
disp('done and all closed');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% process
cleaned = regexprep(readings,',[a-zA-Z]+.+','');
% cleaned = regexprep(readings,'[a-zA-Z]+.+','')
cleaned = regexprep(cleaned,'-1,+0,0.*','');
cleaned = regexprep(cleaned,',+',',');
numbers = str2num(cleaned);
timeS=timeVectors;
%%
idx=find(numbers==-1);
datlength=11;
if all(diff(idx)==datlength)
    disp('data integrity fine, convert and save')
    if idx(1)==datlength && (numel(numbers)-idx(end))==datlength-1
        numbers(idx)=[];
        
    elseif idx(1)==datlength
        numbers([idx(1:end-1),idx(end):end])=[];
    elseif (numel(numbers)-idx(end))==datlength-1
        numbers([1:idx(1),idx(2:end)])=[];
    else
        numbers([1:idx(1),idx(2:end-1),idx(end):end])=[];
    end
    data=reshape(numbers,datlength-1,[])';
    disp(data);
else
%     disp('some corruption, possibly fixed, try again');
%     errdiffidx=diff(idx)~=9;
    erridx=find(diff(idx)~=datlength);
    for i=numel(erridx):-1:1
        numbers(idx(erridx(i)):idx(erridx(i)+1)-1)=[];
        timeS(erridx(i)+1)=[];
    end
    error('some corruption, possibly fixed, try again');
end
timeS=timeS(1:size(data,1));


%% write state information to file
exkind = '16_escape017x';
datclock=strread(datestr(now,'mm-dd-yyyy HH-MM'),'%s',2);
filename=sprintf('data/%s_%s_%s',exkind,datclock{1},datclock{2});
%%% later add also robot pin and corresponding connector, also make struct
%%% tying PIN and comport together. PIN as structname?
save(filename,'readings','timeVectors','timeS','data');
%fclose(filename)



























% %init serial port
% serialVector = [];
% 
% %bees
% tic
% test = 1;
% s1 = serial('COM4');
% s1.Baudrate=115200;
% s1.InputBufferSize = 100;
% 
% while test
%     try
%         fopen(s1);
%         test = 0;
%         s1.Status
%     catch ME 
%         pause(1)
%         'COM4 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM4'))));
%         s1 = serial('COM4');
%         s1.Baudrate=115200;
%         s1.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s1];
% 
% test = 1;
% s2 = serial('COM10');
% s2.Baudrate=115200;
% s2.InputBufferSize = 100;
% while test
%     try
%         fopen(s2);
%         test = 0;
%         s2.Status
%     catch ME 
%         pause(1)
%         'COM10 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM10'))));
%         s2 = serial('COM10');
%         s2.Baudrate=115200;
%         s2.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s2];
% 
% test = 1;
% s3 = serial('COM14');
% s3.Baudrate=115200;
% s3.InputBufferSize = 100;
% while test
%     try
%         fopen(s3);
%         test = 0;
%         s3.Status
%     catch ME 
%         pause(1)
%         'COM14 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM14'))));
%         s3 = serial('COM14');
%         s3.Baudrate=115200;
%         s3.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s3];
% 
% 
% test = 1;
% s4 = serial('COM18');
% s4.Baudrate=115200;
% s4.InputBufferSize = 100;
% while test
%     try
%         fopen(s4);
%         test = 0;
%         s4.Status
%     catch ME 
%         pause(1)
%         'COM18 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM18'))));
%         s4 = serial('COM18');
%         s4.Baudrate=115200;
%         s4.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s4];
% 
% s5 = serial('COM38');
% s5.Baudrate=115200;
% serialVector = [serialVector s5];
% fopen(s5);
% s5.Status
%
% s6 = serial('COM10');
% s6.Baudrate=115200;
% serialVector = [serialVector s6];
% fopen(s6);
% s6.Status
%
% s7 = serial('COM10');
% s7.Baudrate=115200;
% serialVector = [serialVector s7];
% fopen(s7);
% s7.Status
%
% s8 = serial('COM10');
% s8.Baudrate=115200;
% serialVector = [serialVector s8];
% fopen(s8);
% s8.Status
% 
% 
% %flowers
% 
% test = 1;
% s9 = serial('COM30');
% s9.Baudrate=115200;
% s9.InputBufferSize = 100;
% while test
%     try
%         fopen(s9);
%         test = 0;
%         s9.Status
%     catch ME 
%         pause(1)
%         'COM30 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM30'))));
%         s9 = serial('COM30');
%         s9.Baudrate=115200;
%         s9.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s9];
% 
% test = 1;
% s10 = serial('COM46');
% s10.Baudrate=115200;
% s10.InputBufferSize = 100;
% 
% while test
%     try
%         fopen(s10);
%         test = 0;
%         s10.Status
%     catch ME 
%         pause(1)
%         'COM46 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM46'))));
%         s10 = serial('COM46');
%         s10.Baudrate=115200;
%         s10.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s10];
% 
% test = 1;
% s11 = serial('COM28');
% s11.Baudrate=115200;
% s11.InputBufferSize = 100;
% while test
%     try
%         fopen(s11);
%         test = 0;
%         s11.Status
%     catch ME 
%         pause(1)
%         'COM28 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM28'))));
%         s11 = serial('COM28');
%         s11.Baudrate=115200;
%         s11.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s11];
% 
% test = 1;
% s11 = serial('COM38');
% s11.Baudrate=115200;
% s11.InputBufferSize = 100;
% while test
%     try
%         fopen(s11);
%         test = 0;
%         s11.Status
%     catch ME 
%         pause(1)
%         'COM38 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM38'))));
%         s11 = serial('COM38');
%         s11.Baudrate=115200;
%         s11.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s11];
% 
% 
% test = 1;
% s12 = serial('COM48');
% s12.Baudrate=115200;
% s12.InputBufferSize = 100;
% while test
%     try
%         fopen(s12);
%         test = 0;
%         s12.Status
%     catch ME 
%         pause(1)
%         'COM48 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM48'))));
%         s12 = serial('COM48');
%         s12.Baudrate=115200;
%         s12.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s12];
% 
% 
% test = 1;
% s13 = serial('COM50');
% s13.Baudrate=115200;
% s13.InputBufferSize = 100;
% while test
%     try
%         fopen(s13);
%         test = 0;
%         s13.Status
%     catch ME 
%           pause(1)
%         'COM50 failed'
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM50'))));
%         s13 = serial('COM50');
%         s13.Baudrate=115200;
%         s13.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s13];
% 
% test = 1;
% s14 = serial('COM52');
% s14.Baudrate=115200;
% s14.InputBufferSize=100;
% while test
%     try
%         fopen(s14);
%         test = 0;
%         s14.Status
%     catch ME 
%            pause(1)
%         'COM52 failed'
%         ME
%         s = instrfindall;
%         delete(s(find(strcmp(s.Port, 'COM52'))));
%         s14 = serial('COM52');
%         s14.Baudrate=115200;
%         s14.InputBufferSize = 100;
%     end
% end
% serialVector = [serialVector s14];
% 
% 
% s15 = serial('COM10');
% s15.Baudrate=115200;
% serialVector = [serialVector s15];
% fopen(s15);
% s15.Status
%
% s16 = serial('COM10');
% s16.Baudrate=115200;
% serialVector = [serialVector s16];
% fopen(s16);
% s16.Status
%
% s17 = serial('COM10');
% s17.Baudrate=115200;
% serialVector = [serialVector s17];
% fopen(s17);
% s17.Status
%
% s18 = serial('COM10');
% s18.Baudrate=115200;
% serialVector = [serialVector s18];
% fopen(s18);
% s18.Status
%
% s19 = serial('COM10');
% s19.Baudrate=115200;
% serialVector = [serialVector s19];
% fopen(s19);
% s19.Status
%
% s20 = serial('COM10');
% s20.Baudrate=115200;
% serialVector = [serialVector s20];
% fopen(s20);
% s20.Status
% 
% %fopen([s1,s2,s3,s4,s9,s10,s11,s12,s13,s14]);
% 
% toc














