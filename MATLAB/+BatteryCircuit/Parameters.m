function P = Parameters
% Parameters   Define a structure with fields for each model parameter
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

P.sampleTime = 1;

% Basics
Id = 2.02;
td = 3850;
V0 = 4.183;
qd = Id*td;
% If Cb was linear then: Cb = qd/Vd; but Cb is not linear so guessing that
% initial charge is more than qd it must be large enough such that CbEnd >
% Cb0
q0 = 1.0102*qd;
% And assuming that "max" charge is initial charge (when qMax==qb SOC is 1)
qMax = q0;
% When qMax-qb=qd, SOC is 0 if CMax is the following (=qd) (CMax here is
% more like max current that can be drawn, like a qdMax)
CMax = qMax - (q0-qd);
% Given those assumptions assumption it follows that
Cb0 = q0/V0;
% Then we can set the following:
P.V0 = 4.183;       % nominal battery voltage
P.Rp = 1e4;         % battery parasitic resistance
P.qMax = qMax;      % max charge
P.CMax = CMax;      % max capacity

% Capacitance
p = 1.0e3 *[-0.23 0.0012 2.0799];
P.Cb0 = Cb0;        % battery capacitance
P.Cbp0 = p(1);
P.Cbp1 = p(2);
P.Cbp2 = p(3);
P.Cbp3 = Cb0-(P.Cbp0+P.Cbp1+P.Cbp2);

% R-C pairs
P.Rs = 0.0538926;
P.Cs = 234.387;
P.Rcp0 = 0.0697776;
P.Rcp1 = 1.50528e-17;
P.Rcp2 = 37.223;
P.Ccp = 14.8223;

% Temperature parameters
P.Ta = 18.95;      % ambient temperature (deg C)
P.Jt = 800;
P.ha = 0.5;        % heat transfer coefficient, ambient
P.hcp = 19;
P.hcs = 1;

% End of discharge voltage threshold
P.VEOD = 3.0;

% Default initial states (fully charged)
P.x0.qb = P.Cb0*P.V0;
P.x0.qcp = 0;
P.x0.qcs = 0;
P.x0.Tb = P.Ta;

% Process noise variances
P.v.qb = 1e-1;
P.v.qcp = 1e-2;
P.v.qcs = 1e-2;
P.v.Tb = 1e-5;

% Sensor noise variances
P.n.Vm = 1e-3;
P.n.Tbm = 1e-3;
