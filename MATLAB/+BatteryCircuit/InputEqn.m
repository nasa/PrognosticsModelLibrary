function U = InputEqn(parameters,t,u)
% InputEqn   Compute battery inputs for the given time and input parameters
%
%   U = InputEqn(parameters,t,inputParameters) computes the inputs to the
%   battery model given the parameters structure, the current time, and the
%   set of input parameters. The input parameters are optional - if not
%   provided a default input of 8 Watts is used. If inputParameters is
%   provided, it should be a matrix, numInputParameters x numSamples.

%   For the battery model, the input parameters are a list of numbers
%   specifying a sequence of load segments, with each segment defined by a
%   magnitude and a duration. So, for example, the following input
%   parameters vector:
%      [5 100 2 200 3 300]
%   captures a set of three segments, the first of 5 W lasting 100 seconds,
%   the second 2 W lasting 200 s, the third 3 W lasting 300 s. The initial
%   time is assumed to be 0, so if t is given as 150 s, for example, then
%   the load magnitude will be 2 W (second segment).
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

U = [];

if nargin<3
    % If no u specified, assume default load.
    current = 2;
else
    % If u specified, interpret as variable loading scheme, where u is a
    % vector with an even number of elements. The first of the pair of
    % numbers is the magnitude of the load, the second is the duration.
    loads = u(1:2:end);
    durations = u(2:2:end);
    times = [0 cumsum(durations)];
    % Find which load corresponds to given time
    loadIndex = find(t>=times,1,'last');
    if loadIndex>length(loads)
        current = loads(end);
    else
        current = loads(loadIndex);
    end
end

U(1,:) = current;
