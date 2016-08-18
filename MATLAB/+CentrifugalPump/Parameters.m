function P = Parameters
% Parameters   Define a structure with fields for each model parameter
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

P.sampleTime = 1;
P.cycleTime = 3600;			% length of a pump usage cycle

% Environmental parameters
P.pAtm = 101325;

% Torque and pressure parameters
P.a0 = 0.00149204;			% empirical coefficient for flow torque eqn
P.a1 = 5.77703;				% empirical coefficient for flow torque eqn
P.a2 = 9179.4;				% empirical coefficient for flow torque eqn
P.A = 12.7084;				% impeller blade area
P.b = 17984.6;

% Pump/motor dynamics
P.I = 50;				    % impeller/shaft/motor lumped inertia
P.r = 0.008;			    % lumped friction parameter (minus bearing friction)
P.R1 = 0.36;
P.R2 = 0.076;
P.L1 = 0.00063;

% Flow coefficients
P.FluidI = 5;				    % pump fluid inertia
P.c = 8.24123e-005;			    % pump flow coefficient
P.cLeak = 1;					% internal leak flow coefficient
P.ALeak = 1e-10;				% internal leak area

% Thrust bearing temperature
P.mcThrust = 7.3;
P.rThrust = 1.4e-6;
P.HThrust1 = 0.0034;
P.HThrust2 = 0.0026;

% Radial bearing temperature
P.mcRadial = 2.4;
P.rRadial = 1.8e-006;
P.HRadial1 = 0.0018;
P.HRadial2 = 0.020;

% Bearing oil temperature
P.mcOil = 8000;
P.HOil1 = 1.0;
P.HOil2 = 3.0;
P.HOil3 = 1.5;

% Parameter limits
P.ALim = 9.5;
P.TtLim = 370;
P.TrLim = 370;
P.ToLim = 350;

% Initial state
P.x0.w = 3600*2*pi/60;  % 3600 rpm
P.x0.Q = 0;
P.x0.Tt = 290;
P.x0.Tr = 290;
P.x0.To = 290;
P.x0.A = P.A;
P.x0.rThrust = P.rThrust;
P.x0.rRadial = P.rRadial;
P.x0.wA = 0;
P.x0.wThrust = 0;
P.x0.wRadial = 0;

% Process noise
P.v.w = 1e-3;
P.v.Q = 1e-8;
P.v.Tt = 1e-7;
P.v.Tr = 1e-7;
P.v.To = 1e-7;
P.v.A = 1e-30;
P.v.rThrust = 1e-30;
P.v.rRadial = 1e-30;
P.v.wA = 1e-30;
P.v.wThrust = 1e-30;
P.v.wRadial = 1e-30;

% Sensor noise
P.n.wm = 1e-2;
P.n.Qoutm = 1e-7;
P.n.Ttm = 1e-2;
P.n.Trm = 1e-2;
P.n.Tom = 1e-2;
