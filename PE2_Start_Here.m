
clc
clear
close all

%% Input data
cdt_file = 'MAR668_PE2_input.txt';
trans_depth = 2;
beam_ang1 = [20, 45, 70];
beam_ang2 = [-70, -60, -50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70];
beam_ang3 = -70:0.2:70;
dep_ang = 90 - beam_ang1;

%% Parse data
ctd = readtable(cdt_file);
depth = ctd.Depth;
temp = ctd.T;
sal = ctd.S;

%% Calculate sound speed
[ss_vec, overall_check] = delgrosso1974_parser(depth, temp, sal, 45); 
% [ss_vec, mackenzie_val_check] = mackenzie1981_parser(depth, temp, sal);
% [ss_vec, wilson1960_val_check] = wilson1960_parser(depth, temp, sal, 45);

%% Calculate sound speed at the transduser
ss_trans = ss_vec(1) + (trans_depth - depth(1)) *...
                            (ss_vec(2) - ss_vec(1))/(depth(2) - depth(1));

%% replace zero-depth sound speed with transder-depth sound speed
ss_vec(1) = ss_trans;
depth(1) = trans_depth;

%% Harmonic Sound Speed
[ss_hmc, dt_4hss] = hss(depth, ss_vec);

figure
plot([ss_trans;ss_hmc], -depth,'-', 'LineWidth', 1.5)
hold on
plot(ss_vec, -depth,'-', 'LineWidth', 1.5)
ytickformat('%.1f')
ylabel('depth (m)')
legend('harm. sound speed', 'original sound speed', 'Location', 'southeast')
xlabel('sound speed (m/s^2)')
title('HSS')

%% Constant sound speed layer (CSSL) ray tracing
[X, dx, tn, beta_layer] = cssl(dep_ang, depth, ss_vec);
lbl = cell(length(dep_ang),1);
for i = 1:length(dep_ang)
    lbl{i} = strcat("depress ang = ",string(dep_ang(i)),"^o");
end
figure
plot(X, -depth,'-',  'LineWidth', 1.5)
ytickformat('%.0f')
ylabel('depth (m)')
legend(lbl)
xlabel('Horizontal distance "r" (m)')
title('CSSL')

%% Constant sound speed gradient (CSSG) ray tracing
[r, dr, z, t_n] = cssg(dep_ang, depth, ss_vec);

figure 
plot(r, -depth,  'LineWidth', 1.5)
ytickformat('%.1f')
ylabel('depth (m)')
xlabel('Horizontal distance "r" (m)')
legend(lbl)
title('CSSG')

%% Report
% Harmonic sound speed
rep_hdl = fopen('ray_tracing_report.txt', 'w');
fprintf(rep_hdl, '%s\n',  'Harmonic Sound Speed Report');
fprintf(rep_hdl, '%12s %10s %10s %15s %15s\n',...
    'Depth', 'Temp', 'Salinity', 'Sound Speed', 'Harmonic SS');

output_data_format = '%12.3f %10.3f %10.3f %15.4f %15.4f\n';
fprintf(rep_hdl, output_data_format,...
    depth(1), temp(1), sal(1), ss_vec(1), ss_vec(1));

for ii = 1: length(ss_hmc)
    fprintf(rep_hdl, output_data_format,...
        depth(ii+1), temp(ii+1), sal(ii+1), ss_vec(ii+1), ss_hmc(ii));
end

% Constant sound speed layer
fprintf(rep_hdl, '%s\n', '');
fprintf(rep_hdl, '%s\n', '');
fprintf(rep_hdl, '%s\n',  'Constant Sound Speed Layer (CSSL) Ray Tracing');

output_data_format = '%12.3f %15.3f %10.3f %15.3f %10.4f %15.4f\n';
for jj = 1: length(dep_ang)
    fprintf(rep_hdl, 'Beam No: %d; depression ang: %5.2f\n', jj, dep_ang(jj));
    fprintf(rep_hdl, '%12s %15s %10s %15s %10s %15s\n',...
        'Depth', 'S_Speed', 'Angle', 'dX', 'layer_t', 'X-ordinate');
    
    fprintf(rep_hdl, output_data_format,...
        depth(jj), ss_vec(jj), beta_layer(1,jj), 0, 0, X(1,jj));  
    
    [nrow, ~] = size(dx);
    for ii = 1: nrow
        fprintf(rep_hdl, output_data_format, depth(ii+1), ss_vec(ii+1),...
            beta_layer(ii+1,jj), dx(ii,jj), tn(ii, jj), X(ii+1,jj));
    end 
end
fprintf(rep_hdl, '%s\n', '===========================================================================');
fprintf(rep_hdl, '%s\n', '===========================================================================');

% Constant sound speed gradient
fprintf(rep_hdl, '%s\n',  'Constant Sound Speed Gradient (CSSG) Ray Tracing');

output_data_format = '%12.3f %15.3f %15.3f %10.4f %15.4f\n';
for jj = 1: length(dep_ang)
    fprintf(rep_hdl, 'Beam No: %d; depression ang: %5.2f\n', jj, dep_ang(jj));
    fprintf(rep_hdl, '%12s %15s %15s %10s %15s\n',...
        'Depth', 'S_Speed', 'dX', 'layer_t', 'X-ordinate');
    
    fprintf(rep_hdl, output_data_format,...
        depth(jj), ss_vec(jj), 0, 0, r(1,jj));  
    
    [nrow, ~] = size(dr);
    for ii = 1: nrow
        fprintf(rep_hdl, output_data_format,...
            depth(ii+1), ss_vec(ii+1), dr(ii,jj), t_n(ii, jj), r(ii+1,jj));
    end 
end
fclose(rep_hdl);

%%


