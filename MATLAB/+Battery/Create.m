function model = Create
% Create   Construct a PrognosticsModel for the battery
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

import Battery.*;

P = Parameters;

% States
states(1) = struct('name','Tb','units','K','Noise',P.v.('Tb'),'x0',P.x0.('Tb'),'ylim',[-Inf Inf]);
states(2) = struct('name','Vo','units','V','Noise',P.v.('Vo'),'x0',P.x0.('Vo'),'ylim',[-Inf Inf]);
states(3) = struct('name','Vsn','units','V','Noise',P.v.('Vsn'),'x0',P.x0.('Vsn'),'ylim',[-Inf Inf]);
states(4) = struct('name','Vsp','units','V','Noise',P.v.('Vsp'),'x0',P.x0.('Vsp'),'ylim',[-Inf Inf]);
states(5) = struct('name','qnB','units','C','Noise',P.v.('qnB'),'x0',P.x0.('qnB'),'ylim',[-Inf Inf]);
states(6) = struct('name','qnS','units','C','Noise',P.v.('qnS'),'x0',P.x0.('qnS'),'ylim',[-Inf Inf]);
states(7) = struct('name','qpB','units','C','Noise',P.v.('qpB'),'x0',P.x0.('qpB'),'ylim',[-Inf Inf]);
states(8) = struct('name','qpS','units','C','Noise',P.v.('qpS'),'x0',P.x0.('qpS'),'ylim',[-Inf Inf]);

% Inputs
inputs(1) = struct('name','P','units','W','ylim',[-Inf Inf]);

% Outputs
outputs(1) = struct('name','Tbm','units','degrees C','Noise',P.n.('Tbm'),'ylim',[-Inf Inf]);
outputs(2) = struct('name','Vm','units','V','Noise',P.n.('Vm'),'ylim',[-Inf Inf]);

model = Model.PrognosticsModel('name','Battery','P',P,...
    'stateEqnHandle',@StateEqn,'inputEqnHandle',@InputEqn,...
    'outputEqnHandle',@OutputEqn,'thresholdEqnHandle',@ThresholdEqn,...
    'initializeEqnHandle',@Initialize,...
    'states',states,'inputs',inputs,'outputs',outputs,...
    'sampleTime',P.sampleTime);
