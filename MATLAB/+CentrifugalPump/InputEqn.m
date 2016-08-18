function U = InputEqn(parameters,t,inputParameters)
% InputEqn   Compute model inputs for the given time and input parameters
%
%   U = InputEqn(parameters,t,inputParameters) computes the inputs to the
%   model given the parameters structure, the current time, and the set of
%   input parameters. The input parameters are optional - if not provided a
%   default input is used.
%
%   For the pump, the input parameters are exactly the model inputs to use.
%   If not provided, inputs for a default pump cycle are used. The inputs
%   for the given time are constructed based on that cycle.
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

U = [];

if nargin<3
    % If no u specified, assume default load
    % Single cycle is 1 hour at 3600 rpm
    t = mod(t,parameters.cycleTime);
    if t < parameters.cycleTime/2
        V = 471.2389;
    elseif t < parameters.cycleTime/2 + 100
        V = 471.2398 + 1*(t-parameters.cycleTime/2);
    elseif t < parameters.cycleTime - 100
        V = 471.2398 + 1*(100);
    else
        V = 471.2398 - 1*(t-parameters.cycleTime);
    end
    Tamb = 290;
    pdischNorm = 120;
    pdisch = psiToPa(pdischNorm);
    psuc = psiToPa(20);
    wsync = V*0.8;
else
    Tamb = inputParameters(1);
    V = inputParameters(2);
    pdisch = inputParameters(3);
    psuc = inputParameters(4);
    wsync = inputParameters(5);
end

% Set inputs
U(1,:) = Tamb;
U(2,:) = V;
U(3,:) = pdisch;
U(4,:) = psuc;
U(5,:) = wsync;


% Helper unit conversion function
function p2 = psiToPa(p1)
p2 = (p1+14.69)*6894.75;
