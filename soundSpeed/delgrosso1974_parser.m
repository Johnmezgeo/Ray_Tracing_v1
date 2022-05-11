
function [ss_vec, delgrosso1974_val_check] = delgrosso1974_parser(depth, temp, sal, latd)
%% Loop through the senario table
    data_len = length(depth);
    ss_vec = NaN(data_len,1);   % sound speed vector
    P_vec = NaN(data_len,1);    % presure vecor
    delgrosso1974_val_check = false(data_len,4);

    for row = 1:data_len
        D = depth(row);
        T = temp(row);
        S = sal(row);

        %% Calculate pressure from given depth, temp, sal, and lat
        % zts2p computes pressure in dbar, where depth is in meter
        % since NRL II uses P in kgf/cm2 = 98.0665 kPa = 9.80665 decibars (db)
        % dbar to kg/cm^2 conversion constant  = 1/9.80665 = 0.10197162

        P =  0.101971621297793 * zts2p(D, T, S, latd); 
        P_vec(row) = P;

        %% Compute sound speed for selected equations
        % check senerio validity
        [ss_vec(row), overall_check] = delgrosso1974(S, T, P); % call your fucntion here 
        delgrosso1974_val_check(row,:) = overall_check;
        fprintf('%.4f\n', ss_vec(row))

    end
end
