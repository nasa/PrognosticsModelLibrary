function B = ThresholdEqn(parameters,t,X,U)
% ThresholdEqn   Compute whether the model has reached the threshold
%
%   B = ThresholdEqn(parameters,t,X,U) computes whether the model for the
%   given time, states, and inputs, has reached a specified region of the
%   joint state-input space.
%
%   For the valve, the threshold is defined by parameter limits on the
%   damage parameters (leak areas, friction coefficient, spring
%   coefficient).
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Extract states
Aeb = X(1,:);
Aet = X(2,:);
Ai = X(3,:);
condition = X(4,:);
k = X(5,:);
mBot = X(6,:);
mTop = X(7,:);
r = X(8,:);
v = X(9,:);
wb = X(10,:);
wi = X(11,:);
wk = X(12,:);
wr = X(13,:);
wt = X(14,:);
x = X(15,:);

% Extract inputs
pL = U(1,:);
pR = U(2,:);
uBot = U(3,:);
uTop = U(4,:);

% Individual parameter limits
BAeb = Aeb > parameters.AbMax;
BAet = Aet > parameters.AtMax;
BAi = Ai > parameters.AiMax;
Bk = k < parameters.kMin;
Br = r > parameters.rMax;

% at EOL when any fail
B = BAeb | BAet | BAi | Bk | Br;
