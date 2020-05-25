close all;
clear all;

img = rgb2gray(imread("Dataset/train/card_19.JPG"));
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
        tempBound = boundary;
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
            actBound = tempBound;
            topRow = min(actBound(:,1));
            topCol = min(actBound( find(actBound(:,1)==topRow, 1 ) : find(actBound(:,1)==topRow, 1, 'last' ) ,2));
            botRow = max(actBound(:,1));
            botCol = max(actBound( find(actBound(:,1)==botRow, 1 ) : find(actBound(:,1)==botRow, 1, 'last' ) ,2));
            leftCol = min(actBound(:,2));
            leftRow = max(actBound( find(actBound(:,2)==leftCol, 1 ) : find(actBound(:,2)==leftCol, 1, 'last' ) ,1));
            rightCol = max(actBound(:,2));
            rightRow = min(actBound( find(actBound(:,2)==rightCol, 1 ) : find(actBound(:,2)==rightCol, 1, 'last' ) ,1));
            cropped = temp1;
        end
    end 
end
figure;
cropped = imresize(cropped,300/max(size(cropped)));
imshow(cropped);

[counts,x] = imhist(cropped,16);
T = otsuthresh(counts);
img_bw = imbinarize(cropped,T);

[B,L,N,A] = bwboundaries(img_bw); 
for k = 1:N 
    % Boundary k is the parent of a hole if the k-th column 
    % of the adjacency matrix A contains a non-zero element 
    if (nnz(A(:,k)) > 0) 
        actBound = B{k};
        topRow = min(actBound(:,1));
        topCol = min(actBound( find(actBound(:,1)==topRow, 1 ) : find(actBound(:,1)==topRow, 1, 'last' ) ,2));
        botRow = max(actBound(:,1));
        botCol = max(actBound( find(actBound(:,1)==botRow, 1 ) : find(actBound(:,1)==botRow, 1, 'last' ) ,2));
        leftCol = min(actBound(:,2));
        leftRow = max(actBound( find(actBound(:,2)==leftCol, 1 ) : find(actBound(:,2)==leftCol, 1, 'last' ) ,1));
        rightCol = max(actBound(:,2));
        rightRow = min(actBound( find(actBound(:,2)==rightCol, 1 ) : find(actBound(:,2)==rightCol, 1, 'last' ) ,1));
        degTop = calAngle( [topCol topRow] , [leftCol leftRow] , [rightCol rightRow]  ); 
        degBot = calAngle( [botCol botRow] , [rightCol rightRow] , [leftCol leftRow] ); 
        degLeft = calAngle( [leftCol leftRow] , [botCol botRow] , [topCol topRow]  ); 
        degRight = calAngle( [rightCol rightRow] , [topCol topRow] , [botCol botRow] ); 
        break;
    end 
end
figure;
imshow(edge(cropped,'canny'));
% imhist(img);
