function model = Create
% Create   Construct a PrognosticsModel for the centrifugal pump
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

import CentrifugalPump.*;

P = Parameters;

% States
states(1) = struct('name','A','units','','Noise',P.v.('A'),'x0',P.x0.('A'),'ylim',[-Inf Inf]);
states(2) = struct('name','Q','units','','Noise',P.v.('Q'),'x0',P.x0.('Q'),'ylim',[-Inf Inf]);
states(3) = struct('name','To','units','','Noise',P.v.('To'),'x0',P.x0.('To'),'ylim',[-Inf Inf]);
states(4) = struct('name','Tr','units','','Noise',P.v.('Tr'),'x0',P.x0.('Tr'),'ylim',[-Inf Inf]);
states(5) = struct('name','Tt','units','','Noise',P.v.('Tt'),'x0',P.x0.('Tt'),'ylim',[-Inf Inf]);
states(6) = struct('name','rRadial','units','','Noise',P.v.('rRadial'),'x0',P.x0.('rRadial'),'ylim',[-Inf Inf]);
states(7) = struct('name','rThrust','units','','Noise',P.v.('rThrust'),'x0',P.x0.('rThrust'),'ylim',[-Inf Inf]);
states(8) = struct('name','w','units','','Noise',P.v.('w'),'x0',P.x0.('w'),'ylim',[-Inf Inf]);
states(9) = struct('name','wA','units','','Noise',P.v.('wA'),'x0',P.x0.('wA'),'ylim',[-Inf Inf]);
states(10) = struct('name','wRadial','units','','Noise',P.v.('wRadial'),'x0',P.x0.('wRadial'),'ylim',[-Inf Inf]);
states(11) = struct('name','wThrust','units','','Noise',P.v.('wThrust'),'x0',P.x0.('wThrust'),'ylim',[-Inf Inf]);

% Inputs
inputs(1) = struct('name','Tamb','units','','ylim',[-Inf Inf]);
inputs(2) = struct('name','V','units','','ylim',[-Inf Inf]);
inputs(3) = struct('name','pdisch','units','','ylim',[-Inf Inf]);
inputs(4) = struct('name','psuc','units','','ylim',[-Inf Inf]);
inputs(5) = struct('name','wsync','units','','ylim',[-Inf Inf]);

% Outputs
outputs(1) = struct('name','Qoutm','units','','Noise',P.n.('Qoutm'),'ylim',[-Inf Inf]);
outputs(2) = struct('name','Tom','units','','Noise',P.n.('Tom'),'ylim',[-Inf Inf]);
outputs(3) = struct('name','Trm','units','','Noise',P.n.('Trm'),'ylim',[-Inf Inf]);
outputs(4) = struct('name','Ttm','units','','Noise',P.n.('Ttm'),'ylim',[-Inf Inf]);
outputs(5) = struct('name','wm','units','','Noise',P.n.('wm'),'ylim',[-Inf Inf]);

model = Model.PrognosticsModel('name','CentrifugalPump','P',P,...
    'stateEqnHandle',@StateEqn,'inputEqnHandle',@InputEqn,...
    'outputEqnHandle',@OutputEqn,'thresholdEqnHandle',@ThresholdEqn,...
    'states',states,'inputs',inputs,'outputs',outputs,...
    'sampleTime',P.sampleTime);
