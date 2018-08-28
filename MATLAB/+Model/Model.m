classdef Model < handle
% Model   Class for defining a general time-variant state space model.
%
% The Model class is a wrapper around a mathematical model of a system as
% represented by a state and output equation. Optionally, it may also
% include an input equation, which defines what the system input should be
% at any given time, and an initialize equation, which computes the initial
% system state given the inputs and outputs.
%
% A Model also has a parameters structure, which contains fields for
% various model parameters. The parameters structure is always given as a
% first argument to all provided equation handles. However, when calling
% the methods for these equations, it need not be specified as it is passed
% by default since it is a property of the class.
%
% The process and sensor noise variances are represented by vectors. When
% using the generate noise methods, samples are generated from zero-mean
% uncorrelated Gaussian noise as specified by these variances.
%
% Model Methods:
%   stateEqn - Compute new states given current state, inputs, noise, dt
%   outputEqn - Compute new outputs given current state, inputs, noise
%   inputEqn - Compute inputs given current time and "input parameters"
%   initializeEqn - Compute initial state given current inputs, outputs
%   getDefaultInitialization - Compute default initial state, inputs, outputs
%   generateProcessNoise - Generate process noise samples
%   generateSensorNoise - Generate sensor noise samples
%   setParams - Set parameters in parameters structure by name and value
%   printParams - Print current values of given parameter names
%   simulate - Simulate model up to a given time point
%   printStates - Print the names and values of states
%   printInputs - Print the  names and values of inputs
%   printOutputs - Print the names and values of outputs
%   plotStates - Plot given state trajectories
%   plotInputs - Plot given input trajectories
%   plotOutputs - Plot given output trajectories
%
% See also Model.PrognosticsModel
%
% Copyright (c) 2016 United States Government as represented by the
% Administrator of the National Aeronautics and Space Administration.
% No copyright is claimed in the United States under Title 17, U.S.
% Code. All Other Rights Reserved.
    
    properties
        
        name = 'myModel';     % Name of model
        
        stateEqnHandle;       % Handle to state equation
        inputEqnHandle;       % Handle to input equation
        outputEqnHandle;      % Handle to output equation
        initializeEqnHandle;  % Handle to initialize equation
        
        states;               % Struct array of states
        inputs;               % Struct array of inputs
        outputs;              % Struct array of ouputs
        
        outputIndices;        % Current measurement indices
        sampleTime;           % Sampling period
        
        V;                    % Process noise variances (vector)
        N;                    % Sensor noise variances for current sensor set (vector)
        x0Variance;           % Initial states variance (vector) 
        P;                    % Static parameters structure
        
        indices;  % Structure to get indices of states, inputs, outputs by name
        
    end
    
    
    methods
        
        % Constructor - arguments are string, value pairs. The strings must
        % correspond to property names.
        function M = Model(varargin)
            % Model   Constructor
            %   Contruct a Model object given various arguments. The
            %   arguments are string, value pairs, e.g.,
            %   Model('stateEqnHandle',stateEqn,...).
            %   The following arguments are required:
            %   - stateEqnHandle: function handle to state equation
            %   - outputEqnHandle: function handle to output equation
            %   - states: struct array of state variables
            %   - inputs: struct array of input variables
            %   - outputs: struct array of output variables
            %   - P: model parameters structure
            %   - sampleTime: default model sample time for simulation
            %
            % The struct arrays for states must include fields 'name',
            % 'units', 'Noise', 'x0', and 'ylim'. The 'units' field is only
            % required if using the print methods, and the 'ylim' field is
            % only required if using the plot methods.
            %
            % The function handles must each take as the first two inputs
            % the model parameters structure and the time. The remaining
            % arguments are as follows:
            %   - stateEqnHandle: x,u,noise,dt
            %   - outputEqnHandle: x,u,noise
            %   - inputEqnHandle: (optional) input parameters
            %
            % The "input parameters" is a vector of values that are used to
            % define what the model input should be at a given time. In
            % this way, input equations can be defined in many arbitrary
            % ways.
            
            % Create a structure from the string, value pairs
            args = struct(varargin{:});
            
            % Set object properties from the function arguments
            properties = fieldnames(args);
            for i=1:length(properties)
                M.(properties{i}) = args.(properties{i});
            end
            
            % Check for required properties
            requiredProperties = {'stateEqnHandle' 'outputEqnHandle' 'states'...
                'outputs' 'inputs' 'P' 'sampleTime'};
            for i=1:length(requiredProperties)
                if isempty(M.(requiredProperties{i}))
                    error('%s is a required property!',requiredProperties{i});
                end
            end
            
            % Set up process noise variances vector
            for i=1:length(M.states)
                M.V(i,1) = M.states(i).Noise;
            end
            
            % Set up sensor noise variances vector
            for i=1:length(M.outputs)
                M.N(i,1) = M.outputs(i).Noise;
            end
            
            % Set up initial states variances vector
            for i=1:length(M.states)
                if isfield(M.states(i),'x0Variance')
                    M.x0Variance(i,1) = M.states(i).x0Variance;
                else
                    M.x0Variance(i,1)=  M.states(i).Noise;
                end
            end
            
            % Setup indices structure
            M.setIndices();
        end
        
        
        function XNew = stateEqn(M,t,X,U,V,dt)
            % stateEqn   Compute new states
            %   XNew = stateEqn(M,t,X,U,V,dt) computes the new states given
            %   the current time, states, inputs, process noise, and
            %   sampling time. If dt is not provided, the sampleTime
            %   property will be used by default.
            
            % Update the state
            if nargin<6
                XNew = M.stateEqnHandle(M.P,t,X,U,V,M.sampleTime);
            else
                XNew = M.stateEqnHandle(M.P,t,X,U,V,dt);
            end
        end
        
        
        function Z = outputEqn(M,t,X,U,N)
            % outputEqn   Compute new outputs
            %   Z = outputEqn(M,t,X,U,N) computes the outputs for the
            %   current time, states, inputs, and sensor noise.
            
            % Compute outputs
            Z = M.outputEqnHandle(M.P,t,X,U,N);
        end
        
        
        function U = inputEqn(M,t,u)
            % inputEqn   Compute inputs
            %   U = inputEqn(M,t,u) computes the inputs for the given time
            %   and input parameters. The input parameters are an optional
            %   argument, but if provided, the inputEqnHandle of the class
            %   must be able to take it as an argument.
            
            % Compute inputs
            if nargin<3
                U = M.inputEqnHandle(M.P,t);
            else
                U = M.inputEqnHandle(M.P,t,u);
            end
        end
        
        
        function X = initializeEqn(M,t,U,Z)
            % initializeEqn   Compute initial state given inputs and ouputs
            %   X = initializeEqn(M,t,U,Z) computes the initial states
            %   corresponding to the given time, inputs, and outputs.
            
            % Compute states
            X = M.initializeEqnHandle(M.P,t,U,Z);
        end
        
        
        function [x0,u0,z0] = getDefaultInitialization(M,t0,inputParameters)
            % getDefaultInitialization Get default initial states, inputs,
            % and outputs.
            %   This method returns the initial states, inputs, and outputs
            %   for the given initial time, and, if provided, a set of
            %   input parameters. If no arguments are given to this method,
            %   an initial time of 0 is assumed.
            
            % t0 is optional, if not provided set to 0
            if nargin<2
                t0 = 0;
            end
            
            % Set up initial state from the state struct array
            x0 = zeros(length(M.states),1);
            for i=1:length(M.states)
                x0(i) = M.states(i).x0;
            end
            
            % Compute inputs for initial time
            if nargin==3
                u0 = M.inputEqn(t0,inputParameters);
            else
                u0 = M.inputEqn(t0);
            end
            
            % Compute outputs for initial time, states, and inputs
            z0 = M.outputEqn(t0,x0,u0,0);
        end
        
        
        function v = generateProcessNoise(M,numSamples)
            % generateProcessNoise   Generate process noise samples
            %    Generate uncorrelated process noise from normal
            %    distributions with zero-mean. The variances are defined
            %    from the states structure of the model.
            if nargin<2
                numSamples = 1;
            end
            v = repmat(M.V,1,numSamples).*randn(length(M.V),numSamples);
        end
        
        
        function n = generateSensorNoise(M,numSamples)
            % generateSensorNoise   Generate sensor noise samples
            %    Generate uncorrelated sensor noise from normal
            %    distributions with zero-mean. The variances are defined
            %    from the outputs structure of the model.
            if nargin<2
                numSamples = 1;
            end
            n = repmat(M.N,1,numSamples).*randn(length(M.N),numSamples);
        end
        
        
        function setParams(M,names,values)
            % setParams   Set parameter values for given parameter names
            %   For the given parameter names (fields in the model
            %   parameters structure), set to the given values.
            for i=1:length(names)
                M.P.(names{i}) = values(i);
            end
        end
        
        
        function printParams(M,names)
            % printParams   Print model parameter values for given
            % parameter names.
            for i=1:length(names)
                fprintf('\t%s = %g\n',names{i},M.P.(names{i}));
            end
        end
        
        function [T,X,U,Z] = simulate(M,tFinal,varargin)
            % simulate   Simulate model for a given time interval
            %   [T,X,U,Z] = simulate(M,tFinal,varargin) simulates the model
            %   from time 0 to tFinal, returning time, state, input, and
            %   output arrays. A first order Euler solver is used.
            %
            %   The additional arguments are optional and come in
            %   string/value pairs. The optional arguments are as follows:
            %   - enableSensorNoise: flag indicating whether to consider
            %     sensor noise in the simulation
            %   - enableProcessNoise: flag indicating whether to consider
            %     process noise in the simulation
            %   - printTime: the number of time points after which to print
            %     the current status of the simulation
            %   - x0: initial state with which to begin the simulation
            %   - t0: initial time with which to begin the simulation
            
            % Ensure inputEqn is present
            if isempty(M.inputEqnHandle)
                error('Model requires an input equation.');
            end
            
            % Set default options
            options.enableProcessNoise = 0;
            options.enableSensorNoise = 0;
            options.printTime = Inf;
            options.x0 = [];
            options.t0 = 0;
            
            % Create a structure from the string, value pairs
            args = struct(varargin{:});
            % Set options from the function arguments
            names = fieldnames(args);
            for i=1:length(names)
                options.(names{i}) = args.(names{i});
            end
            
            % Initialize
            [x0, u0, z0] = M.getDefaultInitialization(0);
            if ~isempty(options.x0)
                x0 = options.x0;
                z0 = M.outputEqn(options.t0,x0,u0,options.enableSensorNoise*M.generateSensorNoise());
            end
            
            % Preallocate output data: columns represent times
            T = options.t0:M.sampleTime:tFinal;
            X = zeros(length(x0),length(T));
            Z = zeros(length(z0),length(T));
            U = zeros(length(u0),length(T));
            
            % Set values for time 0
            X(:,1) = x0;
            U(:,1) = u0;
            Z(:,1) = z0;
            
            % Simulate
            x = x0;
            u = u0;
            for i=2:length(T)
                % Update state from time t-dt to time t
                x = M.stateEqn(T(i-1),x,u,options.enableProcessNoise*M.generateProcessNoise());
                % Get inputs for time t
                u = M.inputEqn(T(i));
                % Compute outputs for time t
                z = M.outputEqn(T(i),x,u,options.enableSensorNoise*M.generateSensorNoise());
                % Update output data
                X(:,i) = x;
                U(:,i) = u;
                Z(:,i) = z;
                if mod(i-1,options.printTime)==0
                    fprintf('t=%.2f\n',T(i));
                    fprintf('  States:\n');
                    M.printStates(x);
                    fprintf('  Inputs:\n');
                    M.printInputs(u);
                    fprintf('  Outputs:\n');
                    M.printOutputs(z);
                end
            end
        end
        
        
        function printStates(M,x)
            % printStates   print the names and values for the given state
            % vector
            for s=1:length(M.states)
                fprintf('    %s = %g %s\n',M.states(s).name,x(s),M.states(s).units);
            end
        end
        
        
        function printOutputs(M,z)
            % printOutputs   print the names and values for the given
            % output vector
            for o=1:length(M.outputs)
                fprintf('    %s = %g %s\n',M.outputs(o).name,z(o),M.outputs(o).units);
            end
        end
        
        
        function printInputs(M,u)
            % printInputs   print the names and values for the given input
            % vector
            for i=1:length(M.inputs)
                fprintf('    %s = %g %s\n',M.inputs(i).name,u(i),M.inputs(i).units);
            end
        end
        
        
        function h = plotOutputs(M,varargin)
            % plotOutputs   plot outputs against time
            %   plotOutputs(M,varargin) plots the given arguments (time
            %   vector, value vector pairs) on subplots in a figure. If the
            %   number of arguments is odd, the final argument is a Boolean
            %   indicating whether to plot on separate plots (true) or a
            %   single plot with subplots (false)
            h = M.plotVars('outputs',varargin);
        end
        
        
        function h = plotStates(M,varargin)
            % plotStates   plot states against time
            %   plotStates(M,varargin) plots the given arguments (time
            %   vector, value vector pairs) on subplots in a figure. If the
            %   number of arguments is odd, the final argument is a Boolean
            %   indicating whether to plot on separate plots (true) or a
            %   single plot with subplots (false)
            h = M.plotVars('states',varargin);
        end
        
        
        function h = plotInputs(M,varargin)
            % plotInputs   plot inputs against time
            %   plotInputs(M,varargin) plots the given arguments (time
            %   vector, value vector pairs) on subplots in a figure. If the
            %   number of arguments is odd, the final argument is a Boolean
            %   indicating whether to plot on separate plots (true) or a
            %   single plot with subplots (false)
            h = M.plotVars('inputs',varargin);
        end
        
    end
    
    
    methods (Access = private)
        
        function setIndices(M)
            % setIndices   setup the indices structure
            for i=1:length(M.states)
                name = M.states(i).name;
                M.indices.states.(name) = i;
            end
            for i=1:length(M.inputs)
                name = M.inputs(i).name;
                M.indices.inputs.(name) = i;
            end
            for i=1:length(M.outputs)
                name = M.outputs(i).name;
                M.indices.outputs.(name) = i;
            end
        end
        
        
        function h = plotVars(M,vars,varargin)
            % plotVars   plot specified variables against time
            %   The vars input can be 'states', 'inputs', or 'outputs'. The
            %   varargin are the same as for the other plot functions, they
            %   are time vector and value pairs. The final optional
            %   argument is whether to plot on separate plots (true) or
            %   subplots on a single figure (false).
            
            % If odd number of arguments, last one is whether or not to do
            % separate plots
            h = [];
            args = varargin{1};
            numVars = length(M.(vars));
            if mod(length(args),2)==1
                separatePlots = args{end};
                args = args(1:end-1);
            else
                separatePlots = 0;
            end
            
            for i=1:numVars
                if separatePlots
                    h(end+1) = figure;
                else
                    h(end+1) = subplot(numVars,1,i);
                end
                cla;
                hold on;
                for j=1:2:length(args)
                    T = args{j};
                    V = args{j+1};
                    plot(T,V(i,:));
                end
                hold off;
                xlim([T(1) max(T(end),T(end))]);
                ylim(M.(vars)(i).ylim);
                title(M.(vars)(i).name);
                ylabel(M.(vars)(i).units);
                xlabel('Time (s)');
            end
        end
        
    end
    
end
