%Generates spatio-temporal matrices of the 2003 Super L1B data

%% Read the contents in the directory

fnames = dir('SUPERL1B_2003');
[num_files , rv] = size(fnames);

l1b_fnames =[];
for idx = 1:num_files
    
    if(~isempty(strfind(string(fnames(idx).name),'.mat')))
        l1b_fnames=[l1b_fnames,strcat('SUPERL1B_2003/',string(fnames(idx).name))];
    end
end

%% Read *.mat sequentially


full_keo = [];
anc_data = [];
for idx = 1:365
    
    [keo_day, anc_day] = proccess_ST_NoFilter(l1b_fnames(idx));
    
    %Full spatial temporal plot
    full_keo = [full_keo, keo_day'];
    anc_data = [anc_data, anc_day];





end

