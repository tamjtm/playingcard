close all;
clear all;

img = rgb2gray(imread("Dataset/train/card_51.JPG"));
[counts,x] = imhist(img,16);
T = otsuthresh(counts);
img_bw = imbinarize(img,T);

[B,L,N,A] = bwboundaries(img_bw); 
figure; imshow(img_bw); hold on; 
% Loop through object boundaries  
for k = 1:N 
    % Boundary k is the parent of a hole if the k-th column 
    % of the adjacency matrix A contains a non-zero element 
    if (nnz(A(:,k)) > 0) 
        boundary = B{k}; 
        plot(boundary(:,2),... 
            boundary(:,1),'r','LineWidth',2); 
        temp1 = img(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
        % Loop through the children of boundary k
        count = 0;
        object = {};
        point = {};
        for l = find(A(:,k))' 
            boundary = B{l}; 
            plot(boundary(:,2),... 
                boundary(:,1),'g','LineWidth',2); 
            temp2 = img(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
            if size(temp2) > [5,5]
                object{count+1} = temp2;
                point{count+1} = boundary;
                count = count + 1;
            end
        end 
        if count>1
            parent = temp1;
            child1 = object;
            child2 = point;
        end
    end 
end
figure;
imshow(parent);

distances = {};
for i = 1:length(child1)
    thisBoundary = child1{i}; % Or whatever blob you want.
    x = double(thisBoundary(:,1));
    y = double(thisBoundary(:,2));
    [c1, c2] = ndgrid(1:size(child2{i}, 1), 1:size(child2{i}, 2));
    centroid = mean([c2(logical(child2{i})), c1(logical(child2{i}))]);
    distances{i} = sqrt((x - centroid(2)).^2 + (y - centroid(1)).^2);
    distances{i} = distances{i}/max(distances{i});
    figure;
    subplot(1,2,1); plot(linspace(0,360,length(distances{i})), distances{i});
    subplot(1,2,2); imshow(uint8(child1{i}));
end