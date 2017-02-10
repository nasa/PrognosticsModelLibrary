function B = ThresholdEqn(parameters,t,X,U)
% ThresholdEqn   Compute whether the battery has reached end-of-discharge
%
%   B = ThresholdEqn(parameters,t,X,U) computes whether the battery model
%   for the given time, states, and inputs, has crossed the voltage
%   threshold defining end-of-discharge. 
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Extract states
Tb = X(1,:);
qb = X(2,:);
qcp = X(3,:);
qcs = X(4,:);

% Extract inputs
i = U(1,:);

% Constraints
Tbm = Tb;
Vcs = qcs./parameters.Cs;
Vcp = qcp./parameters.Ccp;
SOC = (parameters.CMax - parameters.qMax + qb)./parameters.CMax;
Cb = parameters.Cbp0.*SOC.^3 + parameters.Cbp1.*SOC.^2 + parameters.Cbp2.*SOC + parameters.Cbp3;
Vb = qb./Cb;
Vp = Vb - Vcp - Vcs;
Vm = Vp;

% Return true if voltage is less than the voltage threshold
B = Vm < parameters.VEOD;
