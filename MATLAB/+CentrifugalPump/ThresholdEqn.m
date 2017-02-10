function B = ThresholdEqn(parameters,t,X,U)
% ThresholdEqn   Compute whether the model has reached the threshold
%
%   B = ThresholdEqn(parameters,t,X,U) computes whether the model for the
%   given time, states, and inputs, has reached a specified region of the
%   joint state-input space.
%
%   For the pump, the threshold is defined by parameter limits on the
%   damage parameters (impeller area, and the bearing and oil
%   temperatures).
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Extract states
A = X(1,:);
Q = X(2,:);
To = X(3,:);
Tr = X(4,:);
Tt = X(5,:);
rRadial = X(6,:);
rThrust = X(7,:);
w = X(8,:);
wA = X(9,:);
wRadial = X(10,:);
wThrust = X(11,:);

% Extract inputs
Tamb = U(1,:);
V = U(2,:);
pdisch = U(3,:);
psuc = U(4,:);
wsync = U(5,:);

% Individual performance constraints
BA = A > parameters.ALim;
BTt = Tt < parameters.TtLim;
BTr = Tr < parameters.TrLim;
BTo = To < parameters.ToLim;

% at EOL when any fail
B = ~BA | ~BTt | ~BTr | ~BTo;
