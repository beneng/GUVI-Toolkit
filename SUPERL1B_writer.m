%After running rad_scan_angle_MUL_DOY_ALT_UT.m, divide the output 
%and save it

%Iterate through each struct in out
for i = 1:365
    out_oi = out(i);
    fname = strcat('SUPERL1B_2003_D_',num2str(i),'.mat');
    save(fname,'out_oi');
end