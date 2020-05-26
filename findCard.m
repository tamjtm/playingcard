function card = findCard(filename)
    img = rgb2gray(imread("Dataset/train/" + filename + ".JPG"));

    %% convert greyscale to binary
    [counts,~] = imhist(img,17);
    T = otsuthresh(counts);
    img_bw = imbinarize(img,T);
    
    %% find card
    [B,~,N,A] = bwboundaries(img_bw); 
%     figure; imshow(img_bw); hold on; 
    % Loop through object boundaries  
    for k = 1:N 
        % Boundary k is the parent of a hole if the k-th column 
        % of the adjacency matrix A contains a non-zero element 
        if (nnz(A(:,k)) > 0) 
            boundary = B{k}; 
%             plot(boundary(:,2),... 
%                 boundary(:,1),'r','LineWidth',2); 
            parent = img(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
            % Loop through the children of boundary k
            n_child = 0;
            for l = find(A(:,k))' 
                boundary = B{l}; 
%                 plot(boundary(:,2),... 
%                     boundary(:,1),'g','LineWidth',2); 
                child = img(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                if size(child) > [5,5]
                   n_child = n_child + 1;
                end
            end 
            if n_child > 1
                card = parent;
            end
        end 
    end
%     hold off;
    
    card = imresize(card,300/max(size(card)));
end