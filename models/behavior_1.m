%% One high threshold model for citizen frog aggregation
% no differences assumes each person's alpha and beta applies to all frogs
% asymmetric dynamics allows for different base rates with different
% arriving and leaving probabilities

clear; close all;

preLoad = false;
printFigures = true;

dataDir = ('../data/');
dataList = {...
   'citizenFrogsSecondDataSet'; ...
    'citizenFrogsAll'; ...
   };

figureList = { ...
    % 'parameters'; ...
  % 'threeROCs'; ...
   'fourROCs'; ...
   %'environmentDynamics'; ...
   };

% MCMC properties
engine = 'jags';
params = {'tau', 'phi', 'theta'};

% nChains    = 8;     % number of MCMC chains
% nBurnin    = 2e3;   % number of discarded burn-in samples
% nSamples   = 2e3;   % number of collected samples
% nThin      = 10;     % number of samples between those collected
% doParallel = 1;     % whether MATLAB parallel toolbox parallizes chains
nChains    = 6;     % number of MCMC chains
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

   switch dataName
      case 'citizenFrogsAll'
         stimuliKeep = 1260; % 1260 is full for data set 1, 481 for dataset 2
         srtFrg = [1 6 5 2 3 4 7];
         spLoc = [1 5 6 7 3 2 8];
         legLoc = 4;
         figSize = [0.2 0.2 0.6 0.5];
         slideLeft = 0;

      case 'citizenFrogsSecondDataSet'
         stimuliKeep = 481; % 1260 is full for data set 1, 481 for dataset 2
         srtFrg = 1:9;
         spLoc = 1:9;
         legLoc = 9;
         figSize = [0.15 0.2 0.575 0.6];
         slideLeft = 0.075;
   end

   keep = find(d.stimulusLong <= stimuliKeep);
   d.nTrials = length(keep);
   d.personLong = d.personLong(keep);
   d.stimulusLong = d.stimulusLong(keep);
   d.yLong = d.yLong(keep);

   modelName = 'behavior_n';
   data = struct(...
      'nStimuli'    , d.nStimuli       , ...
      'nPeople'     , d.nPeople        , ...
      'nTrials'     , d.nTrials   , ...
      'nFrogs'      , d.nFrogs    , ...
      'person'      , d.personLong, ...
      'stimulus'    , d.stimulusLong, ...
      'frog'        , d.frogLong, ...
      'y'           , d.yLong);
   generator = @()struct('alpha', rand(d.nPeople, 1));

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
         'allowunderscores', 1                                         , ...
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
   tau = get_matrix_from_coda(chains, 'tau');
   accuracy = (d.personCorrect+1)./(d.personTotal+2);
   vote = nansum(d.y, 3)./sum(~isnan(d.y), 3);

   tau = tau(1:stimuliKeep, :);
   d.truth = d.truth(:, 1:stimuliKeep);
   vote = vote(:, 1:stimuliKeep);


   for figureIdx = 1:numel(figureList)

      switch figureList{figureIdx}
         case 'threeROCs'

            tauEnvironment = tau;

            otherModelName = 'oneHighThresholdNoDifferences_n';
            otherFileName = sprintf('%s_%s_%s.mat', otherModelName, dataName, engine);
            load(sprintf('storage/%s', otherFileName), 'chains', 'stats', 'diagnostics', 'info');
            tauCognitive = get_matrix_from_coda(chains, 'tau');

            drawThreeROCs_2(d, tauEnvironment, tauCognitive, vote, spLoc, legLoc, figSize, slideLeft, pantone);

                     case 'fourROCs'

            tauEnvironment = tau;

            otherModelName = 'oneHighThresholdNoDifferences_n';
            otherFileName = sprintf('%s_%s_%s.mat', otherModelName, dataName, engine);
            load(sprintf('storage/%s', otherFileName), 'chains', 'stats', 'diagnostics', 'info');
            tauCognitive = get_matrix_from_coda(chains, 'tau');

                        otherModelName = 'oneHighThresholdNoDifferencesAsymmetricDynamics_n';
            otherFileName = sprintf('%s_%s_%s.mat', otherModelName, dataName, engine);
            load(sprintf('storage/%s', otherFileName), 'chains', 'stats', 'diagnostics', 'info');
            tauBoth = get_matrix_from_coda(chains, 'tau');

            drawFourROCs_2(d, tauBoth, tauEnvironment, tauCognitive, vote, spLoc, legLoc, figSize, slideLeft, pantone);


            % detection, guess x accuracy
         case 'parameters'

            drawParametersHighThreshold(d, chains, alpha, beta, accuracy, pantone);

         case 'environmentDynamics'

        drawEnvironmentDynamics(d, tau, srtFrg, pantone);

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