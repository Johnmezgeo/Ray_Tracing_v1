function [r, dr, z, t_n] = cssg(dep_ang, depth, ss_vec)

    dc = diff(ss_vec);
    dz = diff(depth);
    g = dc./dz;
    k = cosd(dep_ang)./ss_vec(1);
    
    beta = acosd(ss_vec(1:end) .*k);
    beta_n_minus1 = beta(1:end-1,:);
    beta_n =  beta(2:end,:);
    
    c_n_minus1 = ss_vec(1:end-1);
    R_n = c_n_minus1 ./(g.*cosd(beta_n_minus1));
    dr = R_n.*(sind(beta_n_minus1) - sind(beta_n));
    dz_n = R_n.*(cosd(beta_n) - cosd(beta_n_minus1));
    
    c_n = ss_vec(2:end,:);
    
    c_k = c_n ./ c_n_minus1;
    t_n = (1 ./ g) .* log(c_k .* (1 + sind(beta_n_minus1)) ./ (1 + sind(beta_n)));
    
    

    n_beams = length(dep_ang);
    n_surfaces = length(depth);
    
    r = zeros(n_surfaces, n_beams);
    z = zeros(n_surfaces, n_beams);
    z(1,:) = depth(1);
    
    dr_sum = zeros(1, n_beams);
    dz_sum = ones(1, n_beams).*depth(1);
    
    [nrow, ~] = size(dr);
    
    for i = 1: nrow
        dr_sum = dr_sum + dr(i, :);
        dz_sum = dz_sum + dz_n(i, :);
        r(i+1, :) = dr_sum; 
        z(i+1, :) = dz_sum;
    end
end
