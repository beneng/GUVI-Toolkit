function [keo,ancil_struct] = proccess_ST_NoFilter (fname)
    
   
    
    % Read mat file
    load(char(fname));
    
    %Read number of files in a given day
    [scratch, num_l1b]= size(out_oi.ARRAY_LD);
    
    lat_bins = -90:5:95;
    numBins = numel(lat_bins)-1;
    lyA_limb_bin = 32;
    
    keo = zeros([num_l1b,lyA_limb_bin*numBins]);
    
    ancil_struct = [];
    
    for idx = 1:num_l1b
        
        % Count the number of lyman alpha scans that go into a single bin
        keo_count = zeros([numBins,1]);
        keo_tmp = zeros([numBins*lyA_limb_bin,1]);
        
        %Find how many scans are in the given orbit
        scan_struct = out_oi.ARRAY_LD(idx);
        
        % Create structure with F10.7 and date
        doy = str2num(scan_struct.str);
        yy = (scan_struct.YYYY);
        date3 = datevec(datenum(double(yy), 1, doy));
        date_val = strcat(num2str(date3(1)),'-',num2str(date3(2)),'-',num2str(date3(3)));
        f10_7 = str2num(scan_struct.F107_DAILY);
        anc_ex = struct('date',date_val,'f107',f10_7);
        ancil_struct = [ancil_struct, anc_ex];
        
        %Obtain limb_scan from orbit
        limb_scans = scan_struct.LIMB;
        
        [numMes,num_scans] = size(limb_scans.LyA_Rad);
        %Iterate through number of scans within the given orbit
        for jj = 1:num_scans
            
            %Obtain tangentpoint middle
            tp_lat = limb_scans.TP_Lat(16,jj);
           
            %Obtain index for the tangent point latitude
            bin_idx = discretize(tp_lat,lat_bins);
            
            %Where in the columns for the latitude bin
            keo_idx_beg = lyA_limb_bin*(bin_idx-1)+1;
            keo_idx_end = keo_idx_beg+31;
            
            % Normalize by bin 30
            scan_str = limb_scans.LyA_Rad(:,jj)/limb_scans.LyA_Rad(30,jj);
            
            %Add radiances
            keo_tmp(keo_idx_beg:keo_idx_end) = keo_tmp(keo_idx_beg:keo_idx_end)+ scan_str;
            
            %Keep count for averaging purposes
            keo_count(bin_idx) = keo_count(bin_idx)+1;
            
       
        end
        
        %Perform averaging
        for kk = 1:numBins
            %Check if there are zero counts in the bin
            if(keo_count(kk) ~=0)
                 keo_idx_beg = lyA_limb_bin*(kk-1)+1;
                 keo_idx_end = keo_idx_beg+31;
                 keo_tmp(keo_idx_beg:keo_idx_end) = keo_tmp(keo_idx_beg:keo_idx_end)/keo_count(kk);
            end
        end
        
        %Put keo graph for single orbit of the day
        keo(idx,:) = keo_tmp;
        
    end
    
    %Return keogram for all orbits in a given day



end