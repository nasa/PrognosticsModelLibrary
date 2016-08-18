function test
% test   Test battery model for various conditions.
% 
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Create battery model
battery = Battery.Create;

% Simulate for default conditions
[T1,X1,U1,Z1] = battery.simulate(3100,'printTime',60);

% Plot results
figure;
battery.plotOutputs(T1,Z1);

% Determine end-of-discharge time for these conditions
T = battery.simulateToThreshold();
fprintf('EOD time is %g s\n',T(end));

% Simulate for a variable load profile
% Specified by a sequence of pairs of numbers, where the first is the load
% (in Watts) and the second is the duration (in seconds).
loads = [8; 10*60; 4; 5*60; 12; 15*60; 5; 20*60; 10; 10*60];
battery.inputEqnHandle = @(P,t)Battery.InputEqn(P,t,loads);
[T2,X2,U2,Z2] = battery.simulate(3150,'printTime',60);

% Plot results
figure;
battery.plotOutputs(T2,Z2);

% Determine end-of-discharge time for these conditions
T = battery.simulateToThreshold();
fprintf('EOD time is %g s\n',T(end));

% Plot results comparing the two simulations
figure;
battery.plotOutputs(T1,Z1,T2,Z2);
