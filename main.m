close all;
clear all;

card_ori = findCard('card_11');

card = preprocessCard(card_ori);

% get top left suit & rank region
topRegion = card(1:85,1:40);

% get bottom right suit & rank region
botRegion = card(end-79:end,end-39:end);
botRegion = flip(botRegion,1);
botRegion = flip(botRegion,2);


[a, b] = calculateProb(topRegion);
[c, d] = calculateProb(botRegion);
topProb = [a, b];
botProb = [c, d];
clear a b c d;

result = identifyCard(topProb, botProb);

figure;
imshow(card); title(result(1) + "-" + result(2));