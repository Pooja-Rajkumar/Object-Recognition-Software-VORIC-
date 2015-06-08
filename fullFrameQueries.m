addpath('./');

framesdir = './frames';
siftdir = './sift';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);
 
fprintf('reading %d total files...\n', length(fnames));

load('kMeans.mat');
bagOfWords = zeros(1,1500);
AllBagOfWords = zeros(6612,1500);
 
%  for i=1:length(fnames)
%     fname = [siftdir '/' fnames(i).name];
%     load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
%     diff = dist2(descriptors, kMeans);
%     M = size(descriptors);
%     for j=1:M
%      [rowMin,indx] = min(diff(j,:));
%      bagOfWords(1,indx) = bagOfWords(1,indx) + 1;
%     end
%    AllBagOfWords(i,:) = bagOfWords(1,:);
%    bagOfWords = zeros(1,1500);
%  end
%  
%save('BagOfWords.mat','AllBagOfWords');
load('BagOfWords.mat');
%NORMALIZE EACH ROW OF ALLBAGOFWORDS

selectedFrame = 3000;
normBOW = zeros(6612, 1500);

for i=1:length(fnames)
    % normalize each frame 
   % Q = AllBagOfWords(selectedFrame,:);
    T = AllBagOfWords(i,:); 
    %normBOW(i,:) = dot(T,Q)/sqrt(dot(T,T) * dot(Q,Q));
    normBOW(i,:) = T/norm(T);  
end
save('NormBOW.mat','normBOW');

difference = dist2(normBOW(selectedFrame,:),normBOW);  
sortedBagDiff1 = sort(difference); % sort in descending order
% % 
% % nanCols = find( isnan(sortedBagDiff1) );
% % sortedBagDiff1(nanCols) = [];

minimum = sortedBagDiff1(1:5); % get the five maximum values
index(1) = 0;
[index(2)] = find(difference == minimum(1));
[index(3)] = find(difference == minimum(2));
[index(4)] = find(difference == minimum(3));
[index(5)] = find(difference == minimum(4));
[index(6)] = find(difference == minimum(5));


file = [siftdir '/' fnames(selectedFrame).name];
load(file);
newPath = [framesdir '/' imname];
myImage  = imread(newPath);
subplot(2,3,1)
imshow(myImage)

for t=2:6
   fname = [siftdir '/' fnames(index(t)).name];
   load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
   newPath = [framesdir '/' imname];
   myImage = imread(newPath);
   subplot(2,3,t);
   imshow(myImage)
end
% for j=1:length(fnames)  
%      CurrBag = AllBagOfWords(frames(1),:); 
%      Q = CurrBag;
%      T = AllBagOfWords(j,:);
%      normalizedDiff1(j) = dot(T,Q)/sqrt(dot(T,T)' * dot(Q,Q));
% %      CurrBag = AllBagOfWords(frames(2),:); 
% %      Q = CurrBag;
% %      T = AllBagOfWords(j,:);
% %      normalizedDiff2(j) = dot(T,Q)/sqrt(dot(T,T)' * dot(Q,Q));
% %      
% %      CurrBag = AllBagOfWords(frames(3),:); 
% %      Q = CurrBag;
% %      T = AllBagOfWords(j,:);
% %      normalizedDiff3(j) = dot(T,Q)/sqrt(dot(T,T)' * dot(Q,Q));
% end
% sortedBagDiff1 = sort(normalizedDiff1,'descend');
% sort in descending order
% max = sortedBagDiff1(2:6); % get the five maximum values
% indices = find(normalizedDiff1 >= max(5)); % get th
%e indices of the five maximum values which correspond to the 5 similar frames
% GET THE FIRST 5 MINIMUM VALUES IN NORMALIZEDDIFF1 
% normalizedDiff1 = sort(normalizedDiff1);
% minValues = normalizedDiff1(1:6);
% minIndex = find(