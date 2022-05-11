
% Temperature validity check
function  overall_check = stp_val_check(S, T, P)
    % Salinity validity check
    if S < 0 || S > 45
        sal_check  = false;
    else 
        sal_check = true;
    end

    % Temperature validity check
    if T < 0 || T > 35
        temp_check = false;
    else
        temp_check = true;
    end
    
    % Pressure validity check
    if P < 0 || P > 1000
        press_check = false;
    else 
        press_check = true;
    end
    
    % sound speed validity check
	ss_val = and(and(temp_check, sal_check), press_check);
	overall_check=[ss_val, sal_check, temp_check, press_check];  
end
