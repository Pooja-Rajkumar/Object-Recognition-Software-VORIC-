addpath('.\provided_code');

load('twoFrameData.mat'); %contains two frames to be used for rawDescriptorMatches.m

oninds = selectRegion(im1, positions1); %list of indices of features within selected region
regionDescriptors = descriptors1(oninds,:); %gets the descriptors within the selected region
dist = dist2(regionDescriptors, descriptors2); %calculates the difference between descriptors in the region compared to every descriptor in second img
[mins, listofmatches] = min(dist,[],2); %gets values and indices of the minimum of each row of the difference (minimum of each row = closest feature)
listofmatches = listofmatches(mins < 0.15); %finds (indices of) matches below a given threshold, 0.15 for best results with fridge

imshow(im2);
displaySIFTPatches(positions2(listofmatches,:), scales2(listofmatches), orients2(listofmatches), im2); %displays sift features for the appropriate matches

