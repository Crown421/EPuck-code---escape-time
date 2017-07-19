%% init file
ecdat.names={};
ecdat.nr=[];
ecdat.thres=[];
ecdat.escT=[];
ecdat.collcount={};
ecdat.msense={};
ecdat.colls={};

save('escape_data','ecdat');
%%
nrR=16; %0, 8 , 16
fnames=dir(sprintf('data/%d_*',nrR));
fnames={fnames(:).name};
maxNrF=length(fnames);
disp(maxNrF);

%%
m=14;
graylvl=925;
blacklvl=750;
ecdat=process_escape_data( graylvl, blacklvl, fnames{m} )

%% brute force batch processing
fnames=dir(sprintf('data/*_esc*',nrR));
fnames={fnames(:).name};
maxNrF=length(fnames);
graylvl=925;
blacklvl=750;
for m=1:maxNrF
ecdat=process_escape_data( graylvl, blacklvl, fnames{m} );
end