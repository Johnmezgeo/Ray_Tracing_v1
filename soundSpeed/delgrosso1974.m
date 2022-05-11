
function [C_stp, overall_check] = delgrosso1974(S, T, P)
    %%
    % Sound speed equation
    % C_stp = C_000 + dC_t + dC_s + dC_stp
    %%
    % C_000= 1402.392
    % dC_t = 0.501109398873E+1 .* T
    %       -0.550946843172E-1 .* T.^2
    %       +0.221535969240E-3 .* T.^3
    % 	
    % dC_s = 0.132952290781E+1 .* S
    %       +0.128955756844E-3 .* S.^2
    % 	
    % dC_p = 0.156059257041E+0 .* P
    %       +0.244998688441E-4 .* P.^2
    %       -0.883392332513E-8 .* P.^3
    % 
    % dC_stp = -0.127562783426E-1 .* T .* S
    % 	 +0.635191613389E-2 .* T .* P
    % 	 +0.265484716608E-7 .* T.^2 .* P.^2
    % 	 -0.159349479045E-5 .* T .* P.^2
    % 	 +0.522116437235E-9 .* T .* P.^3
    % 	 -0.438031096213E-6 .* T.^3 .* P
    % 	 -0.161674495909E-8 .* S.^2 .* P^2
    % 	 +0.968403156410E-4 .* T.^2 .* S
    % 	 +0.485639620015E-5 .* T .* S.^2 .* P
    % 	 -0.340597039004E-3 .* T .* S .* P
        
    %% Validity range
    % T: deg c;     range 0 to 35
    % S: psu;       range 0 to 45
    % P: kg/cm^2;   range 0 to 1000 

    %% check senerio validity
    overall_check= stp_val_check(S, T, P);
    if overall_check(1)
        C_stp = delgrosso1974_inner(S, T, P); % call your sound speed fucntion here
    else
        C_stp = NaN;
    end
    
%%
    function C_stp = delgrosso1974_inner(S, T, P)
        C_000= 1402.392;

        dC_t = 0.501109398873E+1 .* T ...
              -0.550946843172E-1 .* T.^2 ...
              +0.221535969240E-3 .* T.^3;

        dC_s = 0.132952290781E+1 .* S ...
              +0.128955756844E-3 .* S.^2;

        dC_p = 0.156059257041E+0 .* P ...
              +0.244998688441E-4 .* P.^2 ...
              -0.883392332513E-8 .* P.^3;

        dC_stp = -0.127562783426E-1 .* T .* S ...
             +0.635191613389E-2 .* T .* P ...
             +0.265484716608E-7 .* T.^2 .* P.^2 ...
             -0.159349479045E-5 .* T .* P.^2 ...
             +0.522116437235E-9 .* T .* P.^3 ...
             -0.438031096213E-6 .* T^3 .* P ...
             -0.161674495909E-8 .* S.^2 .* P.^2 ...
             +0.968403156410E-4 .* T.^2 .* S ...
             +0.485639620015E-5 .* T .* S.^2 .* P ...
             -0.340597039004E-3 .* T .* S .* P;

        C_stp = C_000 + dC_t + dC_s + dC_p + dC_stp;
    end
end
