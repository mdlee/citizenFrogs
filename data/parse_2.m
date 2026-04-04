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

%% Second Data Set
% same clips in rows across two sheets, but different (overlapping) users
dataDir = ('./');
dataName = 'citizenFrogsSecondDataSet';

G = readtable('secondDataSetRaw/GROUND matrix.csv', 'VariableNamesLine', 1);
dG.users = G.Properties.VariableNames(4:end);
T = readtable('secondDataSetRaw/Updated_TREE matrix.csv', 'VariableNamesLine', 1);
dT.users = T.Properties.VariableNames(5:end-1);


G = readtable('secondDataSetRaw/GROUND matrix.csv', 'headerlines', 1);
T = readtable('secondDataSetRaw/Updated_TREE matrix.csv', 'headerlines', 1);

mG = G{:, ExcelColNo('D'):ExcelColNo('HW')};
m2G = str2double(G{:, ExcelColNo('HX')}); % different format 
mG = [mG m2G];
mG(find(mG==2)) = 1;
eG = G{:, ExcelColNo('C')};

mT = T{:, ExcelColNo('E'):ExcelColNo('IT')};
m2T = str2double(T{:, ExcelColNo('IU'):ExcelColNo('IY')}); % different format 
mT = [mT m2T];
mT(find(mT==2)) = 1;
eT = T{:, ExcelColNo('D')};

% remove 'none' judgments
match = ~strcmp(G{:, ExcelColNo('B')}, 'None');
keepG = find(match);
mG = mG(keepG, :);
eG = eG(keepG);

match = ~strcmp(T{:, ExcelColNo('B')}, 'None');
keepT = find(match);
mT = mT(keepT, :);
eT = eT(keepT);

dG.info = 'citizen and expert detection of many frogs, second data set, ground frogs';
dT.info = 'citizen and expert detection of many frogs, second data set, tree frogs';

dG.frogs = unique(G{keepG, ExcelColNo('B')});
dT.frogs = unique( T{keepT, ExcelColNo('B')});
dG.nFrogs = numel(dG.frogs);
dT.nFrogs = numel(dT.frogs);

[~, dG.nPeople] = size(mG);
tmp = length(mG);
dG.nStimuli = tmp/dG.nFrogs;

[~, dT.nPeople] = size(mT);
tmp = length(mT);
dT.nStimuli = tmp/dT.nFrogs;

%% ground
dG.truth = nan(dG.nFrogs, dG.nStimuli);
dG.y = nan(dG.nFrogs, dG.nStimuli, dG.nPeople);

for frogIdx = 1:dG.nFrogs
   dG.truth(frogIdx, :) = (eG(frogIdx:dG.nFrogs:end) == 1);
   for personIdx = 1:dG.nPeople
      dG.y(frogIdx, :, personIdx) = mG(frogIdx:dG.nFrogs:end, personIdx);
   end
end

% long format
yLong = [];
personLong = [];
stimulusLong = [];
correctLong = [];
frogLong = [];
truthLong = [];
for i = 1:dG.nStimuli
   for j = 1:dG.nPeople
      for k = 1:dG.nFrogs
         if ~isnan(dG.y(k, i, j))
            yLong = [yLong dG.y(k, i, j)];
            personLong = [personLong j];
            stimulusLong = [stimulusLong i];
            frogLong = [frogLong k];
            correctLong = [correctLong dG.y(k, i, j) == dG.truth(k, i)];
            truthLong = [truthLong dG.truth(k, i)];
         end
      end
   end
end
dG.yLong = yLong;
dG.personLong = personLong;
dG.stimulusLong = stimulusLong;
dG.frogLong = frogLong;
dG.correctLong = correctLong;
dG.truthLong = truthLong;
dG.nTrials = length(yLong);

dG.personCorrect = nan(dG.nPeople, 1);
dG.personTotal = nan(dG.nPeople, 1);
for j = 1:dG.nPeople
   dG.personCorrect(j) = sum(dG.correctLong(dG.personLong == j));
   dG.personTotal(j) = sum((dG.personLong == j));
end

%% tree
dT.truth = nan(dT.nFrogs, dT.nStimuli);
dT.y = nan(dT.nFrogs, dT.nStimuli, dT.nPeople);

for frogIdx = 1:dT.nFrogs
   dT.truth(frogIdx, :) = (eT(frogIdx:dT.nFrogs:end) == 1);
   for personIdx = 1:dT.nPeople
      dT.y(frogIdx, :, personIdx) = mT(frogIdx:dT.nFrogs:end, personIdx);
   end
end

% long format
yLong = [];
personLong = [];
stimulusLong = [];
correctLong = [];
frogLong = [];
truthLong = [];
for i = 1:dT.nStimuli
   for j = 1:dT.nPeople
      for k = 1:dT.nFrogs
         if ~isnan(dT.y(k, i, j))
            yLong = [yLong dT.y(k, i, j)];
            personLong = [personLong j];
            stimulusLong = [stimulusLong i];
            frogLong = [frogLong k];
            correctLong = [correctLong dT.y(k, i, j) == dT.truth(k, i)];
            truthLong = [truthLong dT.truth(k, i)];
         end
      end
   end
end
dT.yLong = yLong;
dT.personLong = personLong;
dT.stimulusLong = stimulusLong;
dT.frogLong = frogLong;
dT.correctLong = correctLong;
dT.truthLong = truthLong;
dT.nTrials = length(yLong);

dT.personCorrect = nan(dT.nPeople, 1);
dT.personTotal = nan(dT.nPeople, 1);
for j = 1:dT.nPeople
   dT.personCorrect(j) = sum(dT.correctLong(dT.personLong == j));
   dT.personTotal(j) = sum((dT.personLong == j));
end

%% combine
d.info = 'citizen and expert detection of many frogs, second data set, all frogs';

d.frogs = unique([G{keepG, ExcelColNo('B')}; T{keepT, ExcelColNo('B')}], 'stable');
d.nFrogs = numel(d.frogs);
d.users = union(dG.users, dT.users)';
d.nPeople = numel(d.users);
d.nStimuli = dG.nStimuli; % same stimuli in same order in dG and dT

trim = 220;
d.images = nan(1024-2*trim+1, 1024-2*trim+1, 3, d.nFrogs);
for i = 1:d.nFrogs
  [RGB, ~, ~] = imread(sprintf('images/%s.png', lower(d.frogs{i})));
  d.images(:, :, :, i)  = RGB(trim:(1024-trim), trim:(1024-trim), :);
end

d.truth = nan(d.nFrogs, d.nStimuli);
d.y = nan(dT.nFrogs, dT.nStimuli, dT.nPeople);

for stimIdx = 1:d.nStimuli
   for frogIdx = 1:d.nFrogs
      if frogIdx <= dG.nFrogs
         d.truth(frogIdx, stimIdx) = dG.truth(frogIdx, stimIdx);
      else
         d.truth(frogIdx, stimIdx) = dT.truth(frogIdx-dG.nFrogs, stimIdx);
      end
   end
end

common = intersect(dG.users, dT.users);
for idx = 1:numel(common)
   [~, matchG] = ismember(common{idx}, dG.users);
   [~, matchT] = ismember(common{idx}, dT.users);
   [~, match] = ismember(common{idx}, d.users);
   for stimIdx = 1:d.nStimuli
      for frogIdx = 1:d.nFrogs
         if frogIdx <= dG.nFrogs
            d.y(frogIdx, stimIdx, match) = dG.y(frogIdx, stimIdx, matchG);
         else
            d.y(frogIdx, stimIdx, match) = dT.y(frogIdx-dG.nFrogs, stimIdx, matchT);
         end
      end
   end
end

onlyG = setdiff(dG.users, common);
for idx = 1:numel(onlyG)
   [~, matchG] = ismember(onlyG{idx},dG.users);
   [~, match] = ismember(onlyG{idx}, d.users);
   for stimIdx = 1:d.nStimuli
      for frogIdx = 1:d.nFrogs
         if frogIdx <= dG.nFrogs
            d.y(frogIdx, stimIdx, match) = dG.y(frogIdx, stimIdx, matchG);
         else
            d.y(frogIdx, stimIdx, match) = nan;
         end
      end
   end
end

onlyT = setdiff(dT.users, common);
for idx = 1:numel(onlyT)
   [~, matchT] = ismember(onlyT{idx}, dT.users);
   [~, match] = ismember(onlyT{idx}, d.users);
   for stimIdx = 1:d.nStimuli
      for frogIdx = 1:d.nFrogs
         if frogIdx <= dG.nFrogs
            d.y(frogIdx, stimIdx, match) = nan;
         else
            d.y(frogIdx, stimIdx, match) = dT.y(frogIdx-dG.nFrogs, stimIdx, matchT);
                        if dT.y(frogIdx-dG.nFrogs, stimIdx, matchT) == 2
                           disp('!');
               return
            end
         end
      end
   end
end


% long format
yLong = [];
personLong = [];
stimulusLong = [];
correctLong = [];
frogLong = [];
truthLong = [];
for i = 1:d.nStimuli
   for j = 1:d.nPeople
      for k = 1:d.nFrogs
         if ~isnan(d.y(k, i, j))
            yLong = [yLong d.y(k, i, j)];
            personLong = [personLong j];
            stimulusLong = [stimulusLong i];
            frogLong = [frogLong k];
            correctLong = [correctLong d.y(k, i, j) == d.truth(k, i)];
            truthLong = [truthLong d.truth(k, i)];
         end
      end
   end
end
d.yLong = yLong;
d.personLong = personLong;
d.stimulusLong = stimulusLong;
d.frogLong = frogLong;
d.correctLong = correctLong;
d.truthLong = truthLong;
d.nTrials = length(yLong);

d.personCorrect = nan(d.nPeople, 1);
d.personTotal = nan(d.nPeople, 1);
for j = 1:d.nPeople
   d.personCorrect(j) = sum(d.correctLong(d.personLong == j));
   d.personTotal(j) = sum((d.personLong == j));
end


save([dataDir dataName], 'd', 'dG', 'dT');

return

%% Four Frog Data
dataDir = ('./');
dataName = 'citizenFrogsThree';

T = readtable('firstDataSetRaw/Ingar Matrix 2.xlsx', 'NumHeaderLines', 1);
m = T{:, ExcelColNo('H'):ExcelColNo('XU')};
e = T{:, ExcelColNo('G')};

% one user (column 76) is responsible for all 10 non-binary decisions,
% remove them
%m = m(:, [1:75 77:638]);

d.info = 'citizen and expert detection of three frogs';
d.frogs = T{1:4, ExcelColNo('F')};
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

% just keep frogs that were detected by the expert at least once
howMany = sum(d.truth, 2);
keep = find(howMany > 0);
d.frogs = d.frogs(keep);
d.nFrogs = numel(d.frogs);
d.truth = d.truth(keep, :);
d.y = d.y(keep, :, :);

trim = 220;
d.images = nan(1024-2*trim+1, 1024-2*trim+1, 3, d.nFrogs);
for i = 1:d.nFrogs
  [RGB, ~, ~] = imread(sprintf('images/%s.png', lower(d.frogs{i})));
  d.images(:, :, :, i)  = RGB(trim:(1024-trim), trim:(1024-trim), :);
end

% long format
yLong = [];
personLong = [];
stimulusLong = [];
correctLong = [];
frogLong = [];
truthLong = [];
for i = 1:d.nStimuli
   for j = 1:d.nPeople
      for k = 1:d.nFrogs
         if ~isnan(d.y(k, i, j))
            yLong = [yLong d.y(k, i, j)];
            personLong = [personLong j];
            stimulusLong = [stimulusLong i];
            frogLong = [frogLong k];
            correctLong = [correctLong d.y(k, i, j) == d.truth(k, i)];
            truthLong = [truthLong d.truth(k, i)];
         end
      end
   end
end
d.yLong = yLong;
d.personLong = personLong;
d.stimulusLong = stimulusLong;
d.frogLong = frogLong;
d.correctLong = correctLong;
d.truthLong = truthLong;
d.nTrials = length(yLong);

d.personCorrect = nan(d.nPeople, 1);
d.personTotal = nan(d.nPeople, 1);
for j = 1:d.nPeople
   d.personCorrect(j) = sum(d.correctLong(d.personLong == j));
   d.personTotal(j) = sum((d.personLong == j));
end

save([dataDir dataName], 'd');



%% GBF Data
% this corresponds to Experiment 2 (the "Two Frog Analysis")
% in Thorpe et al because, as they note,
% the expert never identifies the LLJ frog in any trial
dataDir = ('./');
dataName = 'citizenFrogsGBF';

% think LW from 308-313 should be 001100 not 000200
% see fix from 2 to 1 below (and it implicitly assumes one above is
% neither)

% this file is no longer on the OSF
% it seems to match the GBF information in Ingar Matrix 3, with the first column "Olli" as the expert
% except the new file has more judges
% parse this for comparison to published results
T = readtable('firstDataSetRaw/Ingar matrix_Expert.csv', 'NumHeaderLines', 1);
m = T{:, ExcelColNo('D'):ExcelColNo('VR')};
e = T{:, ExcelColNo('C')};

d.info = 'citizen and expert detection of GBF frog';
d.frogs = 'GBF';
d.nFrogs = 1;
d.truth = double(e(1:3:end) == 1); % 1:3:end just indexes GBF
d.y = m(1:3:end, :);
d.y(find(d.y == 2)) = 1;
[d.nStimuli, d.nPeople] = size(d.y);

d.images = imread('images/gbf.png');

% long format
yLong = [];
personLong = [];
stimulusLong = [];
correctLong = [];
for i = 1:d.nStimuli
   for j = 1:d.nPeople
      if ~isnan(d.y(i, j))
         yLong = [yLong d.y(i, j)];
         personLong = [personLong j];
         stimulusLong = [stimulusLong i];
         correctLong = [correctLong double(d.y(i, j) == d.truth(i))];
      end
   end
end
d.yLong = yLong;
d.personLong = personLong;
d.stimulusLong = stimulusLong;
d.correctLong = correctLong;
d.nTrials = length(yLong);

d.personCorrect = nan(d.nPeople, 1);
d.personTotal = nan(d.nPeople, 1);
for j = 1:d.nPeople
   d.personCorrect(j) = sum(d.correctLong(d.personLong == j));
   d.personTotal(j) = sum((d.personLong == j));
end

save([dataDir dataName], 'd');

%% All Frog Data
% this conceptually corresponds to the multiple frogs contexts of Experiment 1
% but with the updated community data
dataDir = ('./');
dataName = 'citizenFrogsAll';

T = readtable('firstDataSetRaw/Ingar Matrix 3 - complete community.xlsx', 'NumHeaderLines', 1);
m = T{:, ExcelColNo('H'):ExcelColNo('XU')};
e = T{:, ExcelColNo('G')};

% one user (column 76) is responsible for all 10 non-binary decisions,
% remove them
m = m(:, [1:75 77:638]);

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

% just keep frogs that were detected by the expert at least once
howMany = sum(d.truth, 2);
keep = find(howMany > 0);
d.frogs = d.frogs(keep);
d.nFrogs = numel(d.frogs);
d.truth = d.truth(keep, :);
d.y = d.y(keep, :, :);

trim = 220;
d.images = nan(1024-2*trim+1, 1024-2*trim+1, 3, d.nFrogs);
for i = 1:d.nFrogs
  [RGB, ~, ~] = imread(sprintf('images/%s.png', lower(d.frogs{i})));
  d.images(:, :, :, i)  = RGB(trim:(1024-trim), trim:(1024-trim), :);
end

% long format
yLong = [];
personLong = [];
stimulusLong = [];
correctLong = [];
frogLong = [];
truthLong = [];
for i = 1:d.nStimuli
   for j = 1:d.nPeople
      for k = 1:d.nFrogs
         if ~isnan(d.y(k, i, j))
            yLong = [yLong d.y(k, i, j)];
            personLong = [personLong j];
            stimulusLong = [stimulusLong i];
            frogLong = [frogLong k];
            correctLong = [correctLong d.y(k, i, j) == d.truth(k, i)];
            truthLong = [truthLong d.truth(k, i)];
         end
      end
   end
end
d.yLong = yLong;
d.personLong = personLong;
d.stimulusLong = stimulusLong;
d.frogLong = frogLong;
d.correctLong = correctLong;
d.truthLong = truthLong;
d.nTrials = length(yLong);

d.personCorrect = nan(d.nPeople, 1);
d.personTotal = nan(d.nPeople, 1);
for j = 1:d.nPeople
   d.personCorrect(j) = sum(d.correctLong(d.personLong == j));
   d.personTotal(j) = sum((d.personLong == j));
end

save([dataDir dataName], 'd');

