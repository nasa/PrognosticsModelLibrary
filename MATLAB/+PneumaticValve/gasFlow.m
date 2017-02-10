function mdot = gasFlow(pIn,pOut,gas,C,A)
% gasFlow   Compute the mass flow through an orifice
%
%   mdot = gasFlow(pIn,pOut,gas,C,A) computes the mass flow of a gas
%   through an orifice for both choked and nonchoked flow conditions, given
%   the input and output pressures, the gas properties, flow coefficient,
%   and orifice area.
%
%   The gas properties is a struct with the following fields:
%   - gamma: The ratio of specific heats, cp/cv
%   - R: The specific gas constant
%   - T: The gas temperature
%   - Z: The gas compressibility factor
% 
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

k = gas.gamma;
R = gas.R;
T = gas.T;
Z = gas.Z;

% Note: pIn, pOut, C, A may be arrays

threshold = ((k+1)/2)^(k/(k-1));

condition = 1*(pIn./pOut>=threshold) + 2*(pIn./pOut<threshold & pIn>=pOut) +...
	3*(pOut./pIn>=threshold) + 4*(pOut./pIn<threshold & pOut>pIn);

case1 = (condition==1).*( C.*A.*pIn*sqrt(k/Z/R/T*(2/(k+1))^((k+1)/(k-1))) );
case2 = (condition==2).*( C.*A.*pIn.*sqrt(2/Z/R/T*k/(k-1)*abs((pOut./pIn).^(2/k)-(pOut./pIn).^((k+1)/k))) );
case3 = (condition==3).*( -C.*A.*pOut*sqrt(k/Z/R/T*(2/(k+1))^((k+1)/(k-1))) );
case4 = (condition==4).*( -C.*A.*pOut.*sqrt(2/Z/R/T*k/(k-1)*abs((pIn./pOut).^(2/k)-(pIn./pOut).^((k+1)/k))) );

mdot = case1 + case2 + case3 + case4;
