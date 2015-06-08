addpath('./');

framesdir = './frames';
siftdir = './sift';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

fprintf('reading %d total files...\n', length(fnames));
allDescriptors = [];
allPositions = [];
allScales = [];
allOrients = [];
% for i=1:length(fnames)
% 
%     fprintf('reading frame %d of %d\n', i, length(fnames));
%     
%     load that file
%     fname = [siftdir '/' fnames(i).name];
%     load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
%     numfeats = size(descriptors,1);
%   
%     if(numfeats > 0)
%     get the SIFT descriptors 
%            randval = min(25, numfeats);
%            descriptorInx = randperm(numfeats,randval);
%            allDescriptors = [allDescriptors; descriptors(descriptorInx,:)];
%            allPositions = [allPositions; positions(descriptorInx,:)];
%            allScales = [allScales; scales(descriptorInx,:)];
%            allOrients = [allOrients; orients(descriptorInx,:)];
%           allImNames = [allImNames; fnames(x).name];
%            
%            
%             randomly sample from each  
% 
%     read in the associated image
%     imname = [framesdir '/' imname]; % add the full path
%     im = imread(imname);
%     end
% end
load('banana.mat');
framesdir = './frames';
load('kMeans.mat');
%k = 1500;
%[idx,centers] = kmeansML(k,allDescriptors');
%kMeans = centers'
%save('kMeans.mat', 'kMeans');
word = 1500;
count = 0;
quitThis = 0;
figure;
for j=1:length(fnames)
     fname = [siftdir '/' fnames(j).name];
     load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    for k=1:size(descriptors,1)
        distList = dist2(descriptors(k,:),kMeans);
        [currCluster,myWord] = min(distList);
        if(myWord == word)
            if (count >= 25)
                quitThis = 1;
                break;
            end
            count = count +1;
  
            newPath = [framesdir '/' imname];
            im = imread(newPath);
            imGray = rgb2gray(im);
            subplot(5,5,count);
            imshow(getPatchFromSIFTParameters(positions(k,:),scales(k,:),orients(k,:), imGray));
        end
    end
     if(quitThis == 1)
        break;
     end
     
  
end
% 