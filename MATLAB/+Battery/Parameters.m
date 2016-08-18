function P = Parameters(qMobile)
% Parameters   Define a structure with fields for each model parameter
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

P.sampleTime = 1;

% Mole Fractions: At full charge, initial mole fractions for Li+ are 0.4
% for cathode, 0.6 for anode q is modeling the amount of Li+ in the anode
% (decreases during discharge), so it cannot go above mole fraction of 0.6
% because 0.4 is needed at cathode as a minimum. At full charge need at
% least qd in anode. Also, (qMax-q)/qMax has to be at least 0.4 at fully
% charged.

% Control Volumes: Have two control volumes per electrode, one for surface,
% one for bulk. When fully charged, neg electrode has all the mobile Li
% ions and pos electrode has none. There are still some ions in positive
% side because mole fraction must be at least 0.4. Initially concentrations
% of surface and bulk volumes (in one electrode) must be the same. So q/Vol
% = qB0/VolB = qS0/VolS, and q0=qS0+qB0. Therefore qB0 = q0*VolB/Vol, and
% qS0 = q0*VolS/Vol. Since Vol = VolS+VolB, this satisfies q0=qS0+qB0.

% Basics
if nargin<1
    P.qMobile = 7600;
else
    P.qMobile = qMobile;
end
P.xnMax = 0.6;            % maximum mole fraction (neg electrode)
P.xnMin = 0;              % minimum mole fraction (neg electrode)
P.xpMax = 1.0;            % maximum mole fraction (pos electrode)
P.xpMin = 0.4;            % minimum mole fraction (pos electrode) -> note xn+xp=1
P.qMax = P.qMobile/(P.xnMax-P.xnMin);    % note qMax = qn+qp
P.Ro = 0.117215;          % for Ohmic drop (current collector resistances plus electrolyte resistance plus solid phase resistances at anode and cathode)

% Constants of nature
P.R = 8.3144621;          % universal gas constant, J/K/mol
P.F = 96487;              % Faraday's constant, C/mol

% Li-ion parameters
P.alpha = 0.5;            % anodic/cathodic electrochemical transfer coefficient
P.Sn = 0.000437545;       % surface area (- electrode)
P.Sp = 0.00030962;        % surface area (+ electrode)
P.kn = 2120.96;           % lumped constant for BV (- electrode)
P.kp = 248898;            % lumped constant for BV (+ electrode)
P.Vol = 2e-5;             % total interior battery volume/2 (for computing concentrations)
P.VolSFraction = 0.1;     % fraction of total volume occupied by surface volume

% Volumes (total volume is 2*P.Vol), assume volume at each electrode is the
% same and the surface/bulk split is the same for both electrodes
P.VolS = P.VolSFraction*P.Vol;  % surface volume
P.VolB = P.Vol - P.VolS;        % bulk volume

% set up charges (Li ions)
P.qpMin = P.qMax*P.xpMin;            % min charge at pos electrode
P.qpMax = P.qMax*P.xpMax;            % max charge at pos electrode
P.qpSMin = P.qpMin*P.VolS/P.Vol;     % min charge at surface, pos electrode
P.qpBMin = P.qpMin*P.VolB/P.Vol;     % min charge at bulk, pos electrode
P.qpSMax = P.qpMax*P.VolS/P.Vol;     % max charge at surface, pos electrode
P.qpBMax = P.qpMax*P.VolB/P.Vol;     % max charge at bulk, pos electrode
P.qnMin = P.qMax*P.xnMin;            % max charge at neg electrode
P.qnMax = P.qMax*P.xnMax;            % max charge at neg electrode
P.qnSMax = P.qnMax*P.VolS/P.Vol;     % max charge at surface, neg electrode
P.qnBMax = P.qnMax*P.VolB/P.Vol;     % max charge at bulk, neg electrode
P.qnSMin = P.qnMin*P.VolS/P.Vol;     % min charge at surface, neg electrode
P.qnBMin = P.qnMin*P.VolB/P.Vol;     % min charge at bulk, neg electrode
P.qSMax = P.qMax*P.VolS/P.Vol;       % max charge at surface (pos and neg)
P.qBMax = P.qMax*P.VolB/P.Vol;       % max charge at bulk (pos and neg)

% time constants
P.tDiffusion = 7e6;  % diffusion time constant (increasing this causes decrease in diffusion rate)
P.to = 6.08671;      % for Ohmic voltage
P.tsn = 1001.38;     % for surface overpotential (neg)
P.tsp = 46.4311;     % for surface overpotential (pos)

% Redlich-Kister parameters (positive electrode)
P.U0p = 4.03;
P.Ap0 = -31593.7;
P.Ap1 = 0.106747;
P.Ap2 = 24606.4;
P.Ap3 = -78561.9;
P.Ap4 = 13317.9;
P.Ap5 = 307387;
P.Ap6 = 84916.1;
P.Ap7 = -1.07469e+06;
P.Ap8 = 2285.04;
P.Ap9 = 990894;
P.Ap10 = 283920;
P.Ap11 = -161513;
P.Ap12 = -469218;

% Redlich-Kister parameters (negative electrode)
P.U0n = 0.01;
P.An0 = 86.19;
P.An1 = 0;
P.An2 = 0;
P.An3 = 0;
P.An4 = 0;
P.An5 = 0;
P.An6 = 0;
P.An7 = 0;
P.An8 = 0;
P.An9 = 0;
P.An10 = 0;
P.An11 = 0;
P.An12 = 0;

% End of discharge voltage threshold
P.VEOD = 3.0;

% Default initial conditions (fully charged)
P.x0.qpS = P.qpSMin;
P.x0.qpB = P.qpBMin;
P.x0.qnS = P.qnSMax;
P.x0.qnB = P.qnBMax;
P.x0.Vo = 0;
P.x0.Vsn = 0;
P.x0.Vsp = 0;
P.x0.Tb = 292.1;            % in K, about 18.95 C

% Process noise variances
P.v.qpS = 1e-5;
P.v.qpB = 1e-3;
P.v.qnS = 1e-5;
P.v.qnB = 1e-3;
P.v.Vo = 1e-10;
P.v.Vsn = 1e-10;
P.v.Vsp = 1e-10;
P.v.Tb = 1e-6;

% Sensor noise variances
P.n.Vm = 1e-3;
P.n.Tbm = 1e-3;
