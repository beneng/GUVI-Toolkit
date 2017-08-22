%Function that calls coordinate transformation code that Gonzalo wrote
% xyz_eci is  3 x nScans matrix, 3 for x,y,z 
% year,day, month are just regular integers
% limb_time is a vector containing the 
function [xyz_gse] = COORD_TRANS_MASTER_GEO2GSE(xyz_eci, year_,day_,month_,limb_time)

	% 1 : Write code to take in the arguments so a *.eci can be written 
	% 2 : Run script 
	% 3 : Read the output file


	% Part 1 -> Format the data for processing

	k = length(limb_time);      % Lenght of orbit
	% Creating ECI file
	%fname = 'C:/Users/Gonzalo/Desktop/CXFORM_RLS/data.eci';
	fname = 'data.eci';
	fileID = fopen(fname,'wb');
	% Writing ID
	id = 0;
	fwrite(fileID,id,'int');  
	% Writing Data size
	fwrite(fileID,k,'int');
	% Writing Time and Vector
	% points = zeros(3,1);    % For ECI coordinates
	%Format: dd0,mm0,yy0,hh0,mm0,ss0,x0,y0,z0,dd1,mm1, ...

	hours =[];
	minutes =[];
	seconds =[];
    
    year =[];
    day = [];
    month = [];

	for jj = 1:length(limb_time)

		hora = limb_time(jj)/3600;
    	mins = (hora-floor(hora))*60;
    	secs = (mins-floor(mins))*60;
    	hours = [hours, floor(hora)];
    	minutes = [minutes, floor(mins)];
    	seconds = [seconds, floor(secs)];
        year = [year, year_];
        day = [day, day_];
        month = [month, month_];
	
	end



	day = day;
	month = month;
	year = year;
	hour = hours ;
	minute = minutes;
	second = seconds;
	points = xyz_eci;

	for i = 1:k

		fwrite(fileID,day(i),'int');
    	fwrite(fileID,month(i),'int');
    	fwrite(fileID,year(i),'int');
    	fwrite(fileID,hour(i),'int');
    	fwrite(fileID,minute(i),'int');
    	fwrite(fileID,second(i),'int');  
    	pnts  = points(:,i);  %<--  X,Y,Z%
    	fwrite(fileID,pnts,'double');

    end 
    fclose(fileID);

	%	Part 2 -> Run terminal command to read the *.eci file and 
	% 	and obtain the *.gse file
	
	command = './../../../Desktop/NASA_CODE_CONVERT/main  data.eci 2 3';
    system(command);

	
	%	Part 3 -> read output.gse and put it into the return variable

	fileID = fopen('output.gse','r');
	points = zeros(3,k);
	for i=1:k
 	   points(:,i) = fread(fileID,3,'double=>double');
	end
	fclose(fileID);
	xyz_gse = points;






end