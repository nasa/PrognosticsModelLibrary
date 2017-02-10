function x0 = Initialize(parameters,t,U,Z)
% Initialize   Compute initial state of battery given inputs and outputs
%
%   x0 = Initialize(parameters,t,U,Z) computes the initial state x0 of the
%   battery model, given a parameters structure, the time, model inputs,
%   and model outputs.
%
%   Assumes battery is at steady-state, or if not, that only Ohmic
%   resistance is contributing to the voltage drop.
% 
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

% Extract inputs
power = U(1);

% Extract outputs
T = Z(1);
V = Z(2);

% Convert temperature given in C to K
T = T + 273.15;

% States are qS, qB, Vo, Vsn, Vsp. Since assuming steady-state,
% Vo,Vsn,Vsp=0.

% Since at steady-state, assumption is concentrations for surface and bulk
% volumes are the same. So using expresson for open-circuit potential, can
% compute what qS needs to be to obtain the given V. To do this,
% reconstruct the OCP curve as a function of mole fraction.
xp = 0.4:0.0001:1;

% Equilibrium potential at surface, pos electrode (Nernst with Redlich-Kister)
Vep0 = parameters.Ap0*((2*xp-1).^(0+1))/parameters.F;
Vep1 = parameters.Ap1*((2*xp-1).^(1+1) - (2*xp.*1.*(1-xp))./(2*xp-1).^(1-1))/parameters.F;
Vep2 = parameters.Ap2*((2*xp-1).^(2+1) - (2*xp.*2.*(1-xp))./(2*xp-1).^(1-2))/parameters.F;
Vep3 = parameters.Ap3*((2*xp-1).^(3+1) - (2*xp.*3.*(1-xp))./(2*xp-1).^(1-3))/parameters.F;
Vep4 = parameters.Ap4*((2*xp-1).^(4+1) - (2*xp.*4.*(1-xp))./(2*xp-1).^(1-4))/parameters.F;
Vep5 = parameters.Ap5*((2*xp-1).^(5+1) - (2*xp.*5.*(1-xp))./(2*xp-1).^(1-5))/parameters.F;
Vep6 = parameters.Ap6*((2*xp-1).^(6+1) - (2*xp.*6.*(1-xp))./(2*xp-1).^(1-6))/parameters.F;
Vep7 = parameters.Ap7*((2*xp-1).^(7+1) - (2*xp.*7.*(1-xp))./(2*xp-1).^(1-7))/parameters.F;
Vep8 = parameters.Ap8*((2*xp-1).^(8+1) - (2*xp.*8.*(1-xp))./(2*xp-1).^(1-8))/parameters.F;
Vep9 = parameters.Ap9*((2*xp-1).^(9+1) - (2*xp.*9.*(1-xp))./(2*xp-1).^(1-9))/parameters.F;
Vep10 = parameters.Ap10*((2*xp-1).^(10+1) - (2*xp.*10.*(1-xp))./(2*xp-1).^(1-10))/parameters.F;
Vep11 = parameters.Ap11*((2*xp-1).^(11+1) - (2*xp.*11.*(1-xp))./(2*xp-1).^(1-11))/parameters.F;
Vep12 = parameters.Ap12*((2*xp-1).^(12+1) - (2*xp.*12.*(1-xp))./(2*xp-1).^(1-12))/parameters.F;
Vep = parameters.U0p + parameters.R*T/parameters.F*log((1-xp)./xp) + ...
	Vep0 + Vep1 + Vep2 + Vep3 + Vep4 + Vep5 + Vep6 + Vep7 + Vep8 + Vep9 + Vep10 + Vep11 + Vep12;

xn = 1-xp;

% Equilibrium potential at surface, pos electrode (Nernst with Redlich-Kister)
Ven0 = parameters.An0*((2*xn-1).^(0+1))/parameters.F;
Ven1 = parameters.An1*((2*xn-1).^(1+1) - (2*xn.*1.*(1-xn))./(2*xn-1).^(1-1))/parameters.F;
Ven2 = parameters.An2*((2*xn-1).^(2+1) - (2*xn.*2.*(1-xn))./(2*xn-1).^(1-2))/parameters.F;
Ven3 = parameters.An3*((2*xn-1).^(3+1) - (2*xn.*3.*(1-xn))./(2*xn-1).^(1-3))/parameters.F;
Ven4 = parameters.An4*((2*xn-1).^(4+1) - (2*xn.*4.*(1-xn))./(2*xn-1).^(1-4))/parameters.F;
Ven5 = parameters.An5*((2*xn-1).^(5+1) - (2*xn.*5.*(1-xn))./(2*xn-1).^(1-5))/parameters.F;
Ven6 = parameters.An6*((2*xn-1).^(6+1) - (2*xn.*6.*(1-xn))./(2*xn-1).^(1-6))/parameters.F;
Ven7 = parameters.An7*((2*xn-1).^(7+1) - (2*xn.*7.*(1-xn))./(2*xn-1).^(1-7))/parameters.F;
Ven8 = parameters.An8*((2*xn-1).^(8+1) - (2*xn.*8.*(1-xn))./(2*xn-1).^(1-8))/parameters.F;
Ven9 = parameters.An9*((2*xn-1).^(9+1) - (2*xn.*9.*(1-xn))./(2*xn-1).^(1-9))/parameters.F;
Ven10 = parameters.An10*((2*xn-1).^(10+1) - (2*xn.*10.*(1-xn))./(2*xn-1).^(1-10))/parameters.F;
Ven11 = parameters.An11*((2*xn-1).^(11+1) - (2*xn.*11.*(1-xn))./(2*xn-1).^(1-11))/parameters.F;
Ven12 = parameters.An12*((2*xn-1).^(12+1) - (2*xn.*12.*(1-xn))./(2*xn-1).^(1-12))/parameters.F;
Ven = parameters.U0n + parameters.R*T/parameters.F*log((1-xn)./xn) + ...
	Ven0 + Ven1 + Ven2 + Ven3 + Ven4 + Ven5 + Ven6 + Ven7 + Ven8 + Ven9 + Ven10 + Ven11 + Ven12;

Ve = Vep-Ven;

% Account for voltage drop to to input current (assuming no concentration
% gradient)
i = power/V;
Vo = i*parameters.Ro;

% Look up what xp needs to be for given V
if (V+Vo) > max(Ve);
	xpo = xp(1);
else
	index = find(Ve<=(V+Vo),1);
	xpo = xp(index);
end
xno = 1-xpo;

% Determine what qS must be for this mole fraction
qpS0 = parameters.qMax*xpo*parameters.VolS/parameters.Vol;
qnS0 = parameters.qMax*xno*parameters.VolS/parameters.Vol;

% Determine qB given that concentrations must be equal
qpB0 = qpS0*parameters.VolB/parameters.VolS;
qnB0 = qnS0*parameters.VolB/parameters.VolS;

% Set x0
x0 = [T Vo 0 0 qnB0 qnS0 qpB0 qpS0]';
