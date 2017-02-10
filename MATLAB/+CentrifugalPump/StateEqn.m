function XNew = StateEqn(parameters,t,X,U,N,dt)
% StateEqn   Compute the new states of the model
%
%   XNew = StateEqn(parameters,t,X,U,N,dt) computes the new states of the
%   model given the parameters strcucture, the current time, the current
%   states, inputs, process noise, and the sampling time.
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
Todot = 1./parameters.mcOil .* (parameters.HOil1.*(Tt-To) + parameters.HOil2.*(Tr-To) + parameters.HOil3.*(Tamb-To));
Ttdot = 1./parameters.mcThrust .* (rThrust.*w.^2 - parameters.HThrust1.*(Tt-Tamb) - parameters.HThrust2.*(Tt-To));
wAdot = 0;
wThrustdot = 0;
Adot = -wA.*Q.^2;
wRadialdot = 0;
rRadialdot = wRadial.*rRadial.*w.^2;
rThrustdot = wThrust.*rThrust.*w.^2;
friction = (parameters.r+rThrust+rRadial).*w;
QLeak = parameters.cLeak.*parameters.ALeak.*sqrt(abs(psuc-pdisch)).*sign(psuc-pdisch);
Trdot = 1./parameters.mcRadial .* (rRadial.*w.^2 - parameters.HRadial1.*(Tr-Tamb) - parameters.HRadial2.*(Tr-To));
slipn = (wsync-w)./(wsync);
ppump = A.*w.^2 + parameters.b.*w.*Q;
Qout = max(0,Q-QLeak);
slip = max(-1,(min(1,slipn)));
deltaP = ppump+psuc-pdisch;
Te = 3.*parameters.R2./slip./(wsync+0.00001).*V.^2./((parameters.R1+parameters.R2./slip).^2+(wsync.*parameters.L1).^2);
backTorque = -parameters.a2.*Qout.^2 + parameters.a1.*w.*Qout + parameters.a0.*w.^2;
Qo = parameters.c.*sqrt(abs(deltaP)).*sign(deltaP);
wdot = (Te-friction-backTorque)./parameters.I;
Qdot = 1./parameters.FluidI.*(Qo-Q);

% Update state
XNew = zeros(size(X));
XNew(1,:) = A + Adot*dt;
XNew(2,:) = Q + Qdot*dt;
XNew(3,:) = To + Todot*dt;
XNew(4,:) = Tr + Trdot*dt;
XNew(5,:) = Tt + Ttdot*dt;
XNew(6,:) = rRadial + rRadialdot*dt;
XNew(7,:) = rThrust + rThrustdot*dt;
XNew(8,:) = w + wdot*dt;
XNew(9,:) = wA + wAdot*dt;
XNew(10,:) = wRadial + wRadialdot*dt;
XNew(11,:) = wThrust + wThrustdot*dt;

% Add process noise
XNew = XNew + dt*N;
