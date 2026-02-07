%% Rasch model for citizen frog aggregation

clear; close all;

preLoad = true;
printFigures = true;

dataDir = ('../data/');
dataList = {...
  'citizenFrogsAll'; ...
  };

figureList = { ...
 'parameters'; ...
% 'ROCs'; ...
%  'environmentDynamics'; ...
  };

trialsKeep = 1260; % 1260 is full

% MCMC properties
engine = 'jags';
params = {'c', 'd', 'tau', 'phi'};

nChains    = 8;     % number of MCMC chains
nBurnin    = 1e3;   % number of discarded burn-in samples
nSamples   = 1e3;   % number of collected samples
nThin      = 1;     % number of samples between those collected
doParallel = 1;     % whether MATLAB parallel toolbox parallizes chains

%% Constants
load pantoneColors pantone;
generalDir = '../general/';

%% Loop over datasets
addpath(generalDir);
for dataIdx = 1:numel(dataList)
  dataName = dataList{dataIdx};
  load([dataDir dataName], 'd');

    modelName = 'signalDetectionNoDifferences_n';
    data = struct(...
      'nStimuli'    , d.nStimuli       , ...
      'nPeople'     , d.nPeople        , ...
      'nTrials'     , d.nTrials   , ...
      'nFrogs'      , d.nFrogs    , ...
      'person'      , d.personLong, ...
      'stimulus'    , d.stimulusLong, ...
      'frog'        , d.frogLong, ...
      'y'           , d.yLong);
    generator = @()struct('c', randn(d.nPeople, 1));

  %% Sample using Trinity
  fileName = sprintf('%s_%s_%s.mat', modelName, dataName, engine);

  if preLoad && isfile(sprintf('storage/%s', fileName))
    fprintf('Loading pre-stored samples for model %s on data %s\n', modelName, dataName);
    load(sprintf('storage/%s', fileName), 'chains', 'stats', 'diagnostics', 'info');
  else
    tic; % start clock
    [stats, chains, diagnostics, info] = callbayes(engine, ...
      'model'           , sprintf('%s_%s.txt', modelName, engine)   , ...
      'data'            , data                                      , ...
      'outputname'      , 'samples'                                 , ...
      'init'            , generator                                 , ...
      'datafilename'    , modelName                                 , ...
      'initfilename'    , modelName                                 , ...
      'scriptfilename'  , modelName                                 , ...
      'logfilename'     , sprintf('tmp/%s', modelName)              , ...
      'nchains'         , nChains                                   , ...
      'nburnin'         , nBurnin                                   , ...
      'nsamples'        , nSamples                                  , ...
      'monitorparams'   , params                                    , ...
      'thin'            , nThin                                     , ...
      'workingdir'      , sprintf('tmp/%s', modelName)              , ...
      'verbosity'       , 0                                         , ...
      'saveoutput'      , true                                      , ...
      'parallel'        , doParallel                                );
    fprintf('%s took %f seconds!\n', upper(engine), toc); % show timing
    fprintf('Saving samples for model %s on data %s\n', modelName, dataName);
    if ~isfolder('storage')
      !mkdir storage
    end
    save(sprintf('storage/%s', fileName), 'chains', 'stats', 'diagnostics', 'info');

    % convergence of each parameter
    disp('Convergence statistics:')
    grtable(chains, 1.05)

    % basic descriptive statistics
    disp('Descriptive statistics for all chains:')
    codatable(chains);

  end

    % just convergent enough chains
      [keepChains, rHat] = findKeepChains(chains.tau_1_2, 2, 1.1);
      keepChains = [7];
      fields = fieldnames(chains);
      for i = 1:numel(fields)
         chains.(fields{i}) = chains.(fields{i})(:, keepChains);
      end

  dPrime = get_matrix_from_coda(chains, 'd');
  c = get_matrix_from_coda(chains, 'c');
  tau = get_matrix_from_coda(chains, 'tau');
  accuracy = (d.personCorrect+1)./(d.personTotal+2);
  vote = nansum(d.y, 3)./sum(~isnan(d.y), 3);

  tau = tau(1:trialsKeep, :);
  d.truth = d.truth(:, 1:trialsKeep);
  vote = vote(:, 1:trialsKeep);

  for figureIdx = 1:numel(figureList)

    switch figureList{figureIdx}
      case 'ROCs'

        drawROCs(d, chains, tau, vote, pantone);

        % detection, guess x accuracy
      case 'parameters'

        drawParametersSDT(d, chains, dPrime, c, accuracy, pantone);

      case 'environmentDynamics'

        drawEnvironmentDynamics(d, tau, pantone);

      end

    % print
    if printFigures
      if ~isfolder('figures')
        !mkdir figures
      end
      warning off;
      print(sprintf('figures/%s_%s_%s_%s.png', engine, modelName, dataName, figureList{figureIdx}), '-dpng');
      print(sprintf('figures/%s_%s_%s_%s.eps', engine, modelName, dataName, figureList{figureIdx}), '-depsc');
      warning on;
    end
  end

end
rmpath(generalDir);