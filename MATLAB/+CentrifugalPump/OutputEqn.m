function Z = OutputEqn(parameters,t,X,U,N)
% OutputEqn   Compute the outputs of the model
%
%   Z = OutputEqn(parameters,t,X,U,N) computes the outputs of the
%   model given the parameters structure, time, the states, inputs, and
%   sensor noise.
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

% Constraints
Ttm = Tt;
Tom = To;
wm = w;
Trm = Tr;
QLeak = parameters.cLeak.*parameters.ALeak.*sqrt(abs(psuc-pdisch)).*sign(psuc-pdisch);
Qout = max(0,Q-QLeak);
Qoutm = Qout;

% set outputs
Z = zeros(5,max([size(X,2) size(U,2) 1]));
Z(1,:) = Qoutm;
Z(2,:) = Tom;
Z(3,:) = Trm;
Z(4,:) = Ttm;
Z(5,:) = wm;

% Add sensor noise
Z = Z + N;
