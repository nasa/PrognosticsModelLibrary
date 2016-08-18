function test
% Test centrifugal pump model for various conditions.
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Create pump model
pump = CentrifugalPump.Create;

% Simulate for default conditions
[T,X,U,Z] = pump.simulate(5*3600,'printTime',60);

% Plot results
figure;
pump.plotOutputs(T,Z);

% Determine end-of-life time with component wear
x0 = pump.getDefaultInitialization(0);
x0(pump.indices.states.wA) = 1e-2;
x0(pump.indices.states.wThrust) = 1e-10;
T = pump.simulateToThreshold('x0',x0);
fprintf('EOL is %g s\n',T(end));

% Determine end-of-life under different conditions
x0 = pump.getDefaultInitialization(0);
x0(pump.indices.states.wA) = 1e-3;
x0(pump.indices.states.wThrust) = 1e-9;
T = pump.simulateToThreshold('x0',x0);
fprintf('EOL is %g s\n',T(end));
