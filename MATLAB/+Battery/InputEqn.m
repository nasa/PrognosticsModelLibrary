function U = InputEqn(parameters,t,inputParameters)
% InputEqn   Compute model inputs for the given time and input parameters
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

persistent loads times loadParameters;
U = [];
if nargin<3
    U(1,:) = 8;
else
    if isempty(loads) || ~isequal(loadParameters,inputParameters)
        loadParameters=inputParameters;
        loads = loadParameters(1:2:end,:);
        loads(end+1,:)=loads(end,:);
        durations = loadParameters(2:2:end,:);
        times = [zeros(1,size(loadParameters,2)); cumsum(durations,1)];
    end

    loadindex=false(size(loads));
    for i=1:size(times,2)
        loadindex(find(times(:,i)<t,1,'last'), i)=true;
    end
    U(1,:)=loads(loadindex);
end
