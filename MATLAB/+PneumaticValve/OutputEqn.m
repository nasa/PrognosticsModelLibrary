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
indicatorTopm = x >= parameters.Ls-parameters.indicatorTol;
indicatorBotm = x <= 0+parameters.indicatorTol;
xm = x;
maxFlow = parameters.Cv.*parameters.Av.*sqrt(2./parameters.rhoL.*abs(pL-pR)).*sign(pL-pR);
volumeBot = parameters.Vbot0 + parameters.Ap.*x;
volumeTop = parameters.Vtop0 + parameters.Ap.*(parameters.Ls-x);
trueFlow = maxFlow.* max(0,x)./parameters.Ls;
pressureTop = mTop.*parameters.R.*parameters.GN2.T./parameters.GN2.M./volumeTop;
pressureBot = mBot.*parameters.R.*parameters.GN2.T./parameters.GN2.M./volumeBot;
pressureBotm = 1e-6.*pressureBot;
Qm = trueFlow;
pressureTopm = 1e-6.*pressureTop;

% set outputs
Z = zeros(6,max([size(X,2) size(U,2) 1]));
Z(1,:) = Qm;
Z(2,:) = indicatorBotm;
Z(3,:) = indicatorTopm;
Z(4,:) = pressureBotm;
Z(5,:) = pressureTopm;
Z(6,:) = xm;

% Add sensor noise
Z = Z + N;
