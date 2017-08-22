function[valid_dusk,valid_dawn] = geo_right4(xgse,ygse,zgse,sza)
        
        %Initialize the return variables
        valid_dawn = false;
        valid_dusk = false;


        % Convert coordinates to theta_gse
        theta = (180/pi)*atan2(zgse,sqrt(xgse^2+ygse^2));
        if(abs(theta)<=2)
            %Check SZA of the tangenpoint altitude center pixel
            if(sza>70 && sza<110)

                if (ygse<0)
                 valid_dusk= true; 
                end

                if (ygse>0)
                  valid_dawn = true;
                end
            
            end
        end


end