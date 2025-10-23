function  drawROCs(d, chains, tau, vote, pantone)
%DRAWROCs Draw the ROC analysis of citizen frogs

fontSize = 16;
tickWidth = 0.2;
curveTick = 0.001;
lineWidth = 4;
modelColor = pantone.Greenery;
majorityColor = pantone.Fiesta;
labs = {'model', 'vote'};
spLoc = [1 5 6 7 3 2 8];
legLoc = 4;

[nRows, nCols] = subplotArrange(d.nFrogs);

F = figure; clf; hold on;
setFigure(F, [0.2 0.2 0.6 0.5], '');

for frogIdx = 1:d.nFrogs

   subplot(nRows, nCols, spLoc(frogIdx)); cla; hold on;

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
   moveAxis(gca, [1 1 1 1], [0 0.02 0 0]);
   axis equal; axis square;
   if spLoc(frogIdx) == (nRows*nCols - nCols + 1)
      xlabel('False Alarm Rate', 'fontsize', fontSize+2);
      ylabel('Hit Rate', 'fontsize', fontSize+2);
   end

   plot([0 1], [0 1], 'k--', 'linewidth', 1);
   Raxes(gca, 0.01, 0.0075);
   A = gca;

   ax = get(gca, 'position');
   normalizedPosition = [ax(1)+ax(3)-0.11, ax(2)+0.01, 0.14, 0.14*6/5];
   hAxes = axes('Position', normalizedPosition);
   axis off;
   axes(hAxes);
   imshow(uint8(d.images(:, :, :, frogIdx)));

   axes(A);
   text(0.3, 0, d.frogs{frogIdx}, ...
      'vert', 'bot', ...
      'hor', 'cen', ...
      'fontweight', 'bold', ...
      'fontsize', fontSize);


   % model
   if ~isempty(tau)
      hitList = [1];
      faList = [1];
      for threshold = 0:curveTick:1
         if d.nFrogs == 1
            tauPrime = (tau >= threshold);
            hit = length(find(tauPrime == 1 & d.truth == 1))/sum(d.truth == 1);
            fa = length(find(tauPrime == 1 & d.truth == 0))/sum(d.truth == 0);
         else
            tauPrime = tau(:, frogIdx) >= threshold;
            hit = length(find(tauPrime' == 1 & d.truth(frogIdx, :) == 1))/sum(d.truth(frogIdx, :) == 1);
            fa = length(find(tauPrime' == 1 & d.truth(frogIdx, :) == 0))/sum(d.truth(frogIdx, :) == 0);
         end
         hitList = [hitList hit];
         faList = [faList fa];
      end
      hitList = [hitList 0];
      faList = [faList 0];

      H(1) = plot(faList, hitList, '-', ...
         'linewidth', lineWidth, ...
         'color', modelColor);
   end

   % vote
   hitList = [];
   faList = [];
   for threshold = 0:curveTick:1
      if d.nFrogs == 1
         votePrime = (vote >= threshold);
         hit = length(find(votePrime == 1 & d.truth == 1))/sum(d.truth == 1);
         fa = length(find(votePrime == 1 & d.truth == 0))/sum(d.truth == 0);
      else
         votePrime = vote(frogIdx, :) >= threshold;
         hit = length(find(votePrime == 1 & d.truth(frogIdx, :) == 1))/sum(d.truth(frogIdx, :) == 1);
         fa = length(find(votePrime == 1 & d.truth(frogIdx, :) == 0))/sum(d.truth(frogIdx, :) == 0);
      end
      hitList = [hitList hit];
      faList = [faList fa];
   end

   H(2) = plot(faList, hitList, '-', ...
      'linewidth', lineWidth, ...
      'color', majorityColor);

end

if ~isempty(tau)
   subplot(nRows, nCols, legLoc); axis off;
   L = legend(H, labs, ...
      'box', 'off', ...
      'fontsize', fontSize, ...
      'location', 'north');
   set(L, 'pos', get(L, 'pos') + [0 0.5 0 0]);
end