%% Rasch model for citizen frog aggregation

clear; close all;

preLoad = true;
printFigures = true;

dataDir = ('../data/');
dataList = {...
  'citizenFrogsGBF'; ...
  };

figureList = { ...
  %'quickDirty'; ...
  'ROCs'; ...
  };

% MCMC properties
engine = 'jags';
params = {'alpha', 'beta', 'tau', 'phi'};

nChains    = 4;     % number of MCMC chains
nBurnin    = 1e0;   % number of discarded burn-in samples
nSamples   = 1e2;   % number of collected samples
nThin      = 1;     % number of samples between those collected
doParallel = 1;     % whether MATLAB parallel toolbox parallizes chains

%% Constants
load pantoneColors pantone;

%% Loop over datasets
for dataIdx = 1:numel(dataList)
  dataName = dataList{dataIdx};
  load([dataDir dataName], 'd');

    modelName = 'rasch_1';
    data = struct(...
      'nStimuli'    , d.nStimuli       , ...
      'nPeople'     , d.nPeople        , ...
      'nTrials'     , d.nTrials   , ...
      'person'      , d.personLong, ...
      'stimulus'    , d.stimulusLong, ...
      'y'           , d.yLong);
    generator = @()struct('alpha', randn(d.nPeople, 1));
 



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

  alpha = get_matrix_from_coda(chains, 'alpha');
  beta = get_matrix_from_coda(chains, 'beta');
  tau = get_matrix_from_coda(chains, 'tau');
  accuracy = (d.personCorrect+1)./(d.personTotal+2);
    vote = nansum(d.y, 2)./sum(~isnan(d.y), 2);
  

  for figureIdx = 1:numel(figureList)

    switch figureList{figureIdx}
      case 'ROCs'

        fontSize = 16;
        tickWidth = 0.2;
        curveTick = 0.001;
        lineWidth = 4;
        modelColor = pantone.Greenery;
        majorityColor = pantone.Fiesta;
        labs = {'model', 'vote'};

        [nRows, nCols] = subplotArrange(d.nFrogs);

        F = figure; clf; hold on;
        setFigure(F, [0.2 0.2 0.6 0.5], '');

        for frogIdx = 1:d.nFrogs

          subplot(nRows, nCols, frogIdx); cla; hold on;

          set(gca, ...
            'xlim'       , [0 1]                , ...
            'xtick'      , 0:tickWidth:1            , ...
            'xticklabelrot', 0, ...
            'ylim'       , [0 1]                 , ...
            'ytick'      , 0:tickWidth:1             , ...
            'xgrid'       , 'off'                       , ...
            'ygrid'       , 'off'                       , ...
            'box'        , 'off'                     , ...
            'color'       , 'none' , ...
            'tickdir'    , 'out'                     , ...
            'layer'      , 'top'                     , ...
            'ticklength' , [0.02 0]                  , ...
            'layer'      , 'top'                     , ...
            'fontsize'   , fontSize                  );
          moveAxis(gca, [1 1 1 1], [0 0.025 0 0]);
          axis equal; axis square;
          if frogIdx == (nRows*nCols - nCols + 1)
            xlabel('False Alarm Rate', 'fontsize', fontSize+2);
            ylabel('Hit Rate', 'fontsize', fontSize+2);
          end

          plot([0 1], [0 1], 'k--', 'linewidth', 1);
          Raxes(gca, 0.01, 0.01);
          A = gca;

            text(0, 1, d.frogs, ...
              'vert', 'top', ...
              'hor', 'left', ...
              'fontweight', 'bold', ...
              'fontsize', fontSize);
        

          % model
          hitList = [];
          faList = [];
          for threshold = 0:curveTick:1
              tauPrime = (tau >= threshold);
              hit = length(find(tauPrime == 1 & d.truth == 1))/sum(d.truth == 1);
              fa = length(find(tauPrime == 1 & d.truth == 0))/sum(d.truth == 0);
           hitList = [hitList hit];
            faList = [faList fa];
          end

          H(1) = plot(faList, hitList, '-', ...
            'linewidth', lineWidth, ...
            'color', modelColor);

          % vote
          hitList = [];
          faList = [];
          for threshold = 0:curveTick:1
              votePrime = (vote >= threshold);
              hit = length(find(votePrime == 1 & d.truth == 1))/sum(d.truth == 1);
              fa = length(find(votePrime == 1 & d.truth == 0))/sum(d.truth == 0);
            hitList = [hitList hit];
            faList = [faList fa];
            end


          H(2) = plot(faList, hitList, '-', ...
            'linewidth', lineWidth, ...
            'color', majorityColor);

          if frogIdx == d.nFrogs
            L = legend(H, labs, ...
              'box', 'off', ...
              'fontsize', fontSize, ...
              'location', 'east');
            set(L, 'pos', get(L, 'pos') + [0.1 0 0 0]);
          end

        end

        % Quick and dirty phi, detection x accuracy, bias x accuracy
      case 'quickDirty'


        F = figure; clf; hold on;
        setFigure(F, [0.2 0.2 0.6 0.4], '');

        subplot(1, 3, 1); hold on;
        smhist(chains, 'phi');
        plot(ones(1,2)*mean(d.truth), get(gca, 'ylim'), '-', 'color', 'k');
        set(gca, 'xlim', [0 1]);
        axis square;

        subplot(1, 3, 2); hold on;
        plot(alpha, accuracy, 'k+');
        axis([0 1 0 1]);
        axis square;
        xlabel('detection probability');
        ylabel('accuracy');

        subplot(1, 3, 3); hold on;
        plot(beta, accuracy, 'k+');
        axis([0 1 0 1]);
        axis square;
        xlabel('guessing bias');
        ylabel('accuracy');

    end

    % print
    if printFigures
      if ~isfolder('figures')
        !mkdir figures
      end
      warning off;
      print(sprintf('figures/%s_%s_%s.png', modelName, dataName, figureList{figureIdx}), '-dpng');
      print(sprintf('figures/%s_%s_%s.eps', modelName, dataName, figureList{figureIdx}), '-depsc');
      warning on;
    end
  end

end