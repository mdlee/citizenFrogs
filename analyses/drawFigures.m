% figures and non-modeling analyses for citizen frogs

clear;
close all;

printFigures = true;

analysisList = {...
  % 'voteProportion'; ...
  %'voteMajority'; ...
  %'voteROCs'; ...
  % 'frogPond'; ...
  % 'frogPondZonderKikker'; ...
  % 'frogPondMale'; ...
  %'peopleByClipByFrog'; ...
 % 'peopleByClip'; ...
  %'threeModels'; ...
  'covarianceStructure'; ...
  %'expertiseComparison'; ...
  };

% load data
dataDir = '../data/';
dataName = 'citizenFrogsAll'; srtFrg = [1 6 5 2 3 4 7];
%dataName = 'citizenFrogsSecondDataSet'; srtFrg = 1:9;
load([dataDir dataName], 'd');

% constants
load pantoneColors pantone;
generalDir = '../general/';

% loops over analyses
addpath(generalDir);
for analysisIdx = 1:numel(analysisList)
  analysisName = analysisList{analysisIdx};

  switch analysisName
    case 'voteProportion'
      analysisName = sprintf('%s_%s', analysisName, dataName);
      vote = nansum(d.y, 3)./sum(~isnan(d.y), 3);
      drawEnvironmentDynamics(d, vote', srtFrg, pantone);

    case 'voteMajority'
      analysisName = sprintf('%s_%s', analysisName, dataName);
      vote = nansum(d.y, 3)./sum(~isnan(d.y), 3);
      drawEnvironmentDynamics(d, double(vote' >= 0.5), srtFrg, pantone);

    case 'voteROCs'
      analysisName = sprintf('%s_%s', analysisName, dataName);
      vote = nansum(d.y, 3)./sum(~isnan(d.y), 3);
      drawROCs(d, [], [], vote, pantone);

    case 'frogPond'

      fontSize = 14;

      % pond pictures
      [metKikker, ~, ~] = imread('../data/images/metKikker.png');
      [zonderKikker, ~, ~] = imread('../data/images/zonderKikker.png');
      [citizenScientist, ~, ~] = imread('../data/images/citizenScientist.png');
      [notebook, ~, ~] = imread('../data/images/notebook.png');
      %    [oneHighTree, ~, ~] = imread('../data/images/oneHighTree.png');

      % crop
      keep = 200:900;
      citizenScientist = citizenScientist(:, 200:900, :);

      F = figure; clf; hold on;
      setFigure(F, [0.2 0.2 0.6 0.5], '');

      set(gca, ...
        'xlim'       , [0 1]                , ...
        'ylim'       , [0 1]                 , ...
        'fontsize'   , fontSize                  );
      axis off;
      A = gca;

      hAxes = axes('units', 'norm', 'position', [0 0 0.45 1]);
      axis off;
      axes(hAxes);
      imshow(uint8(metKikker));

      hAxes = axes('units', 'norm', 'position', [0.375 0 0.6 0.6]);
      axis off;
      axes(hAxes);
      imshow(uint8(citizenScientist));

      hAxes = axes('units', 'norm', 'position', [0.75 0.2 0.3 0.3]);
      axis off;
      axes(hAxes);
      imshow(uint8(notebook));

      axes(A);
      clear T
      T(1) = text(0.15, 1.05, 'environment');
      T(2) = text(0.7, 1.05, 'person');
      T(3) = text(1, 1.05, 'data');

      set(T, 'fontsize', fontSize+2, 'fontweight', 'bold', ...
        'vert', 'top', 'hor', 'cen');
      print(sprintf('figures/%s_0.png', analysisName), '-dpng');
      print(sprintf('figures/%s_0.eps', analysisName), '-depsc');

      hAxes = axes('units', 'norm', 'position', [0.6 0.675 0.3 0.15], 'clipping', 'off');
      axis off;
      w = 0.2; h = 0.25; r = 0.6; gap = 0.01;

      axes(hAxes); hold on;
      axis([0 1 -r r]);
      T(1) = text(0, r, 'present  ', 'hor', 'right');
      H(1) = plot(0, r, 'o');
      L(1) = plot([0 w], r+[0 h], 'k-');
      L(2) = plot([0 w], r+[0 -h], 'k-');
      T(2) = text(w, r+h, '  hit', 'hor', 'left');
      H(2) = plot(w, r+h, 'o');
      H(3) = plot(w, r-h, 'o');
      L(3) = plot([w 2*w], r-[h h+h/2], 'k-');
      L(4) = plot([w 2*w], r-[h h-h/2], 'k-');

      T(3) = text(2*w, r-h+h/2, '  hit', 'hor', 'left');
      H(4) = plot(2*w,  r-h+h/2, 'o');
      T(4) = text(2*w, r-h-h/2, '  miss', 'hor', 'left');
      H(5) = plot(2*w,  r-h-h/2, 'o');

      T(5) = text(0, -r, 'absent  ', 'hor', 'right');
      H(6) = plot(0, -r, 'o');
      L(5) = plot([0 w], -r+[0 w], 'k-');
      L(6) = plot([0 w], -r+[0 -w], 'k-');
      T(6) = text(w, -r+w, '  false alarm', 'hor', 'left');
      H(7) = plot(w, -r+w, 'o');
      T(7) = text(w, -r-w, '  correct rejection', 'hor', 'left');
      H(8) = plot(w, -r-w, 'o');

      TU(1) = text(w/2, r+h/2+gap, '$\alpha$');
      TL(1) = text(w/2, r-h/2-gap, '$1-\alpha$');
      TU(2) = text(w+w/2, r-h+h/2, '$\beta$');
      TL(2) = text(w+w/2, r-h-h/2-gap, '$1-\beta$');
      TU(3) = text(w/2, -r+h/2, '$\beta$');
      TL(3) = text(w/2, -r-h/2-gap, '$1-\beta$');


      set(T, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'mid');
      set(H, 'markerfacecolor', 'k', 'markeredgecolor', 'k', ...
        'markersize', 6)
      set(TU, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'bot', 'interp', 'latex', 'hor', 'cen');
      set(TL, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'top', 'interp', 'latex', 'hor', 'cen');

      axes(A);
      plot([0.21 0.51], [0.09 0.87], 'k--');
      plot([0.825 0.975],  [0.82 0.325], 'k--');

    case 'frogPondMale'

      fontSize = 14;

      % pond pictures
      [metKikker, ~, ~] = imread('../data/images/metKikker.png');
      [zonderKikker, ~, ~] = imread('../data/images/zonderKikker.png');
      [citizenScientist, ~, ~] = imread('../data/images/citizenScientistMale.png');
      [notebook, ~, ~] = imread('../data/images/notebook.png');

      % crop
      keep = 200:900;
      citizenScientist = citizenScientist(:, 200:900, :);

      F = figure; clf; hold on;
      setFigure(F, [0.2 0.2 0.6 0.5], '');

      set(gca, ...
        'xlim'       , [0 1]                , ...
        'ylim'       , [0 1]                 , ...
        'fontsize'   , fontSize                  );
      axis off;
      A = gca;

      hAxes = axes('units', 'norm', 'position', [0 0 0.45 1]);
      axis off;
      axes(hAxes);
      imshow(uint8(metKikker));

      hAxes = axes('units', 'norm', 'position', [0.375 0 0.6 0.6]);
      axis off;
      axes(hAxes);
      imshow(uint8(citizenScientist));

      hAxes = axes('units', 'norm', 'position', [0.75 0.2 0.3 0.3]);
      axis off;
      axes(hAxes);
      imshow(uint8(notebook));

      axes(A);
      clear T
      T(1) = text(0.15, 1.05, 'environment');
      T(2) = text(0.7, 1.05, 'person');
      T(3) = text(1, 1.05, 'data');

      set(T, 'fontsize', fontSize+2, 'fontweight', 'bold', ...
        'vert', 'top', 'hor', 'cen');


    case 'frogPondZonderKikker'

      fontSize = 14;

      % pond pictures
      [metKikker, ~, ~] = imread('../data/images/metKikker.png');
      [zonderKikker, ~, ~] = imread('../data/images/zonderKikker.png');
      [citizenScientist, ~, ~] = imread('../data/images/citizenScientist.png');
      [notebook, ~, ~] = imread('../data/images/notebook.png');
      %    [oneHighTree, ~, ~] = imread('../data/images/oneHighTree.png');

      % crop
      keep = 200:900;
      citizenScientist = citizenScientist(:, 200:900, :);

      F = figure; clf; hold on;
      setFigure(F, [0.2 0.2 0.6 0.5], '');

      set(gca, ...
        'xlim'       , [0 1]                , ...
        'ylim'       , [0 1]                 , ...
        'fontsize'   , fontSize                  );
      axis off;
      A = gca;

      hAxes = axes('units', 'norm', 'position', [0 0 0.45 1]);
      axis off;
      axes(hAxes);
      imshow(uint8(zonderKikker));

      hAxes = axes('units', 'norm', 'position', [0.375 0 0.6 0.6]);
      axis off;
      axes(hAxes);
      imshow(uint8(citizenScientist));

      hAxes = axes('units', 'norm', 'position', [0.75 0.2 0.3 0.3]);
      axis off;
      axes(hAxes);
      imshow(uint8(notebook));

      axes(A);
      clear T
      T(1) = text(0.15, 1.05, 'environment');
      T(2) = text(0.7, 1.05, 'person');
      T(3) = text(1, 1.05, 'data');

      set(T, 'fontsize', fontSize+2, 'fontweight', 'bold', ...
        'vert', 'top', 'hor', 'cen');

    case 'peopleByClipByFrog'
      analysisName = sprintf('%s_%s', analysisName, dataName);

      % constants
      fontSize = 18;
      xLo = 1; xHi = d.nStimuli;
      yLo = 1; yHi = d.nPeople;
      colorPosterior = pantone.ClassicBlue;
      colorMarginal = pantone.DuskBlue;

      for frogIdx = 1:d.nFrogs

        F = figure; clf; hold on;
        setFigure(F, [0.2 0.2 0.6 0.5], '');

        mainAX = gca;
        set(mainAX, ...
          'units'      , 'normalized'              , ...
          'position'   , [0.125 0.15 0.6 0.6]        , ...
          'xlim'       , [xLo xHi]                , ...
          'xtick'      , [xLo xHi]            , ...
          'ylim'       , [yLo yHi]                 , ...
          'ytick'      , [yLo yHi]             , ...
          'box'        , 'off'                     , ...
          'tickdir'    , 'out'                     , ...
          'layer'      , 'top'                     , ...
          'ticklength' , [0.01 0]                  , ...
          'layer'      , 'top'                     , ...
          'fontsize'   , fontSize                  );
        moveAxis(gca, [1 1 1 1], [0.025 0 0 0]);
        xlabel('Clip', 'fontsize', fontSize+4, 'vert', 'bot');
        ylabel('People', 'fontsize', fontSize+4, 'vert', 'top');
        T = text(d.nStimuli+200, d.nPeople+100, d.frogs{frogIdx}, ...
          'vert', 'bot', ...
          'fontsize', fontSize, ...
          'fontweight', 'bold');
        Raxes(gca, 0.01, 0.01);

        % draw joint
        for xIdx = xLo:xHi
          for yIdx = yLo:yHi
            if ~isnan(d.y(frogIdx, xIdx, yIdx))
              height = 1; %sqrt(count(xIdx, yIdx)) * scaleHeight;
              width = 1; %sqrt(count(xIdx, yIdx)) * scaleWidth;
              rectangle('position', [xIdx-width/2 yIdx-height/2 width height], ...
                'curvature' , [0 0]                  , ...
                'facecolor' , colorPosterior , ...
                'edgecolor' , colorPosterior );
            end
          end
        end

        xVal = squeeze(sum(~isnan(d.y(frogIdx, :, :)), 3));
        pos = get(mainAX, 'position');
        xAx = axes; hold on;
        set(xAx, ...
          'units'      , 'normalized'                             , ...
          'position'   , [pos(1) pos(2)+pos(4)+0.075 pos(3) 0.15]   , ...
          'xlim'       , [xLo xHi]                              , ...
          'xtick'      , [xLo xHi]                         , ...
          'xticklabel' , []                                       , ...
          'xcolor'     , pantone.Titanium                         , ...
          'ylim'       , [0 max(xVal)]            , ...
          'ytick'      , [0 max(xVal)] , ...
          'box'        , 'off'                                    , ...
          'tickdir'    , 'out'                                    , ...
          'layer'      , 'top'                                    , ...
          'ticklength' , [0.01 0]                                 , ...
          'layer'      , 'top'                                    , ...
          'fontsize'   , fontSize                                 );
        Raxes(gca, 0.01, 0.01);

        keep = find(xVal > 0);
        bar(keep, xVal(keep), 0.8, ...
          'facecolor' , colorMarginal , ...
          'edgecolor' , colorMarginal                 );

        yVal = squeeze(sum(~isnan(d.y(frogIdx, :, :)), 2));
        yAx = axes; hold on;
        set(yAx, ...
          'units'      , 'normalized'                                  , ...
          'position'   , [pos(1)+pos(3)+0.05 pos(2) 0.125 pos(4)]     , ...
          'xlim'       , [0 max(yVal)]                 , ...
          'xtick'      , [0 max(yVal)] , ...
          'ycolor'     , pantone.Titanium                              , ...
          'ylim'       , [yLo yHi]                             , ...
          'ytick'      , [yLo yHi]                     , ...
          'yticklabel' , []                                            , ...
          'box'        , 'off'                                         , ...
          'tickdir'    , 'out'                                         , ...
          'layer'      , 'top'                                         , ...
          'ticklength' , [0.01 0]                                      , ...
          'layer'      , 'top'                                         , ...
          'fontsize'   , fontSize                                      );
        Raxes(gca, 0.01, 0.01);

        keep = find(yVal > 0);
        barh(keep, yVal(keep), 0.8, ...
          'facecolor' , colorMarginal , ...
          'edgecolor' , colorMarginal'                );
        % print
        if printFigures
          if ~isfolder('figures')
            !mkdir figures
          end
          print(sprintf('figures/%s_%s.png', analysisName, d.frogs{frogIdx}), '-dpng');
          print(sprintf('figures/%s_%s.eps', analysisName, d.frogs{frogIdx}), '-depsc');
        end

      end
      close all
      printFigures = false;

    case 'peopleByClip'
      analysisName = sprintf('%s_%s', analysisName, dataName);

      % constants
      fontSize = 18;
      xLo = 1; xHi = d.nStimuli;
      yLo = 1; yHi = d.nPeople;
      colorPosterior = pantone.ClassicBlue;
      colorMarginal = pantone.DuskBlue;
      faceAlpha = 0.9;
      frogColor = {...
        pantone.GreenFlash; ...
        pantone.Treetop; ...
        pantone.Greenery; ...
        pantone.Kale; ...
        pantone.Comfrey; ...
        pantone.Woodbine; ...
        pantone.Cypress; ...
        pantone.BiscayBay; ...
        pantone.Hemlock; ...
        };

      F = figure; clf; hold on;
      setFigure(F, [0.2 0.2 0.6 0.5], '');

      mainAX = gca;
      set(mainAX, ...
        'units'      , 'normalized'              , ...
        'position'   , [0.125 0.15 0.6 0.6]        , ...
        'xlim'       , [xLo xHi]                , ...
        'xtick'      , [xLo xHi]            , ...
        'ylim'       , [yLo yHi]                 , ...
        'ytick'      , [yLo yHi]             , ...
        'box'        , 'off'                     , ...
        'tickdir'    , 'out'                     , ...
        'layer'      , 'top'                     , ...
        'ticklength' , [0.01 0]                  , ...
        'layer'      , 'top'                     , ...
        'fontsize'   , fontSize                  );
      moveAxis(gca, [1 1 1 1], [0.025 0 0 0]);
      xlabel('Clip', 'fontsize', fontSize+4, 'vert', 'bot');
      ylabel('People', 'fontsize', fontSize+4, 'vert', 'top');
      Raxes(gca, 0.01, 0.01);

      % draw joint
      for xIdx = xLo:xHi
        for yIdx = yLo:yHi
          if sum(~isnan(d.y(:, xIdx, yIdx)) >= 1)
            height = 1; %sqrt(count(xIdx, yIdx)) * scaleHeight;
            width = 1; %sqrt(count(xIdx, yIdx)) * scaleWidth;
            rectangle('position', [xIdx-width/2 yIdx-height/2 width height], ...
              'curvature' , [0 0]                  , ...
              'facecolor' , colorPosterior , ...
              'edgecolor' , colorPosterior );
          end
        end
      end

      % xVal = squeeze(sum(sum(~isnan(d.y(:, :, :)), 3), 1));
      xVal = nan(d.nStimuli, d.nFrogs);
      for frogIdx = 1:d.nFrogs
        xVal(:, frogIdx) = sum(squeeze(~isnan(d.y(frogIdx, :, :))), 2);
      end
      pos = get(mainAX, 'position');
      xAx = axes; hold on;
      set(xAx, ...
        'units'      , 'normalized'                             , ...
        'position'   , [pos(1) pos(2)+pos(4)+0.075 pos(3) 0.15]   , ...
        'xlim'       , [xLo xHi]                              , ...
        'xtick'      , [xLo xHi]                         , ...
        'xticklabel' , []                                       , ...
        'xcolor'     , pantone.Titanium                         , ...
        'ylim'       , [0 max(sum(xVal, 2))]            , ...
        'ytick'      , [0 max(sum(xVal, 2))] , ...
        'box'        , 'off'                                    , ...
        'tickdir'    , 'out'                                    , ...
        'layer'      , 'top'                                    , ...
        'ticklength' , [0.01 0]                                 , ...
        'layer'      , 'top'                                    , ...
        'fontsize'   , fontSize                                 );
      Raxes(gca, 0.01, 0.01);

      keep = find(sum(xVal, 2) > 0);
      H = bar(keep, xVal(keep, :), 1, 'stacked');
      for frogIdx = 1:d.nFrogs
        set(H(frogIdx), ...
          'facecolor', frogColor{frogIdx}, ...
          'edgecolor', 'none', ...
          'facealpha', faceAlpha);
      end

      yVal = squeeze(sum(sum(~isnan(d.y(:, :, :)), 2), 1));
      yAx = axes; hold on;
      set(yAx, ...
        'units'      , 'normalized'                                  , ...
        'position'   , [pos(1)+pos(3)+0.05 pos(2) 0.125 pos(4)]     , ...
        'xlim'       , [0 max(yVal)]                 , ...
        'xtick'      , [0 max(yVal)] , ...
        'ycolor'     , pantone.Titanium                              , ...
        'ylim'       , [yLo yHi]                             , ...
        'ytick'      , [yLo yHi]                     , ...
        'yticklabel' , []                                            , ...
        'box'        , 'off'                                         , ...
        'tickdir'    , 'out'                                         , ...
        'layer'      , 'top'                                         , ...
        'ticklength' , [0.02 0]                                      , ...
        'layer'      , 'top'                                         , ...
        'fontsize'   , fontSize                                      );
      Raxes(gca, 0.01, 0.005);

      keep = find(yVal > 0);
      barh(keep, yVal(keep), 0.8, ...
        'facecolor' , colorMarginal , ...
        'edgecolor' , colorMarginal'                );

    case 'threeModels'

      w = 0.2; h = 0.25; r = 0.6; gap = 0.015;
      fontSize = 22;

      F = figure; clf; hold on;
      setFigure(F, [0.1 0.2 0.8 0.6], '');

      subplot(1, 3, 1); cla; hold on;
      set(gca, ...
        'units', 'norm', 'position', [0.1 0.25 0.25 0.25], ...
        'clipping', 'off');
      axis off;

      axis([0 1 -r r]);
      T(1) = text(0, r, 'present  ', 'hor', 'right');
      H(1) = plot(0, r, 'o');
      L(1) = plot([0 w], r+[0 h], 'k-');
      L(2) = plot([0 w], r+[0 -h], 'k-');
      T(2) = text(w, r+h, '  hit', 'hor', 'left');
      H(2) = plot(w, r+h, 'o');
      H(3) = plot(w, r-h, 'o');
      L(3) = plot([w 2*w], r-[h h+h/2], 'k-');
      L(4) = plot([w 2*w], r-[h h-h/2], 'k-');

      T(3) = text(2*w, r-h+h/2, '  hit', 'hor', 'left');
      H(4) = plot(2*w,  r-h+h/2, 'o');
      T(4) = text(2*w, r-h-h/2, '  miss', 'hor', 'left');
      H(5) = plot(2*w,  r-h-h/2, 'o');

      T(5) = text(0, -r, 'absent  ', 'hor', 'right');
      H(6) = plot(0, -r, 'o');
      L(5) = plot([0 w], -r+[0 w], 'k-');
      L(6) = plot([0 w], -r+[0 -w], 'k-');
      T(6) = text(w, -r+w, '  false alarm', 'hor', 'left');
      H(7) = plot(w, -r+w, 'o');
      T(7) = text(w, -r-w, '  correct rejection', 'hor', 'left');
      H(8) = plot(w, -r-w, 'o');

      TU(1) = text(w/2, r+h/2+gap, '$\alpha$');
      TL(1) = text(w/2, r-h/2-gap, '$1-\alpha$');
      TU(2) = text(w+w/2, r-h+h/2, '$\beta$');
      TL(2) = text(w+w/2, r-h-h/2-gap, '$1-\beta$');
      TU(3) = text(w/2, -r+h/2, '$\beta$');
      TL(3) = text(w/2, -r-h/2-gap, '$1-\beta$');


      set(T, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'mid');
      set(H, 'markerfacecolor', 'k', 'markeredgecolor', 'k', ...
        'markersize', 6)
      set(TU, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'bot', 'interp', 'latex', 'hor', 'cen');
      set(TL, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'top', 'interp', 'latex', 'hor', 'cen');

      subplot(1, 3, 2); cla; hold on;
      set(gca, ...
        'units', 'norm', 'position', [0.4 0.25 0.25 0.25], ...
        'clipping', 'off');

      axis off;

      axis([0 1 -r r]);
      T(1) = text(0, r, 'present  ', 'hor', 'right');
      H(1) = plot(0, r, 'o');
      L(1) = plot([0 w], r+[0 h], 'k-');
      L(2) = plot([0 w], r+[0 -h], 'k-');
      T(2) = text(w, r+h, '  hit', 'hor', 'left');
      H(2) = plot(w, r+h, 'o');
      H(3) = plot(w, r-h, 'o');
      L(3) = plot([w 2*w], r-[h h+h/2], 'k-');
      L(4) = plot([w 2*w], r-[h h-h/2], 'k-');

      T(3) = text(2*w, r-h+h/2, '  hit', 'hor', 'left');
      H(4) = plot(2*w,  r-h+h/2, 'o');
      T(4) = text(2*w, r-h-h/2, '  miss', 'hor', 'left');
      H(5) = plot(2*w,  r-h-h/2, 'o');

      T(5) = text(0, -r, 'absent  ', 'hor', 'right');
      H(6) = plot(0, -r, 'o');
      L(5) = plot([0 w], -r+[0 h], 'k-');
      L(6) = plot([0 w], -r+[0 -h], 'k-');
      T(6) = text(w, -r+h, '  false alarm', 'hor', 'left');
      H(7) = plot(w, -r+h, 'o');
      H(8) = plot(w, -r-h, 'o');
      L(7) = plot([w 2*w], -r-[h h+h/2], 'k-');
      L(8) = plot([w 2*w], -r-[h h-h/2], 'k-');

      T(7) = text(2*w, -r-h+h/2, '  false alarm', 'hor', 'left');
      H(9) = plot(2*w,  -r-h+h/2, 'o');
      T(8) = text(2*w, -r-h-h/2, '  correct rejection', 'hor', 'left');
      H(10) = plot(2*w,  -r-h-h/2, 'o');

      TU(1) = text(w/2, r+h/2+gap, '$\alpha$');
      TL(1) = text(w/2, r-h/2-gap, '$1-\alpha$');
      TU(2) = text(w+w/2, r-h+h/2, '$\beta$');
      TL(2) = text(w+w/2, r-h-h/2-gap, '$1-\beta$');
      TU(3) = text(w/2, -r+h/2+gap, '$\alpha$');
      TL(3) = text(w/2, -r-h/2-gap, '$1-\alpha$');
      TU(4) = text(w+w/2, -r-h+h/2, '$\beta$');
      TL(4) = text(w+w/2, -r-h-h/2-gap, '$1-\beta$');

      set(T, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'mid');
      set(H, 'markerfacecolor', 'k', 'markeredgecolor', 'k', ...
        'markersize', 6)
      set(TU, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'bot', 'interp', 'latex', 'hor', 'cen');
      set(TL, 'fontsize', fontSize, 'fontweight', 'normal', ...
        'vert', 'top', 'interp', 'latex', 'hor', 'cen');



      subplot(1, 3, 3); cla; hold on;
      set(gca, ...
        'units', 'norm', 'position', [0.65 0.2 0.25 0.4], ...
        'clipping', 'off');
      % axis off;

      kO = 0.85;
      dO = 2.25;
      clear H;

      % constants
      x = -2:.01:6;
      colors = {pantone.DuskBlue;  pantone.Treetop; pantone.Custard; pantone.Marsala};
      labels = {'hit', 'false alarm', 'miss', 'correct rejection'};
      scale = 0.8;
      jig = -0.185;
      notch = 0.2;

      set(gca, ...
        'xlim'       , x([1 end])  , ...
        'xtick'      , 0:x(end)    , ...
        'ylim'        , [0 1], ...
        'ycolor'      , 'none'    , ...
        'box'        , 'off'                 , ...
        'tickdir'    , 'out'                 , ...
        'layer'      , 'top'                 , ...
        'ticklength' , [0.01 0]              , ...
        'layer'      , 'top'                 , ...
        'fontsize'   , fontSize              );
      set(gca, 'xtick', [0  dO], 'xticklabel', {'0', ''});

      yS = scale*exp(-(x - dO).^2);
      yN = scale*exp(-(x - 0).^2);
      match1 = find(x > kO);
      match2 = find(x < kO);

      H(1) = patch([x(match1(1)) x(match1) x(match1(1))], [0 yS(match1) 0], 'k', ...
        'facecolor' , colors{1}, ...
        'edgecolor' , 'w'               , ...
        'facealpha' , 0.8               );

      H(2) = patch([x(match1(1)) x(match1) x(match1(1))], [0 yN(match1) 0], 'k', ...
        'facecolor' , colors{4}, ...
        'edgecolor' , 'w'               , ...
        'facealpha' , 0.8               );

      H(4) = patch([x(match2(end)) x(match2) x(match2(end))], [0 yN(match2) 0], 'k', ...
        'facecolor' , colors{3}, ...
        'edgecolor' , 'w'               , ...
        'facealpha' , 0.8               );

      H(3) = patch([x(match2(end)) x(match2) x(match2(end))], [0 yS(match2) 0], 'k', ...
        'facecolor' , colors{2}, ...
        'edgecolor' , 'w'               , ...
        'facealpha' , 0.8               );


      plot([kO kO], [0 scale], '-', ...
        'linewidth', 2, ...
        'color', pantone.Kale);

      text(kO, scale, '$k$', ...
        'fontsize', fontSize+2, ...
        'vertical', 'bottom', ...
        'horizontal', 'center', ...
        'interp', 'latex');

      text(dO, jig, '$d^\prime$', ...
        'fontsize', fontSize+2, ...
        'vertical', 'bottom', ...
        'horizontal', 'center', ...
        'interp', 'latex');

      L = legend(H, labels, ...
        'fontsize', fontSize-2, ...
        'box', 'off', ...
        'autoupdate', 'off', ...
        'location', 'northeast');
      set(L, 'position', get(L, 'position') + [0.1 0 0 0]);

      clear T
      yVal = 1.2;
      T(1) = text(0, yVal, 'Signal detection');
      T(2) = text(-10, yVal, 'Two high threshold');
      T(3) = text(-20, yVal, 'One high threshold');
      set(T, 'fontsize', 20, 'fontweight', 'bold');

    case 'covarianceStructure'
      analysisName = sprintf('%s_%s', analysisName, dataName);

      c = cov(d.truth');

      imagesc(c);          % Displays image with scaled colors
      colorbar;            % Adds a color scale guide
      title('Covariance Matrix');
      xlabel('Variables');
      ylabel('Variables');
      axis square;         % Makes the plot square
      set(gca, ...
        'xtick', 1:d.nFrogs, ...
        'xticklabel', d.frogs, ...
        'ytick', 1:d.nFrogs, ...
        'yticklabel', d.frogs);

    case 'expertiseComparison'

      fontSize = 18;


      modelName = 'twoHighThresholdNoDifferencesAsymmetricDynamics_n';
      engine = 'jags';
      fileName = sprintf('%s_%s_%s.mat', modelName, dataName, engine);
      analysisName = sprintf('%s_%s_%s', analysisName, dataName, modelName);

      fprintf('Loading pre-stored samples for model %s on data %s\n', modelName, dataName);
      load(sprintf('../models/storage/%s', fileName), 'chains', 'stats', 'diagnostics', 'info');
      alpha = codatable(chains, 'alpha', @mean);

      if isfield(d, 'users')
      pat = '^b[a-zA-Z]{4,5}\d{5}$';
      ok = ~cellfun(@isempty, regexpi(d.users, pat, 'once'));   % logical mask
      students = find(ok);
      citizens = find(~ok);

      mean(alpha(students))
      mean(alpha(citizens))

      F = figure; clf; hold on;
      setFigure(F, [0.2 0.2 0.4 0.4], '');

      % axis
      set(gca, ...
        'xlim'       , [0 1]    , ...
        'xtick'      , 0:0.2:1    , ...
        'ycolor'       , 'none'    , ...
        'box'        , 'off'     , ...
        'tickdir'    , 'out'     , ...
        'layer'      , 'top'     , ...
        'ticklength' , [0.02 0]  , ...
        'layer'      , 'top'     , ...
        'clipping'   , 'off'     , ...
        'fontsize'   , fontSize  );
      xlabel('Detection Probability', 'fontsize', fontSize+4);

      edges = linspace(min(alpha), max(alpha), 21);   % 20 bins

      histogram(alpha(citizens),  edges, 'FaceColor', pantone.ClassicBlue, 'FaceAlpha', 0.6);
      histogram(alpha(students), edges, 'FaceColor', pantone.Custard, 'FaceAlpha', 0.6);
      legend({'Citizens', 'Students'}, 'box', 'off', 'fontsize', fontSize);
      end
  end

  % print
  if printFigures
    if ~isfolder('figures')
      !mkdir figures
    end
    print(sprintf('figures/%s.png', analysisName), '-dpng');
    print(sprintf('figures/%s.eps', analysisName), '-depsc');
  end

end
rmpath(generalDir);