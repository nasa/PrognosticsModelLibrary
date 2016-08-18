function test
% test   Test pneumatic valve model for various conditions.
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Create valve model
valve = PneumaticValve.Create;

% Simulate for default conditions
[T,X,U,Z] = valve.simulate(60,'printTime',60);

% Plot results
figure;
valve.plotOutputs(T,Z);

% Determine end-of-life time with component wear
x0 = valve.getDefaultInitialization(0);
x0(valve.indices.states.wr) = 1e-0;
T = valve.simulateToThreshold('x0',x0);
fprintf('EOL is %g s\n',T(end));

% Determine end-of-life under different conditions
x0 = valve.getDefaultInitialization(0);
x0(valve.indices.states.wi) = 1e-8;
T = valve.simulateToThreshold('x0',x0);
fprintf('EOL is %g s\n',T(end));
