

%% Calculate travel time (tt)
% estmate sound speed in layer using dt = dz/ss_in_layer
function [ss_hmc, dt_4hss] = hss(depth, ss_vec)
    dz = diff(depth);
    ss_layer = (ss_vec(1: end-1) + ss_vec(2:end))/2;
    dt = dz./ss_layer;
    
    dz_sum = 0;
    dt_sum = 0;
    dz_4hss = NaN(length(dz),1);
    dt_4hss = NaN(length(dz),1);
    
    for i = 1: length(dz)
        dz_sum = dz_sum + dz(i);
        dz_4hss(i,1) = dz_sum;
        dt_sum = dt_sum + dt(i);
        dt_4hss(i,1) = dt_sum;
    end
    
    ss_hmc = dz_4hss./dt_4hss;
end

%%

