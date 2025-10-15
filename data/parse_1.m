%% Citizen Frogs data parse
%
% Using data from:
% @Article{thorpe2024using,
%   author    = {Thorpe, Alex and Kelly, Oliver and Callen, Alex and Griffin, Andrea S and Brown, Scott D},
%   journal   = {Behavior Research Methods},
%   title     = {Using a cognitive model to understand crowdsourced data from citizen scientists},
%   year      = {2024},
%   number    = {4},
%   pages     = {3589--3605},
%   volume    = {56},
%   doi       = {https://doi.org/10.3758/s13428-023-02289-w},
%   publisher = {Springer},
% }
% via: https://osf.io/wqmkf


clear;

% %% GBF Data
% % this corresponds to Experiment 2 (the "Two Frog Analysis") 
% % in Thorpe et al because, as they note,
% % the expert never identifies the LLJ frog in any trial
% dataDir = ('./');
% dataName = 'citizenFrogsGBF';
% 
% % think LW from 308-313 should be 001100 not 000200
% % see fix from 2 to 1 below (and it implicitly assumes one above is
% % neither)
% 
% % this file is no longer on the OSF
% % it seems to match the GBF information in Ingar Matrix 3, with the first column "Olli" as the expert
% % except the new file has more judges
% % parse this for comparison to published results
% T = readtable('Ingar matrix_Expert.csv', 'NumHeaderLines', 1);
% m = T{:, ExcelColNo('D'):ExcelColNo('VR')};
% e = T{:, ExcelColNo('C')};
% 
% d.info = 'citizen and expert detection of GBF frog';
% d.truth = double(e(1:3:end) == 1); % 1:3:end just indexes GBF
% d.y = m(1:3:end, :);
% d.y(find(d.y == 2)) = 1;
% [d.nStimuli, d.nPeople] = size(d.y);
% 
% yLong = [];
% personLong = [];
% stimulusLong = [];
% correctLong = [];
% for i = 1:d.nStimuli
%   for j = 1:d.nPeople
%     if ~isnan(d.y(i, j))
%       yLong = [yLong d.y(i, j)];
%       personLong = [personLong j];
%       stimulusLong = [stimulusLong i];
%       correctLong = [correctLong double(d.y(i, j) == d.truth(i))];
%     end
%   end
% end
% d.yLong = yLong;
% d.personLong = personLong;
% d.stimulusLong = stimulusLong;
% d.correctLong = correctLong;
% d.nTrials = length(yLong);
% 
% d.personCorrect = nan(d.nPeople, 1);
% d.personTotal = nan(d.nPeople, 1);
% for j = 1:d.nPeople
%   d.personCorrect(j) = sum(d.correctLong(d.personLong == j));
%   d.personTotal(j) = sum((d.personLong == j));
% end
% 
% save([dataDir dataName], 'd');

%% All Frog Data
% this conceptually corresponds to the multiple frogs contexts of Experiment 1 
% but with the updated community data
dataDir = ('./');
dataName = 'citizenFrogsAll';

% think LW from 308-313 should be 001100 not 000200
% see fix from 2 to 1 below (and it implicitly assumes one above is
% neither)

% this file is no longer on the OSF
% it seems to match the GBF information in Ingar Matrix 3, with the first column "Olli" as the expert
% except the new file has more judges
% parse this for comparison to published results
T = readtable('Ingar Matrix 3 - complete community.xlsx', 'NumHeaderLines', 1);
m = T{:, ExcelColNo('H'):ExcelColNo('XU')};
e = T{:, ExcelColNo('G')};

d.info = 'citizen and expert detection of many frogs';
d.frogs = T{1:11, ExcelColNo('F')};
d.nFrogs = numel(d.frogs);
[~, d.nPeople] = size(m);
tmp = length(m);
d.nStimuli = tmp/d.nFrogs;

d.truth = nan(d.nFrogs, d.nStimuli);
d.y = nan(d.nFrogs, d.nStimuli, d.nPeople);

for frogIdx = 1:d.nFrogs
  d.truth(frogIdx, :) = (e(frogIdx:d.nFrogs:end) == 1);
  for personIdx = 1:d.nPeople
d.y(frogIdx, :, personIdx) = m(frogIdx:d.nFrogs:end, personIdx);
  end
end

yLong = [];
personLong = [];
stimulusLong = [];
correctLong = [];
frogLong = [];
for i = 1:d.nStimuli
  for j = 1:d.nPeople
    for k = 1:d.nFrogs
    if ~isnan(d.y(k, i, j))
      yLong = [yLong d.y(k, i, j)];
      personLong = [personLong j];
      stimulusLong = [stimulusLong i];
      frogLong = [frogLong k];
      correctLong = [correctLong d.y(k, i, j) == d.truth(k, i)];
    end
  end
  end
end
d.yLong = yLong;
d.personLong = personLong;
d.stimulusLong = stimulusLong;
d.frogLong = frogLong;
d.correctLong = correctLong;
d.nTrials = length(yLong);

d.personCorrect = nan(d.nPeople, 1);
d.personTotal = nan(d.nPeople, 1);
for j = 1:d.nPeople
  d.personCorrect(j) = sum(d.correctLong(d.personLong == j));
  d.personTotal(j) = sum((d.personLong == j));
end

save([dataDir dataName], 'd');

