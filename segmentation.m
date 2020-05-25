close all;
clear all;

img = rgb2gray(imread("Dataset/train/card_19.JPG"));

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
        break;
    end 
end
figure;
cropped = imresize(cropped,300/max(size(cropped)));
imshow(cropped);

topRegion = cropped(1:85,1:40);
% figure;
% imshow(topRegion);

botRegion = cropped(end-79:end,end-39:end);
botRegion = flip(botRegion,1);
botRegion = flip(botRegion,2);
% figure;
% imshow(botRegion);

load tempSuitAndRank.mat;
%find location of rank and suit top
[counts,x] = imhist(topRegion,16);
T = otsuthresh(counts);
topRegion_bw = imbinarize(topRegion,T);
[B,L,N,A] = bwboundaries(topRegion_bw); 
figure;
imshow(topRegion_bw);
rank1 = [];
suit1 = [];
for k = 1:N 
    if (nnz(A(:,k)) > 0) 
        boundary = B{k};
        if length(find(A(:,k))') == 2
            count = 0;
            for l = find(A(:,k))' 
                boundary = B{l}; 
                count = count+1;
                if count == 1
                    rank1 = topRegion_bw(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                else
                    suit1 = topRegion_bw(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                end
            end
        elseif length(find(A(:,k))') == 3
            count = 0;
            for l = find(A(:,k))' 
                boundary = B{l}; 
                count = count+1;
                if count == 3
                    rank1 = ten;
                    suit1 = topRegion_bw(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                end
            end   
        end
        break;
    end 
end

%find location of rank and suit bot
[counts,x] = imhist(botRegion,16);
T = otsuthresh(counts);
botRegion_bw = imbinarize(botRegion,T);
[B,L,N,A] = bwboundaries(botRegion_bw); 
figure;
imshow(botRegion_bw);
rank2 = [];
suit2 = [];
for k = 1:N 
    if (nnz(A(:,k)) > 0) 
        boundary = B{k};
        if length(find(A(:,k))') == 2
            count = 0;
            for l = find(A(:,k))' 
                boundary = B{l}; 
                count = count+1;
                if count == 1
                    rank2 = botRegion_bw(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                else
                    suit2 = botRegion_bw(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                end
            end
        elseif length(find(A(:,k))') == 3
            count = 0;
            for l = find(A(:,k))' 
                boundary = B{l}; 
                count = count+1;
                if count == 3
                    rank2 = ten;
                    suit2 = botRegion_bw(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                end
            end   
        end
        break;
    end 
end
% match rank
tempRank1 = [];
%ace
tempRank1(1) = length(find((imresize(rank1,[27 16])-ace)==0))/(27*16);
%two
tempRank1(2) = length(find((imresize(rank1,[28 16])-two)==0))/(28*16);
%three
tempRank1(3) = length(find((imresize(rank1,[19 18])-three)==0))/(19*18);
%four
tempRank1(4) = length(find((imresize(rank1,[26 16])-four)==0))/(26*16);
%five
tempRank1(5) = length(find((imresize(rank1,[26 16])-five)==0))/(26*16);
%six
tempRank1(6) = length(find((imresize(rank1,[27 17])-six)==0))/(27*17);
%seven
tempRank1(7) = length(find((imresize(rank1,[26 16])-seven)==0))/(26*16);
%eight
tempRank1(8) = length(find((imresize(rank1,[27 18])-eight)==0))/(27*18);
%nine
tempRank1(9) = length(find((imresize(rank1,[28 16])-nine)==0))/(28*16);
%ten
tempRank1(10) = length(find((imresize(rank1,[27 17])-ten)==0))/(27*17);
%jack
tempRank1(11) = length(find((imresize(rank1,[27 17])-jack)==0))/(27*17);
%queen
tempRank1(12) = length(find((imresize(rank1,[27 17])-queen)==0))/(27*17);
%king
tempRank1(13) = length(find((imresize(rank1,[26 17])-king)==0))/(26*17);

tempRank2 = [];
%ace
tempRank2(1) = length(find((imresize(rank2,[27 16])-ace)==0))/(27*16);
%two
tempRank2(2) = length(find((imresize(rank2,[28 16])-two)==0))/(28*16);
%three
tempRank2(3) = length(find((imresize(rank2,[19 18])-three)==0))/(19*18);
%four
tempRank2(4) = length(find((imresize(rank2,[26 16])-four)==0))/(26*16);
%five
tempRank2(5) = length(find((imresize(rank2,[26 16])-five)==0))/(26*16);
%six
tempRank2(6) = length(find((imresize(rank2,[27 17])-six)==0))/(27*17);
%seven
tempRank2(7) = length(find((imresize(rank2,[26 16])-seven)==0))/(26*16);
%eight
tempRank2(8) = length(find((imresize(rank2,[27 18])-eight)==0))/(27*18);
%nine
tempRank2(9) = length(find((imresize(rank2,[28 16])-nine)==0))/(28*16);
%ten
tempRank2(10) = length(find((imresize(rank2,[27 17])-ten)==0))/(27*17);
%jack
tempRank2(11) = length(find((imresize(rank2,[27 17])-jack)==0))/(27*17);
%queen
tempRank2(12) = length(find((imresize(rank2,[27 17])-queen)==0))/(27*17);
%king
tempRank2(13) = length(find((imresize(rank2,[26 17])-king)==0))/(26*17);


% match suit
tempSuit1 = [];
% club
tempSuit1(1) = length(find((imresize(suit1,[19 19])-club)==0))/(19*19);
% diamond
tempSuit1(2) = length(find((imresize(suit1,[17 14])-diamond)==0))/(17*14);
% heart
tempSuit1(3) = length(find((imresize(suit1,[19 16])-heart)==0))/(19*16);
% spade
tempSuit1(4) = length(find((imresize(suit1,[20 14])-spade)==0))/(20*14);

tempSuit2 = [];
% club
tempSuit2(1) = length(find((imresize(suit2,[19 19])-club)==0))/(19*19);
% diamond
tempSuit2(2) = length(find((imresize(suit2,[17 14])-diamond)==0))/(17*14);
% heart
tempSuit2(3) = length(find((imresize(suit2,[19 16])-heart)==0))/(19*16);
% spade
tempSuit2(4) = length(find((imresize(suit2,[20 14])-spade)==0))/(20*14);

if max(tempRank1,[],'all')>max(tempRank2,[],'all')
    posRank = find(tempRank1==max(tempRank1,[],'all'));
else
    posRank = find(tempRank2==max(tempRank2,[],'all'));
end

if max(tempSuit1,[],'all')>max(tempSuit2,[],'all')
    posSui = find(tempSuit1==max(tempSuit1,[],'all'));
else
    posSui = find(tempSuit2==max(tempSuit2,[],'all'));
end

if posRank == 1
    disp('ace');
elseif posRank == 2
    disp('two');
elseif posRank == 3
    disp('three');
elseif posRank == 4
    disp('four');
elseif posRank == 5
    disp('five');
elseif posRank == 6
    disp('six');
elseif posRank == 7
    disp('seven');
elseif posRank == 8
    disp('eight');
elseif posRank == 9
    disp('nine');
elseif posRank == 10
    disp('ten');
elseif posRank == 11
    disp('jack');
elseif posRank == 12
    disp('queen');
elseif posRank == 13
    disp('king');
end

if posSui == 1
    disp('club');
elseif posSui == 2
    disp('diamond');
elseif posSui == 3
    disp('heart');
elseif posSui == 4
    disp('spade');
end
