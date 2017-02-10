classdef PrognosticsModel < Model.Model
% PrognosticsModel   Class for defining a model for prognostics
% 
% The PrognosticsModel class is a wrapper around a mathematical model of a
% system as represented by a state, output, input, and threshold equations.
% It is a subclass of the Model class, with the addition of a threshold
% equation, which defines when some condition, such as end-of-life, has
% been reached.
%
% PrognosticsModel Methods:
%   thresholdEqn - equation evaluating whether some region of the state
%   space has been reached.
%   simulateToThreshold - function to simulate the model up to the point
%   where there threshold evaulates to true
%
% See also Model.Model
%
% Copyright (c) 2016 United States Government as represented by the
% Administrator of the National Aeronautics and Space Administration.
% No copyright is claimed in the United States under Title 17, U.S.
% Code. All Other Rights Reserved.
    
    properties
        
        thresholdEqnHandle;  % Handle to threshold equation
        
    end
    
    methods
        
        function M = PrognosticsModel(varargin)
            % PrognosticsModel   Constructor
            %   Contruct a PrognosticsModel object given various arguments.
            %   The arguments are string, value pairs, e.g.,
            %   PrognosticsModel('thresholdEqnHandle',thresholdEqn,...).
            %   The following arguments are required:
            %   - thresholdEqnHandle: function handle to threshold equation
            %   - inputEqnHandle: function handle to input equation
            
            % Explicitly call Model constructor
            M@Model.Model(varargin{:});
            
            % Create a structure from the string, value pairs
            args = struct(varargin{:});
            
            % Set object properties from the function arguments
            properties = fieldnames(args);
            for i=1:length(properties)
                M.(properties{i}) = args.(properties{i});
            end
            
            % Check for required properties
            requiredProperties = {'thresholdEqnHandle' 'inputEqnHandle'};
            for i=1:length(requiredProperties)
                if isempty(M.(requiredProperties{i}))
                    error('%s is a required property!',requiredProperties{i});
                end
            end
        end
        
        
        function B = thresholdEqn(M,t,X,U)
            % thresholdEqn   Compute whether the threshold has been reached
            %   B = thresholdEqn(M,t,X,U) returns a Boolean B indicating
            %   whether for time t, states X, and inputs U, the threshold
            %   has been reached. The threshold equation determines whether
            %   the system is in some specified region of the joint
            %   state-input space.
			B = M.thresholdEqnHandle(M.P,t,X,U);
        end
        
        
        function [T,X,U,Z] = simulateToThreshold(M,varargin)
            % simulate   Simulate model until the threshold is reached
            %   [T,X,U,Z] = simulateToThreshold(M,varargin) simulates the
            %   model from time 0 until the threshold equation evaluates to
            %   true, returning time, state, input, and output arrays. A
            %   first order Euler solver is used.
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
            
            % Setup output data: columns represent times
            t = options.t0;
            T = t;
            X = zeros(length(x0),1);
            Z = zeros(length(z0),1);
            U = zeros(length(u0),1);
            
            % Set values for time 0
            X(:,1) = x0;
            U(:,1) = u0;
            Z(:,1) = z0;
            
            % Simulate
            i = 2;
            x = x0;
            u = u0;
            while ~M.thresholdEqn(t,x,u)
                % Update state from time t to time t+dt
                x = M.stateEqn(t,x,u,options.enableProcessNoise*M.generateProcessNoise(),M.sampleTime);
                % Update time
                t = t + M.sampleTime;
                % Get inputs for time t
                u = M.inputEqn(t);
                % Compute outputs for time t
                z = M.outputEqn(t,x,u,options.enableSensorNoise*M.generateSensorNoise());
                % Update output data
                T(i) = t;
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
                % Increment index
                i = i + 1;
            end
        end 
        
    end
    
end
