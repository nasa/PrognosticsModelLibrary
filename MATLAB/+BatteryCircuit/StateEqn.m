function XNew = StateEqn(parameters,t,X,U,N,dt)
% StateEqn   Compute the new states of the battery model
%
%   XNew = StateEqn(parameters,t,X,U,N,dt) computes the new states of the
%   battery model given the parameters strcucture, the current time, the
%   current states, inputs, process noise, and the sampling time.
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
Vcs = qcs./parameters.Cs;
Vcp = qcp./parameters.Ccp;
SOC = (parameters.CMax - parameters.qMax + qb)./parameters.CMax;
Cb = parameters.Cbp0.*SOC.^3 + parameters.Cbp1.*SOC.^2 + parameters.Cbp2.*SOC + parameters.Cbp3;
Rcp = parameters.Rcp0 + parameters.Rcp1.*exp(parameters.Rcp2.*(-SOC + 1));
Vb = qb./Cb;
Tbdot = (Rcp.*parameters.Rs.*parameters.ha.*(parameters.Ta - Tb) + Rcp.*Vcs.^2.*parameters.hcs + parameters.Rs.*Vcp.^2.*parameters.hcp)./(parameters.Jt.*Rcp.*parameters.Rs);
Vp = Vb - Vcp - Vcs;
ip = Vp./parameters.Rp;
ib = i + ip;
icp = ib - Vcp./Rcp;
qcpdot = icp;
qbdot = -ib;
ics = ib - Vcs./parameters.Rs;
qcsdot = ics;

% Update state
XNew = zeros(size(X));
XNew(1,:) = Tb + Tbdot*dt;
XNew(2,:) = qb + qbdot*dt;
XNew(3,:) = qcp + qcpdot*dt;
XNew(4,:) = qcs + qcsdot*dt;

% Add process noise
XNew = XNew + dt*N;
