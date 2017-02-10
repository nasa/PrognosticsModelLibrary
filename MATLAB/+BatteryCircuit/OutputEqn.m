function Z = OutputEqn(parameters,t,X,U,N)
% OutputEqn   Compute the outputs of the battery model
%
%   Z = OutputEqn(parameters,t,X,U,N) computes the outputs of the battery
%   model given the parameters structure, time, the states, inputs, and
%   sensor noise. The function is vectorized, so if the function inputs are
%   matrices, the funciton output will be a matrix, with the rows being the
%   variables and the columns the samples.
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

% set outputs
Z = zeros(2,max([size(X,2) size(U,2) 1]));
Z(1,:) = Tbm;
Z(2,:) = Vm;

% Add sensor noise
Z = Z + N;
