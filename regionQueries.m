addpath('./');

framesdir = './frames';
siftdir = './sift';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);
fprintf('reading %d total files...\n', length(fnames));

selectedFrame = 100;

fname = [siftdir '/' fnames(selectedFrame).name];
load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
imname = [framesdir '/' imname]; % add the full path

im = imread(imname);
oninds = selectRegion(im,positions);

%regSize = size(oninds, 1);
regDescriptors = descriptors(oninds,:); % get the descriptors for the specific points in our region
load('kMeans.mat');
bagOfWords = zeros(1,1500);
calculatedDist = dist2(regDescriptors,kMeans);
[x,y] = size(regDescriptors);


 for j=1:x
      [rowMin,indx] = min(calculatedDist(j,:));
      bagOfWords(1,indx) = bagOfWords(1,indx) + 1;
 end

normCurrBag = bagOfWords/norm(bagOfWords);  
load('NormBOW.mat');
difference = dist2(normCurrBag,normBOW);  
sortedBagDiff1 = sort(difference); % sort in descending order
minimum = sortedBagDiff1(1:5); % get the five minimum values

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
%plot(positions(:,oninds))
oninds = selectRegion(im,positions);

for t=2:6
   fname = [siftdir '/' fnames(index(t)).name];
   load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
   newPath = [framesdir '/' imname];
   myImage = imread(newPath);
   subplot(2,3,t);
   imshow(myImage)
end 


