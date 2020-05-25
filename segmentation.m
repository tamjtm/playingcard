close all;
clear all;

img = rgb2gray(imread("Dataset/train/card_20.JPG"));

% detect card 
[counts,x] = imhist(img,17);
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
hold off;

figure;
cropped = imresize(cropped,300/max(size(cropped)));
imshow(cropped);hold on

% rotate image
[counts,x] = imhist(cropped,16);
T = otsuthresh(counts);
img_bw = imbinarize(cropped,T);
[B,L,N,A] = bwboundaries(img_bw); 
for k = 1:N 
    % Boundary k is the parent of a hole if the k-th column 
    % of the adjacency matrix A contains a non-zero element 
    if (nnz(A(:,k)) > 0) 
        boundary = B{k};
        boundImg = zeros(size(cropped));
        for i = 1:length(boundary(:,1))
            row = boundary(i,1);
            col = boundary(i,2);
            boundImg(row,col) = 1;
        end    
        boundImg = imfill(boundImg,'holes');
        prop = regionprops(boundImg,'Orientation');
        cropped = cropped.*uint8(boundImg);
        break;
    end 
end
disp(prop.Orientation)
if prop.Orientation>=0
    rotateAngle = 90-prop.Orientation;
    rotateImg = imrotate(cropped,rotateAngle);
elseif prop.Orientation<0
    rotateAngle = 90-(180+prop.Orientation);
    rotateImg = imrotate(cropped,rotateAngle);
end        
figure;
imshow(rotateImg);

%crop image
[counts,x] = imhist(rotateImg,16);
T = otsuthresh(counts);
img_bw = imbinarize(rotateImg,T);
[B,L,N,A] = bwboundaries(img_bw); 
for k = 1:N 
    % Boundary k is the parent of a hole if the k-th column 
    % of the adjacency matrix A contains a non-zero element 
    if (nnz(A(:,k)) > 0) 
        boundary = B{k};
        cropped = rotateImg(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
    end 
end
figure;
cropped = imresize(cropped,300/max(size(cropped)));
imshow(cropped);
