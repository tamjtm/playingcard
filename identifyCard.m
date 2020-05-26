function result = identifyCard(regionProb_t, regionProb_b)
    result = {};
    
    rank1 = regionProb_t(1:13);
    suit1 = regionProb_t(14:17);
    rank2 = regionProb_b(1:13);
    suit2 = regionProb_b(14:17);
    
    % rank probability comparison
    if max(rank1,[],'all') > max(rank2,[],'all')
        posRank = find(rank1==max(rank1,[],'all'));
    else
        posRank = find(rank2==max(rank2,[],'all'));
    end
    
    % assign rank
    if posRank == 1
        result = ["A"];
    elseif posRank == 2
        result = ["2"];
    elseif posRank == 3
        result = ["3"];
    elseif posRank == 4
        result = ["4"];
    elseif posRank == 5
        result = ["5"];
    elseif posRank == 6
        result = ["6"];
    elseif posRank == 7
        result = ["7"];
    elseif posRank == 8
        result = ["8"];
    elseif posRank == 9
        result = ["9"];
    elseif posRank == 10
        result = ["10"];
    elseif posRank == 11
        result = ["J"];
    elseif posRank == 12
        result = ["Q"];
    elseif posRank == 13
        result = ["K"];
    end
    
    % suit probability comparison
    if max(suit1,[],'all') > max(suit2,[],'all')
        posSui = find(suit1==max(suit1,[],'all'));
    else
        posSui = find(suit2==max(suit2,[],'all'));
    end
    
    % assign suit
    if posSui == 1
        result = [result, "Club ♣"];
    elseif posSui == 2
        result = [result, "Diamond ♦"];
    elseif posSui == 3
        result = [result, "Heart ♥"];
    elseif posSui == 4
        result = [result, "Spade ♠"];
    end
end