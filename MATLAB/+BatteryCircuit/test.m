function test
% test   Test battery equivalent circuit model for various conditions.
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Create battery model
battery = BatteryCircuit.Create;

% Simulate for default conditions
[T,X,U,Z] = battery.simulate(3800,'printTime',60);

% Plot results
figure;
battery.plotOutputs(T,Z);

% Determine end-of-discharge time for these conditions
T = battery.simulateToThreshold();
fprintf('EOD time is %g s\n',T(end));

% Simulate for a variable load profile
% Specified by a sequence of pairs of numbers, where the first is the load
% (in Watts) and the second is the duration (in seconds).
loads = [2 10*60 1 5*60 4 15*60 2 20*60 3 10*60];
battery.inputEqnHandle = @(P,t)BatteryCircuit.InputEqn(P,t,loads);
[T,X,U,Z] = battery.simulate(3000,'printTime',60);

% Plot results
figure;
battery.plotOutputs(T,Z);

% Determine end-of-discharge time for these conditions
T = battery.simulateToThreshold();
fprintf('EOD time is %g s\n',T(end));
