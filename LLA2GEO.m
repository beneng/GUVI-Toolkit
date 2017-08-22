% Function that take Lat,Lon,Alt and converts it to GEO coordinates


function [xyz_geo] = LLA2GEO(lat, lon, alt)

	R_E = 6371; % earth radius in km
	r_geo = R_E + alt;
	GX = r_geo .* cos(lat*pi/180) .* cos(lon*pi/180);
	GY = r_geo .* cos(lat*pi/180) .* sin(lon*pi/180);
	GZ = r_geo .* sin(lat*pi/180);

	xyz_geo = [GX,GY,GZ]';

end 



