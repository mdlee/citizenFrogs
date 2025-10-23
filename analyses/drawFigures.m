% figures and non-modeling analyses for citizen frogs

clear;
close all;

printFigures = false;

analysisList = {...
   %  'voteProportion'; ...
   %  'voteMajority'; ...
   %'voteROCs'; ...
   'frogPond'; ...
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
   imshow(uint8(zonderKikker));

 hAxes = axes('units', 'norm', 'position', [0.375 0.1 0.65 0.65]);
   axis off;
   axes(hAxes);
   imshow(uint8(citizenScientist));

       hAxes = axes('units', 'norm', 'position', [0.525 0.7 0.25 0.25]);
  % axis off;
   axes(hAxes); hold on;
       axis([0 1 0 1]);
       w = 0.25; h = 0.175; r = 0.8; gap = 0.075;
   T(1) = text(0, 0.5, 'present  ', 'hor', 'right');
   H(1) = plot(0, 0.5, 'o');
L(1) = plot([0 w], [0.5 0.5+w], 'k-');
L(2) = plot([0 w], [0.5 0.5-w], 'k-');
   T(2) = text(w, 0.5+w, '  hit', 'hor', 'left');
   H(2) = plot(w, 0.5+w, 'o');
   L(5) = plot([w 2*w], [0.5-w 0.5-w+w/2], 'k-');
   L(6) = plot([w 2*w], [0.5-w 0.5-w-w/2], 'k-');
   T(3) = text(w, 0.5-w, '  miss', 'hor', 'left');
   H(3) = plot(w, 0.5-w, 'o');

      T(4) = text(r, 0.5, 'absent  ', 'hor', 'right');
   H(4) = plot(r, 0.5, 'o');
L(3) = plot([0 w]+r, [0.5 0.5+w], 'k-');
L(4) = plot([0 w]+r, [0.5 0.5-w], 'k-');
   T(5) = text(w+r, 0.5+w, '  false alarm', 'hor', 'left');
   H(5) = plot(w+r, 0.5+w, 'o');
   T(6) = text(w+r, 0.5-w, '  correct rejection', 'hor', 'left');
   H(6) = plot(w+r, 0.5-w, 'o');

   TU(1) = text(w/2, 0.5+h/2+gap, '$\alpha$');
   TL(1) = text(w/2, 0.5-h/2-gap, '$1-\alpha$');
   TU(2) = text(w/2+r, 0.5+h/2+gap, '$\beta$');
   TL(2) = text(w/2+r, 0.5-h/2-gap, '$1-\beta$');


set(T, 'fontsize', fontSize, 'fontweight', 'normal', ...
      'vert', 'mid');
   set(H, 'markerfacecolor', 'k', 'markeredgecolor', 'k', ...
      'markersize', 6)
   set(TU, 'fontsize', fontSize+4, 'fontweight', 'normal', ...
      'vert', 'bot', 'interp', 'latex', 'hor', 'cen');
   set(TL, 'fontsize', fontSize+4, 'fontweight', 'normal', ...
      'vert', 'top', 'interp', 'latex', 'hor', 'cen');


    hAxes = axes('units', 'norm', 'position', [0.75 0.2 0.3 0.3]);
   axis off;
   axes(hAxes);
   imshow(uint8(notebook));

   axes(A);
   clear T;
   T(1) = text(0.15, 1.05, 'environment');
   T(2) = text(0.7, 1.05, 'scientist');
   T(3) = text(1, 1.05, 'data');


   set(T, 'fontsize', fontSize+2, 'fontweight', 'bold', ...
      'vert', 'mid', 'hor', 'cen');
return

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