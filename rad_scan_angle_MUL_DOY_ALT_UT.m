 function [PROC_DOY] = rad_scan_angle_MUL_DOY_ALT_UT(PROC_DOY,year,doys,doye)
% rad_scan_angle_MUL_DOY
% Created Oct 11, 2016 
% YP 
% ENTER THE year and doy or change the year and doy in the script
% OR RUN load('ARRAY_2003_DOY.mat',str) if STRUCT FOR THAT YEAR ALREADY
% EXISTS
% ALL FILES MUST BE UNZIPPED
% IF YOU ARE WORKING WITH ZIPPED FILES UNCOMMENT LINES 47-48 % gunzip('*.gz'); % delete('*.gz');
% NOTE THIS IS FOR COMBO LIMB-DISK FILE (VER12)
% SCRIPT GENERATES AN ARRAY (STRUCT WITHIN STRUCT) FOR THAT YYYY/str START TO END i.e. MULTIPLE DOYS
% and for each str 15 ORBITS
% This is one step ahead of rad_scan_angle_ONE_DOY
% %% SETTING VALUES MANUALLY
% str = [];
% t = num2cell([2003, 79, 80]);
% [year,doys,doye] = deal(t{:});
%% 
% addpath(genpath('/Volumes/LaCie/GUVI_SuperL1B/'));
% load('PROC_ARRAY_2002_DOY_Alt_UT.mat')
str = PROC_DOY;
yyyy_start = year; %year
doy_start = doys; %doy
doy_end = doye; %365
% % === LOOP OVER DAYS === 
doy_all = doy_start:doy_end;
for idoy = 1:length(doy_all)
    ddd = num2str(doy_all(idoy));
    n = 3-length(ddd);
    while n>0, ddd = strcat('0',ddd); 
        n = 3-length(ddd); 
    end
    doystr(idoy,:) = ddd;
end
yyyystr = num2str(yyyy_start.*ones(length(doystr(:,1)),1));
yyyydoy = [yyyystr doystr];
%
for i = 1:length(yyyydoy(:,1)) 
disp(['Day ' num2str(yyyydoy(i,5:7)) ' of 365']) %365
% cd('/Volumes/GUVI_data/NEW GUVI DATA/');
% cd('/Volumes/GUVI_data/GUVI_SuperL1B/');
% cd('/Volumes/LaCie-24TB/GUVI_SuperL1B'); %% SERVER LOCATION 
cd('/Volumes/LaCie/GUVI_SuperL1B'); %% SERVER LOCATION 
cd(yyyydoy(i,1:4));

%% ----------
%% TO BE DEBUGGED - IF 028 str doesnt' exist why exist(yyyydoy(i,5:7),'dir') gives output 7
% yyyydoy(i,1:4)
% str=num2str(yyyydoy(i,5:7))
% exist(yyyydoy(i,5:7),'dir') 
% ls
%% ----------

if exist(yyyydoy(i,5:7),'dir')==7 % then the str directory exists
   cd(yyyydoy(i,5:7));
%     gunzip('*.gz');
%     delete('*.gz');
    fnames = dir('*.image_L1B'); 
    for k = 1:length(fnames)   
        fname = fnames(k).name;
%         orbit_fname ='GUVI_Av'; %GUVI_im_disk_
%         if strmatch(orbit_fname,fname)
        %fname = 'GUVI_Av0107r001_2003140REV18668QONA.image_L1B';
        ncid = netcdf.open(fname,'NC_NOWRITE');
            % === LOAD AND PROCESS GUVI DATA ===
dim=400;
disk_sz=159;
limb_sz=32;
m=str2num(yyyydoy(i,5:7));
if isempty(str)
    %% DISK DATA READ AND TO BE SAVED IN STRUCT
    str(m).ARRAY_LD(k).DISK.SZA_c = zeros(disk_sz,dim); %changed from 1 to disk_sz
    str(m).ARRAY_LD(k).DISK.PP_Lat = zeros(disk_sz,dim);
    str(m).ARRAY_LD(k).DISK.PP_Long = zeros(disk_sz,dim);
    str(m).ARRAY_LD(k).DISK.PP_Alt = zeros(disk_sz,dim);
  %  DISK.PP_Zenith = zeros(dim,disk_sz);
    str(m).ARRAY_LD(k).DISK.ScanAngle = zeros(disk_sz,dim);
    str(m).ARRAY_LD(k).DISK.LyA_Rad = zeros(disk_sz,dim);
    %% LIMB DATA READ AND TO BE SAVED IN STRUCT
    str(m).ARRAY_LD(k).LIMB.SZA_c = zeros(limb_sz,dim); %changed from 1 to limb_sz
    str(m).ARRAY_LD(k).LIMB.TP_Lat = zeros(limb_sz,dim);
    str(m).ARRAY_LD(k).LIMB.TP_Long = zeros(limb_sz,dim);
    str(m).ARRAY_LD(k).LIMB.TP_Alt = zeros(limb_sz,dim);
  %  LIMB.TP_Zenith = zeros(dim,limb_sz);
    str(m).ARRAY_LD(k).LIMB.ScanAngle = zeros(limb_sz,dim);
    str(m).ARRAY_LD(k).LIMB.LyA_Rad = zeros(limb_sz,dim);
end
% %% DATA TO BE READ FROM THE COMBINED LIMB+DISK FILE
% %
    %% COMMON DATA FOR ONE ORBIT
str(m).ARRAY_LD(k).TIME = netcdf.getVar(ncid,6); %TIME ms from day start
str(m).ARRAY_LD(k).Alt = netcdf.getVar(ncid,9); %Spacecraft Altitude

gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),24);
str(m).ARRAY_LD(k).F107_DAILY = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
%
gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),26);
str(m).ARRAY_LD(k).Kp_HOUR = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
%
gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),27);
str(m).ARRAY_LD(k).Kp_DAILY = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
%
gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),29);
str(m).ARRAY_LD(k).Ap_DAILY = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
%
gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),14);
str(m).ARRAY_LD(k).Starting_TIME = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
str_time=str(m).ARRAY_LD(k).Starting_TIME;
str(m).ARRAY_LD(k).str = str_time(5:7);
str(m).ARRAY_LD(k).Starting_TIME = str_time(8:13);
%
gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),16);
str(m).ARRAY_LD(k).Orbit = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
%
gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),21);
str(m).ARRAY_LD(k).YYYY = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
%LIMB NEW v012 DATA
% READING DATA
All_Radiance_Limb = netcdf.getVar(ncid,38); %LIMB
Lat_Limb = netcdf.getVar(ncid,46);
Long_Limb = netcdf.getVar(ncid,47);
Alt_Limb = netcdf.getVar(ncid,48);
SZA_Limb = netcdf.getVar(ncid,37);
ScanAngle_Limb = netcdf.getVar(ncid,5);
% STAR FLAG - BAD DATA
StarFlag = netcdf.getVar(ncid,52); %(ncid,8)
StarFlag = reshape(StarFlag,numel(StarFlag),1);
% DQI - BAD DATA
DQI = netcdf.getVar(ncid,50);  %%  DQI COMMENTED OUT - NEW DQI NOT KNOWN
H_DQI = DQI;
H_DQI = reshape(H_DQI,numel(H_DQI),1);
% PROCESSING - AVERAGING MIDDLE 5:10 PXS 
Rad_Limb = squeeze(All_Radiance_Limb(1,:,:,:));    
RadLimb = cast(Rad_Limb,'double');
RadLimb(RadLimb>5e4) = NaN;
RadLimb(RadLimb<0)= NaN;
RadLimb(StarFlag==1) = NaN;
RadLimb(H_DQI~=0) = NaN;
%%
RadLimb = squeeze(mean(RadLimb(5:10,:,:)));
LatLimb = squeeze(mean(Lat_Limb(5:10,:,:)));
LongLimb = wrapTo180(squeeze(mean(Long_Limb(5:10,:,:))));
AltLimb = squeeze(mean(Alt_Limb(5:10,:,:)));
SZALimb = squeeze(mean(SZA_Limb(5:10,:,:)));
ScanAngleLimb = (mean(ScanAngle_Limb,2))*(-1)+180;
% CLEAR READ NON-AVG DATA
clear All_Radiance_Limb Rad_Limb Lat_Limb Long_Limb Alt_Limb SZA_Limb ScanAngle_Limb
%DISK NEW v012 DATA
% READING DATA
All_Radiance_Disk = netcdf.getVar(ncid,20); %DISK
Lat_Disk = netcdf.getVar(ncid,29);%Lat
Long_Disk = netcdf.getVar(ncid,30);%Long
Alt_Disk = netcdf.getVar(ncid,28);
SZA_Disk = netcdf.getVar(ncid,19);
ScanAngle_Disk = netcdf.getVar(ncid,2);
% PROCESSING - AVERAGING MIDDLE 5:10 PXS 
Rad_Disk = squeeze(All_Radiance_Disk(1,:,:,:));    
RadDisk = cast(Rad_Disk,'double');
RadDisk(RadDisk>5e4) = NaN;
RadDisk(RadDisk<0)= NaN;
RadDisk(StarFlag==1) = NaN;
RadDisk(H_DQI~=0) = NaN;
RadDisk = squeeze(mean(RadDisk(5:10,:,:)));
LatDisk = squeeze(mean(Lat_Disk(5:10,:,:)));
LongDisk = wrapTo180(squeeze(mean(Long_Disk(5:10,:,:))));
AltDisk = ones(size(LatDisk))*Alt_Disk;
SZADisk = squeeze(mean(SZA_Disk(5:10,:,:)));
ScanAngleDisk = (mean(ScanAngle_Disk,2))*(-1)+180;
% CLEAR READ NON-AVG DATA
clear All_Radiance_Disk Rad_Disk Lat_Disk Long_Disk Alt_Disk SZA_Disk ScanAngle_Disk StarFlag DQI H_DQI
netcdf.close(ncid)
%% SAVE IN ARRAY
    str(m).ARRAY_LD(k).DISK.SZA_c = SZADisk;
    str(m).ARRAY_LD(k).DISK.PP_Lat = LatDisk;
    str(m).ARRAY_LD(k).DISK.PP_Long = LongDisk;
    str(m).ARRAY_LD(k).DISK.PP_Alt = AltDisk;
 %   str.ARRAY_LD.DISK.PP_Zenith = zeros(dim,disk_sz);
    str(m).ARRAY_LD(k).DISK.ScanAngle = ScanAngleDisk;
    str(m).ARRAY_LD(k).DISK.LyA_Rad = RadDisk;
    %% LIMB DATA READ AND TO BE SAVED IN STRUCT
    str(m).ARRAY_LD(k).LIMB.SZA_c = SZALimb;
    str(m).ARRAY_LD(k).LIMB.TP_Lat = LatLimb;
    str(m).ARRAY_LD(k).LIMB.TP_Long = LongLimb;
    str(m).ARRAY_LD(k).LIMB.TP_Alt = AltLimb;
 %   str.ARRAY_LD.LIMB.TP_Zenith = zeros(dim,limb_sz);
    str(m).ARRAY_LD(k).LIMB.ScanAngle = ScanAngleLimb;
    str(m).ARRAY_LD(k).LIMB.LyA_Rad = RadLimb;
    end
  % gzip('*.image_L1B'); UNCOMMENT IF YOU WANT TO ZIP THE FILES AFTER
  % READING
continue;
end
end
PROC_DOY = str;
% cd('/Users/Praju/Documents/MATLAB/March 2017/DATA/SUNLIT/2003');
save PROC_ARRAY_2003.mat PROC_DOY -v7.3
