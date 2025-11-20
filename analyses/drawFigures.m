% figures and non-modeling analyses for citizen frogs

clear;
close all;

printFigures = true;

analysisList = {...
   %  'voteProportion'; ...
   % 'voteMajority'; ...
   %'voteROCs'; ...
   % 'frogPond'; ...
   % 'frogPondZonderKikker'; ...
   % 'frogPondMale'; ...
   %'peopleByClipByFrog'; ...
   'peopleByClip'; ...
   };

% load data
dataDir = '../data/';
dataName = 'citizenFrogsAll';
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
         vote = nansum(d.y, 3)./sum(~isnan(d.y), 3);
         drawEnvironmentDynamics(d, vote', pantone);

      case 'voteMajority'
         vote = nansum(d.y, 3)./sum(~isnan(d.y), 3);
         drawEnvironmentDynamics(d, double(vote' >= 0.5), pantone);

      case 'voteROCs'
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
         T(2) = text(0.7, 1.05, 'scientist');
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
         T(2) = text(0.7, 1.05, 'scientist');
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
         T(2) = text(0.7, 1.05, 'scientist');
         T(3) = text(1, 1.05, 'data');

         set(T, 'fontsize', fontSize+2, 'fontweight', 'bold', ...
            'vert', 'top', 'hor', 'cen');

      case 'peopleByClipByFrog'

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

      case 'peopleByClip'

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

   end

   % print
   if printFigures & ~isempty(get(groot, 'CurrentFigure'))
      if ~isfolder('figures')
         !mkdir figures
      end
      print(sprintf('figures/%s.png', analysisName), '-dpng');
      print(sprintf('figures/%s.eps', analysisName), '-depsc');
   end

end
rmpath(generalDir);