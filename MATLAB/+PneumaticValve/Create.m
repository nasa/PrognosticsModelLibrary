function model = Create
% Create   Construct a PrognosticsModel for the pneumatic valve
%
%   The pneumatic chamber is split into two control volumes, divided by the
%   piston. Gas ports are located at the top and bottom of the chamber, and
%   they are filled/evacuated with pneumatic gas individually. To open the
%   valve, the bottom chamber is pressurized and the top chamber is opened
%   to atmosphere. To close the valve, the opposite operation takes place.
%
%   Copyright (c) 2016 United States Government as represented by the
%   Administrator of the National Aeronautics and Space Administration.
%   No copyright is claimed in the United States under Title 17, U.S.
%   Code. All Other Rights Reserved.

import PneumaticValve.*;

P = Parameters;

% States
states(1) = struct('name','Aeb','units','','Noise',P.v.('Aeb'),'x0',P.x0.('Aeb'),'ylim',[-Inf Inf]);
states(2) = struct('name','Aet','units','','Noise',P.v.('Aet'),'x0',P.x0.('Aet'),'ylim',[-Inf Inf]);
states(3) = struct('name','Ai','units','','Noise',P.v.('Ai'),'x0',P.x0.('Ai'),'ylim',[-Inf Inf]);
states(4) = struct('name','condition','units','','Noise',P.v.('condition'),'x0',P.x0.('condition'),'ylim',[-Inf Inf]);
states(5) = struct('name','k','units','','Noise',P.v.('k'),'x0',P.x0.('k'),'ylim',[-Inf Inf]);
states(6) = struct('name','mBot','units','','Noise',P.v.('mBot'),'x0',P.x0.('mBot'),'ylim',[-Inf Inf]);
states(7) = struct('name','mTop','units','','Noise',P.v.('mTop'),'x0',P.x0.('mTop'),'ylim',[-Inf Inf]);
states(8) = struct('name','r','units','','Noise',P.v.('r'),'x0',P.x0.('r'),'ylim',[-Inf Inf]);
states(9) = struct('name','v','units','','Noise',P.v.('v'),'x0',P.x0.('v'),'ylim',[-Inf Inf]);
states(10) = struct('name','wb','units','','Noise',P.v.('wb'),'x0',P.x0.('wb'),'ylim',[-Inf Inf]);
states(11) = struct('name','wi','units','','Noise',P.v.('wi'),'x0',P.x0.('wi'),'ylim',[-Inf Inf]);
states(12) = struct('name','wk','units','','Noise',P.v.('wk'),'x0',P.x0.('wk'),'ylim',[-Inf Inf]);
states(13) = struct('name','wr','units','','Noise',P.v.('wr'),'x0',P.x0.('wr'),'ylim',[-Inf Inf]);
states(14) = struct('name','wt','units','','Noise',P.v.('wt'),'x0',P.x0.('wt'),'ylim',[-Inf Inf]);
states(15) = struct('name','x','units','','Noise',P.v.('x'),'x0',P.x0.('x'),'ylim',[-Inf Inf]);

% Inputs
inputs(1) = struct('name','pL','units','','ylim',[-Inf Inf]);
inputs(2) = struct('name','pR','units','','ylim',[-Inf Inf]);
inputs(3) = struct('name','uBot','units','','ylim',[-Inf Inf]);
inputs(4) = struct('name','uTop','units','','ylim',[-Inf Inf]);

% Outputs
outputs(1) = struct('name','Qm','units','','Noise',P.n.('Qm'),'ylim',[-Inf Inf]);
outputs(2) = struct('name','indicatorBotm','units','','Noise',P.n.('indicatorBotm'),'ylim',[-Inf Inf]);
outputs(3) = struct('name','indicatorTopm','units','','Noise',P.n.('indicatorTopm'),'ylim',[-Inf Inf]);
outputs(4) = struct('name','pressureBotm','units','','Noise',P.n.('pressureBotm'),'ylim',[-Inf Inf]);
outputs(5) = struct('name','pressureTopm','units','','Noise',P.n.('pressureTopm'),'ylim',[-Inf Inf]);
outputs(6) = struct('name','xm','units','','Noise',P.n.('xm'),'ylim',[-Inf Inf]);

model = Model.PrognosticsModel('name','PneumaticValve','P',P,...
    'stateEqnHandle',@StateEqn,'inputEqnHandle',@InputEqn,...
    'outputEqnHandle',@OutputEqn,'thresholdEqnHandle',@ThresholdEqn,...
    'states',states,'inputs',inputs,'outputs',outputs,...
    'sampleTime',P.sampleTime);
