function output = preprocessCard(card)
    %% rotate card
    [counts,~] = imhist(card,16);
    T = otsuthresh(counts);
    card_bw = imbinarize(card,T);
    
    [B,~,N,A] = bwboundaries(card_bw);
    for k = 1:N 
        % Boundary k is the parent of a hole if the k-th column 
        % of the adjacency matrix A contains a non-zero element 
        if (nnz(A(:,k)) > 0) 
            boundary = B{k};
            boundImg = zeros(size(card));
            for i = 1:length(boundary(:,1))
                row = boundary(i,1);
                col = boundary(i,2);
                boundImg(row,col) = 1;
            end    
            boundImg = imfill(boundImg,'holes');
            prop = regionprops(boundImg,'Orientation');
            card = card.*uint8(boundImg);
            break;
        end 
    end
    
    if prop.Orientation>=0
        rotateAngle = 90-prop.Orientation;
        rotated = imrotate(card_bw, rotateAngle);
    elseif prop.Orientation<0
        rotateAngle = 90-(180+prop.Orientation);
        rotated = imrotate(card_bw, rotateAngle);
    end  
    
    %% crop rotated card
%     [counts,x] = imhist(rotateImg,16);
%     T = otsuthresh(counts);
%     img_bw = imbinarize(rotateImg,T);
    [B,~,N,A] = bwboundaries(rotated); 
    for k = 1:N 
        % Boundary k is the parent of a hole if the k-th column 
        % of the adjacency matrix A contains a non-zero element 
        if (nnz(A(:,k)) > 0) 
            boundary = B{k};
            cropped = rotated(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
            break;
        end 
    end
    
    output = imresize(cropped, 300/max(size(cropped)));
end