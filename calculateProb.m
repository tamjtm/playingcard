function [rankProb, suitProb] = calculateProb(region)
    load tempSuitAndRank.mat;
    
    %% recognize suit & rank
    [B,~,N,A] = bwboundaries(region); 
    
    rank = [];
    suit = [];
    for k = 1:N 
        if (nnz(A(:,k)) > 0) 
            boundary = B{k};
            if length(find(A(:,k))') == 2
                count = 0;
                for l = find(A(:,k))' 
                    boundary = B{l}; 
                    count = count+1;
                    if count == 1
                        rank = region(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                    else
                        suit = region(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                    end
                end
            elseif length(find(A(:,k))') == 3
                count = 0;
                for l = find(A(:,k))' 
                    boundary = B{l}; 
                    count = count+1;
                    if count == 3
                        rank = ten;
                        suit = region(min(boundary(:,1)):max(boundary(:,1)), min(boundary(:,2)):max(boundary(:,2)));
                    end
                end   
            end
            break;
        end 
    end
    
    %% find rank probability
    rankProb = [];
    %ace
    rankProb(1) = length(find((imresize(rank,[27 16])-ace)==0))/(27*16);
    %two
    rankProb(2) = length(find((imresize(rank,[28 16])-two)==0))/(28*16);
    %three
    rankProb(3) = length(find((imresize(rank,[19 18])-three)==0))/(19*18);
    %four
    rankProb(4) = length(find((imresize(rank,[26 16])-four)==0))/(26*16);
    %five
    rankProb(5) = length(find((imresize(rank,[26 16])-five)==0))/(26*16);
    %six
    rankProb(6) = length(find((imresize(rank,[27 17])-six)==0))/(27*17);
    %seven
    rankProb(7) = length(find((imresize(rank,[26 16])-seven)==0))/(26*16);
    %eight
    rankProb(8) = length(find((imresize(rank,[27 18])-eight)==0))/(27*18);
    %nine
    rankProb(9) = length(find((imresize(rank,[28 16])-nine)==0))/(28*16);
    %ten
    rankProb(10) = length(find((imresize(rank,[27 17])-ten)==0))/(27*17);
    %jack
    rankProb(11) = length(find((imresize(rank,[27 17])-jack)==0))/(27*17);
    %queen
    rankProb(12) = length(find((imresize(rank,[27 17])-queen)==0))/(27*17);
    %king
    rankProb(13) = length(find((imresize(rank,[26 17])-king)==0))/(26*17);
    
    %% find suit probability
    suitProb = [];
    % club
    suitProb(1) = length(find((imresize(suit,[19 19])-club)==0))/(19*19);
    % diamond
    suitProb(2) = length(find((imresize(suit,[17 14])-diamond)==0))/(17*14);
    % heart
    suitProb(3) = length(find((imresize(suit,[19 16])-heart)==0))/(19*16);
    % spade
    suitProb(4) = length(find((imresize(suit,[20 14])-spade)==0))/(20*14);
end