function [mid_lat] = findTP_Lats (fname)

    % array to be returned
    mid_lat = [];


    % Load .mat file 
    load(char(fname));
    
    %Number of orbits in the given day
    [scratch, num_l1b]= size(out_oi.ARRAY_LD);
    disp(flag);
    
    for i = 1:num_l1b
    
        LIMB_struct = out_oi.ARRAY_LD(i).LIMB; %Obtain limb structure (contains LyA and TP Lat data)
        lat_arr = LIMB_struct.TP_Lat(16,:); %Obtain center latitude
        mid_lat = [mid_lat,lat_arr];
    end




end