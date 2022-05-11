

function [X, dx, tn, beta_layer] = cssl(dep_ang, depth, ss_vec)
% estmate sound speed in layer using dt = dz/ss_in_layer
dz = diff(depth);
ss_layer = (ss_vec(1:end-1) + ss_vec(2:end))/2;
dt = dz./ss_layer;

%%
% K = NaN(length(dz),1); % vector to stack all k for sanity check
k = cosd(dep_ang)./ss_vec(1);

beta_layer = acosd(ss_layer .* k);  % ss_layer
dx = dz ./(tand(beta_layer));

s_n = dz ./(sind(beta_layer));
tn = s_n ./ss_layer;

nrows = length(dep_ang);
X = zeros(length(dz) + 1, nrows);
tally = zeros(1, nrows);
    for ii = 1: length(dz)
        tally = tally + dx(ii,:);
        X(ii+1,:) = tally;
    end
beta_layer = [dep_ang;beta_layer]; 

end 
%%





