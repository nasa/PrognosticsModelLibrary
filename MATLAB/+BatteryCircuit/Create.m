function model = Create
% Create   Construct a PrognosticsModel for the battery equivalent circuit
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

import BatteryCircuit.*;

P = Parameters;

% States
states(1) = struct('name','Tb','units','','Noise',P.v.('Tb'),'x0',P.x0.('Tb'),'ylim',[-Inf Inf]);
states(2) = struct('name','qb','units','','Noise',P.v.('qb'),'x0',P.x0.('qb'),'ylim',[-Inf Inf]);
states(3) = struct('name','qcp','units','','Noise',P.v.('qcp'),'x0',P.x0.('qcp'),'ylim',[-Inf Inf]);
states(4) = struct('name','qcs','units','','Noise',P.v.('qcs'),'x0',P.x0.('qcs'),'ylim',[-Inf Inf]);

% Inputs
inputs(1) = struct('name','i','units','','ylim',[-Inf Inf]);

% Outputs
outputs(1) = struct('name','Tbm','units','','Noise',P.n.('Tbm'),'ylim',[-Inf Inf]);
outputs(2) = struct('name','Vm','units','','Noise',P.n.('Vm'),'ylim',[-Inf Inf]);

model = Model.PrognosticsModel('name','BatteryCircuit','P',P,...
    'stateEqnHandle',@StateEqn,'inputEqnHandle',@InputEqn,...
    'outputEqnHandle',@OutputEqn,'thresholdEqnHandle',@ThresholdEqn,...
    'states',states,'inputs',inputs,'outputs',outputs,...
    'sampleTime',P.sampleTime);
