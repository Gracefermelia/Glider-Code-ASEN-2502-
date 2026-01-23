function [WingGeo_Data] = WingGeo(Design_Input,Count,Plot_WingGeo_Data)
%% Wing Geometry Function

% Number of configurations
Count = height(Design_Input);

%% Preallocate
b_w     = zeros(Count,1);   % Wingspan [m]
cr_w    = zeros(Count,1);   % Root chord [m]
ct_w    = zeros(Count,1);   % Tip chord [m]
MAC_w   = zeros(Count,1);   % Mean aerodynamic chord [m]
y_MAC_w = zeros(Count,1);   % MAC y-location [m]
x_MAC_w = zeros(Count,1);   % MAC x-location [m]

%% Loop through configurations
for n = 1:Count

    % Wing span from AR and Sref
    b_w(n) = sqrt( ...
        Design_Input.AR_w(n) * ...
        Design_Input.Sref_w(n) );

    % Root and tip chord
    cr_w(n) = (2 * Design_Input.Sref_w(n)) / ...
              (b_w(n) * (1 + Design_Input.Taper_w(n)));

    ct_w(n) = cr_w(n) * Design_Input.Taper_w(n);

    % Mean Aerodynamic Chord
    MAC_w(n) = (2/3) * cr_w(n) * ...
        ( (1 + Design_Input.Taper_w(n) + Design_Input.Taper_w(n)^2) / ...
          (1 + Design_Input.Taper_w(n)) );

    % MAC location
    y_MAC_w(n) = (b_w(n)/6) * ...
        ( (1 + 2*Design_Input.Taper_w(n)) / ...
          (1 + Design_Input.Taper_w(n)) );

    x_MAC_w(n) = y_MAC_w(n) * ...
        tand(Design_Input.Sweep_w(n)) + 0.25 * MAC_w(n);

end

%% Output table
WingGeo_Data = table( ...
    b_w, cr_w, ct_w, MAC_w, y_MAC_w, x_MAC_w, ...
    'VariableNames', {'b_w','cr_w','ct_w','MAC_w','y_MAC_w','x_MAC_w'} );

%% Plot
if nargin > 1 && Plot_WingGeo_Data == 1
    figure(100)
    barh(WingGeo_Data.b_w)
    grid on
    title('Wingspan Variation by Configuration')
    xlabel('Wingspan (m)')
    ylabel('Design Configuration')

    if ismember('Config', Design_Input.Properties.VariableNames)
        yticklabels(string(Design_Input.Config))
    end
end

end
