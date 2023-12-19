% Constants and data for methanol and acetic acid
MW_methanol = 32.0422; % Molecular weight of methanol (g/mol)
MW_acetic_acid = 60.0526; % Molecular weight of acetic acid (g/mol)
xF_feed = 0.5; % Mole fraction of methanol in the feed

% Feed conditions
F_feed = 77.637; % Total molar feed rate (mol/hr)
xM_feed = xF_feed; % Mole fraction of methanol in the feed
xCO_feed = 1 - xF_feed; % Mole fraction of carbon monoxide in the feed

% Initial assumptions
R = 3; % Initial reflux ratio
xD = 0.985; % Desired purity of acetic acid in the distillate

% Maximum number of iterations
maxIterations = 100;

% McCabe-Thiele Method
for iteration = 1:maxIterations
    % Enriching section operating line (Eq. 1)
    y = @(x) R/(R+1)*x + xD/(R+1);

    % Stripping section operating line (Eq. 2)
    L_over_V = 1/(y(xD) - xD); % L/V ratio
    xB = 0; % Assume bottoms composition is pure methanol
    x = @(y) L_over_V*y + xB;

    % Intersection of operating lines
    q = (xD - xB)/(y(xD) - x(xD));
    xF = xB + q;

    % Check for convergence
    if abs(xF - xF_feed) < 1e-6
        disp(['Converged in ', num2str(iteration), ' iterations.']);
        break;
    end

    % Adjust reflux ratio based on convergence
    R = R * (xF_feed / xF);

    % If maximum iterations reached, display a message
    if iteration == maxIterations
        disp('Maximum iterations reached. Consider adjusting initial values.');
    end
end

% Column efficiency
N_theoretical = log((1-xD)/xD)/log((1-xF)/xF);
N_actual = N_theoretical / 1.2; % Assuming 80% column efficiency

% Fractional recoveries
B = F_feed * (xD - xF_feed) / (xD - xB);
D = F_feed * (xF_feed - xB) / (xD - xB);
FLKR = xD / xF_feed;
FHKR = (1 - xD) * D / ((1 - xF_feed) * F_feed);

disp(['Product Purity in Distillate (xD): ', num2str(xD)]);

disp(['Reflux Ratio (R): ', num2str(R)]);
disp(['Number of Theoretical Trays: ', num2str(N_theoretical)]);
disp(['Number of Actual Trays: ', num2str(N_actual)]);
disp(['Bottoms Rate (B): ', num2str(B), ' mol/hr']);
disp(['Distillate Rate (D): ', num2str(D), ' mol/hr']);
disp(['Fractional Light Key Recovery (FLKR): ', num2str(FLKR)]);
disp(['Fractional Heavy Key Recovery (FHKR): ', num2str(FHKR)]);
