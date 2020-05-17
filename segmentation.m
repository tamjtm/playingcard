close all;
clear all;

img = rgb2gray(imread("card_51.JPG"));
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
        for l = find(A(:,k))' 
            boundary = B{l}; 
            plot(boundary(:,2),... 
                boundary(:,1),'g','LineWidth',2); 
            temp2 = img(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
            if size(temp2) > [5,5]
               count = count + 1;
            end
        end 
        if count>1
            cropped = temp1;
        end
    end 
end
figure;
imshow(cropped);
% imhist(img);