function P = Parameters
% Parameters   Define a structure with fields for each model parameter
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

P.sampleTime = 0.01;
P.cycleTime = 20;

% Conversions
INCHES = 1/0.0254;			% gain to covert value m to inches
PSI = 1.45037738e-4;		% gain to convert Pa to psia
GPM = 15850.3231;			% convert m^3/s to GPM
PSI = 1.45037738e-4;		% convert Pa to psi
GAL = 264.172052;			% convert m^3 to gallons

% Environmental parameters
P.g = 9.8;					% acceleration due to gravity in m^2/s
P.R = 8.314;				% universal gas constant in J/K/mol
P.pAtm = 101325;			% atmospheric pressure in Pa

% Valve parameters
P.m = 50.0;             % plug mass in kg
P.r = 6e3;                % nominal friction coefficient
P.k = 4.8e4;			% spring constant in N/m
P.xo = 10/INCHES;       % offset for displacement of spring vs. x=0
P.Ap = pi*4/INCHES^2;	% surface area of piston for gas contact in m^2, approx from specs
P.Ls = 1.5/INCHES;		% stroke length in m, for 4in stroke, approx from specs
P.Vbot0 = P.Ap*0.1;     % below piston "default" volume in m^3, approx from specs
P.Vtop0 = P.Vbot0;		% above piston "default" volume in m^3, approx from specs
P.indicatorTol = 1e-3;	% tolerance bound for open/close indicators

% Flow parameters
P.Av = 25*pi/INCHES^2;			% surface area of plug end in m^2, approx from specs
P.Cv = 1300/GPM/P.Av/3.7134;	% flow coefficient assuming Cv of 1300 GPM
P.rhoL = 70.99;                 % density of LH2 in kg/m^3

% Gaseous nitrogen parameters
P.GN2.M = 28.01e-3;				% molar mass of GN2 in kg/mol
P.GN2.R = P.R/P.GN2.M;
P.GN2.T = 293;					% temperature of GN2 in K is ambient temp
P.GN2.gamma = 1.4;				% specific heat ratio
P.GN2.Z = 1;					% gas compressibility factor (1=ideal gas)
P.pSupply = 764.7/PSI;			% pneumatic supply pressure in Pa to be 750 psig

% Orifice parameters
P.At = 1e-5;           % orifice is .25 in diameter, that is about 0.07 in^2 which is 4e-5 m^2
P.Ct = 0.62;
P.Ab = 1e-5;
P.Cb = 0.62;

% Fault parameter limits defining EOL
P.AbMax = 4e-5;
P.AtMax = 4e-5;
P.AiMax = 1.7e-6;
P.rMax = 4e6;
P.kMin = 3.95e4;

% Initial conditions (fully closed)
Vtopi = P.Vtop0 + P.Ap*P.Ls;
Vboti = P.Vbot0;
MoRT = P.GN2.M/P.R/P.GN2.T;
P.x0.x = 0;
P.x0.v = 0;
P.x0.mTop = P.pSupply*Vtopi*MoRT;
P.x0.mBot = P.pAtm*Vboti*MoRT;
P.x0.Aeb = P.Ab;
P.x0.Aet = P.At;
P.x0.Ai = 0;
P.x0.r = P.r;
P.x0.k = P.k;
P.x0.wr = 0;
P.x0.wk = 0;
P.x0.wt = 0;
P.x0.wb = 0;
P.x0.wi = 0;
P.x0.condition = 1;

% Process noise
P.v.x = 1e-9;
P.v.v = 1e-8;
P.v.mTop = 1e-7;
P.v.mBot = 1e-7;
P.v.Aeb = 1e-30;
P.v.Aet = 1e-30;
P.v.r = 1e-30;
P.v.wr = 1e-30;
P.v.k = 1e-30;
P.v.wk = 1e-30;
P.v.Ai = 1e-30;
P.v.wt = 1e-30;
P.v.wb = 1e-30;
P.v.wi = 1e-30;
P.v.condition = 1e-20;

% Sensor noise
P.n.xm = 1e-10;
P.n.Qm = 1e-10;
P.n.pressureTopm = 1e-10;
P.n.pressureBotm = 1e-10;
P.n.indicatorTopm = 1e-1;
P.n.indicatorBotm = 1e-1;
