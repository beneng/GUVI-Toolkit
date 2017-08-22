function [keo_dusk,keo_dawn] = proccessSingleDay (fname)
    
    %ST plot to be returned
    keo_dusk =[];
    keo_dawn =[];
    
    % Read mat file
    load(char(fname));
    
    %Read number of files in a given day
    [scratch, num_l1b]= size(out_oi.ARRAY_LD);
    
    for idx_ = 1:num_l1b
        
        %Find how many scans are in the given orbit
        scan_struct = out_oi.ARRAY_LD(idx_);
        
        %Obtain limb_scan from orbit
        limb_scans = scan_struct.LIMB;
        
        
        %Count the number scans in the orbit in addition to time
        num_scans = numel(scan_struct.TIME);
        year = (scan_struct.YYYY);
        time_s = (scan_struct.TIME);
        ddd =str2num(scan_struct.str);
        v = datevec(datenum(year, 1, ddd));
        
        year = v(1);
        month = v(2);
        day = v(3);
        
        
        %Perform averaging
        scan_count_dusk =0;
        scan_avg_dusk = zeros([32,1]);
        
        scan_count_dawn = 0;
        
        %Iterate through number of scans within the given orbit
        for jj = 1:num_scans
            
            %Obtain tangentpoint middle
            tp_lat = limb_scans.TP_Lat(16,jj);
            tp_lon = limb_scans.TP_Long(16,jj);
            tp_alt = limb_scans.TP_Alt(16,jj);
            tp_sza = limb_scans.SZA_c(16,jj);
            
           
            %Convert to geo
            xyz_geo = LLA2GEO(tp_lat,tp_lon,tp_alt);
            
            %Convert to GSE
            xyz_gse = COORD_TRANS_MASTER_GEO2GSE(xyz_geo, year,day,month,limb_time)
            
            [valid_dusk,valid_dawn] = geo_right4(xyz_gse(1),xyz_gse(2),xyz_gse(3),tp_sza);
            
            %Check if scan is within desired viewing geometry
            if(valid_dusk)
                
            end
            
            %Add scans
            
            %Return
            
            
            
            
            
        end
        
        
        
        
        
        
    end
    



end