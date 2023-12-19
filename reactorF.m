% Given conditions
reactorVolumes = [10, 10, 20, 20, 20]; % Liters for each reactor
numReactors = length(reactorVolumes);
reactionTime = 1 * 120 * 60; % 3 hours converted to seconds
initialConcentration = 1; % Equal molar concentrations of methanol and carbon monoxide
temperature = 150; % Celsius

% Constants
rateConstant = 0.1; % Example rate constant (adjust as needed)
gasConstant = 8.314; % J/(mol·K), universal gas constant

% Stoichiometry
stoichiometryMethanol = -1; % mol/L (based on reaction)
stoichiometryCarbonMonoxide = -1; % mol/L (based on reaction)
stoichiometryAceticAcid = 1; % mol/L (based on reaction)

% Time range for the reaction
time = linspace(0, reactionTime, 100); % Adjust the number of points as needed

% Initialize arrays to store concentrations and amounts produced for each reactor
methanolConcentrations = initialConcentration * ones(numReactors, 1);
carbonMonoxideConcentrations = initialConcentration * ones(numReactors, 1);
aceticAcidConcentrations = zeros(numReactors, 1);
amountProduced = zeros(numReactors, length(time));

% Loop over time points
for j = 2:length(time)
    dt = time(j) - time(j-1);

    % Loop over reactors
    for i = 1:numReactors
        % Adjust reaction rate based on temperature (Arrhenius equation)
        reactionRate = rateConstant * methanolConcentrations(i) * carbonMonoxideConcentrations(i);

        % Adjust reaction rate based on reactor volume
        reactionRate = reactionRate / reactorVolumes(i);

        % Update concentrations based on stoichiometry
        methanolConcentrations(i) = methanolConcentrations(i) + stoichiometryMethanol * reactionRate * dt;
        carbonMonoxideConcentrations(i) = carbonMonoxideConcentrations(i) + stoichiometryCarbonMonoxide * reactionRate * dt;
        aceticAcidConcentrations(i) = aceticAcidConcentrations(i) + stoichiometryAceticAcid * reactionRate * dt;

        % Accumulate amount produced over time for each reactor
        amountProduced(i, j) = aceticAcidConcentrations(i) * reactorVolumes(i);
    end
end

% Plot the results
figure;
subplot(2, 1, 1);
plot(time, reactionRate * ones(size(time)), '-o'); % Constant reaction rate for illustration
xlabel('Time (s)');
ylabel('Reaction Rate (mol/L·s)');
title('Reaction Rate Over Time');

subplot(2, 1, 2);
hold on;
for i = 1:numReactors
    plot(time, amountProduced(i, :), '-o', 'DisplayName', sprintf('Reactor %d', i));
end
hold off;
xlabel('Time (s)');
ylabel('Amount of Acetic Acid Produced (mol)');
title('Accumulated Acetic Acid Over Time');
legend('show');

% Find the index corresponding to 20 minutes
timeAt90Minutes = 90 * 60; % Convert 20 minutes to seconds
indexAt90Minutes = find(time >= timeAt20Minutes, 1);

% Print the amount of acetic acid produced at 20 minutes for each reactor
for i = 1:numReactors
    fprintf('Reactor %d: Amount of Acetic Acid Produced at 20 minutes: %.4f mol\n', i, amountProduced(i, indexAt20Minutes));
end
