function U = InputEqn(parameters,t,u)
% InputEqn   Compute model inputs for the given time and input parameters
%
%   U = InputEqn(parameters,t,inputParameters) computes the inputs to the
%   model given the parameters structure, the current time, and the set of
%   input parameters. The input parameters are optional - if not provided a
%   default input is used.
%
%   For the valve, the input parameters are exactly the model inputs to use.
%   If not provided, inputs for a default valve cycle are used. The inputs
%   for the given time are constructed based on that cycle. A default valve
%   cycle is to open the valve, keep it open for half the cycle duration,
%   then close the valve, and keep it closed for the remainder of the
%   cycle.
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

U = [];

if nargin<3
    % If no input specified, use default
    t = mod(t,parameters.cycleTime);
    pL = 3.5e5;
    pR = 2.0e5;
    if t<parameters.cycleTime/2
        % open valve
        uTop = 0;
        uBot = 1;
    else
        % close valve
        uTop = 1;
        uBot = 0;
    end
else
    pL = u(1);
    pR = u(2);
    uBot = u(3);
    uTop = u(4);
end

% Set inputs
U(1,:) = pL;
U(2,:) = pR;
U(3,:) = uBot;
U(4,:) = uTop;
