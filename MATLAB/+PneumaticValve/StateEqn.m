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

% Constraints
wrdot = 0;
Aebdot = wb;
wkdot = 0;
Aetdot = wt;
wbdot = 0;
wtdot = 0;
xdot = v;
widot = 0;
pInTop = eq(uTop,0).*parameters.pAtm + eq(uTop,1).*parameters.pSupply;
springForce = k.*(parameters.xo+x);
friction = v.*r;
fluidForce = (pL-pR).*parameters.Av;
pInBot = eq(uBot,0).*parameters.pAtm + eq(uBot,1).*parameters.pSupply;
volumeBot = parameters.Vbot0 + parameters.Ap.*x;
volumeTop = parameters.Vtop0 + parameters.Ap.*(parameters.Ls-x);
plugWeight = parameters.m.*parameters.g;
kdot = -wk.*abs(v.*springForce);
rdot = wr.*abs(v.*friction);
Aidot = wi.*abs(v.*friction);
pressureBot = mBot.*parameters.R.*parameters.GN2.T./parameters.GN2.M./volumeBot;
mBotDotn = PneumaticValve.gasFlow(pInBot,pressureBot,parameters.GN2,parameters.Cb,parameters.Ab);
pressureTop = mTop.*parameters.R.*parameters.GN2.T./parameters.GN2.M./volumeTop;
leakBotToAtm = PneumaticValve.gasFlow(pressureBot,parameters.pAtm,parameters.GN2,1,Aeb);
gasForceTop = pressureTop.*parameters.Ap;
gasForceBot = pressureBot.*parameters.Ap;
leakTopToAtm = PneumaticValve.gasFlow(pressureTop,parameters.pAtm,parameters.GN2,1,Aet);
leakTopToBot = PneumaticValve.gasFlow(pressureTop,pressureBot,parameters.GN2,1,Ai);
mBotdot = mBotDotn + leakTopToBot - leakBotToAtm;
mTopDotn = PneumaticValve.gasFlow(pInTop,pressureTop,parameters.GN2,parameters.Ct,parameters.At);
pistonForces = -fluidForce - plugWeight - friction - springForce + gasForceBot - gasForceTop;
mTopdot = mTopDotn - leakTopToBot - leakTopToAtm;
vdot = pistonForces./parameters.m;

% Update discrete state (1 == pushed bottom/closed, 2 == moving, 3 == pushed top/open)
condition = 1*((x==0 & pistonForces<0) | (x+xdot*dt<0)) ...
    + 2*((x==0 & pistonForces>0) | (x+xdot*dt>=0 & x>0 & x<parameters.Ls & x+xdot*dt<=parameters.Ls) | (x==parameters.Ls & pistonForces<0)) ...
    + 3*((x==parameters.Ls & pistonForces>0) | (x+xdot*dt>parameters.Ls));

% Compute new x, v based on condition
x = (condition==1).*0 + (condition==2).*(x+xdot*dt) + (condition==3).*parameters.Ls;
v = (condition==1).*0 + (condition==2).*(v+vdot*dt) + (condition==3).*0;

% Update state
XNew = zeros(size(X));
XNew(1,:) = Aeb + Aebdot*dt;
XNew(2,:) = Aet + Aetdot*dt;
XNew(3,:) = Ai + Aidot*dt;
XNew(4,:) = condition;
XNew(5,:) = k + kdot*dt;
XNew(6,:) = mBot + mBotdot*dt;
XNew(7,:) = mTop + mTopdot*dt;
XNew(8,:) = r + rdot*dt;
XNew(9,:) = v;
XNew(10,:) = wb + wbdot*dt;
XNew(11,:) = wi + widot*dt;
XNew(12,:) = wk + wkdot*dt;
XNew(13,:) = wr + wrdot*dt;
XNew(14,:) = wt + wtdot*dt;
XNew(15,:) = x;

% Add process noise
XNew = XNew + dt*N;
