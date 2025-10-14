%% Group landing

clear;

%% Data
dataDir = ('./');
dataName = 'citizenFrogsGBF';

% think LW from 308-313 should be 001100 not 000200
% see fix from 2 to 1 below (and it implicitly assumes one above is
% neither)

T = readtable('Ingar matrix_Expert.csv', 'NumHeaderLines',1);
m = T{:, ExcelColNo('D'):ExcelColNo('VR')};
e = T{:, ExcelColNo('C')};

d.info = 'citizen and expert detection of GBF frog';
d.truth = double(e(1:3:end) == 1); % 1:3:end just indexes GBF
d.y = m(1:3:end, :);
d.y(find(d.y == 2)) = 1;
[d.nStimuli, d.nPeople] = size(d.y);

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

