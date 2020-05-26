clear
load library.mat

club = imgaussfilt(uint8(club),1);
club = imbinarize(club);
club = club(2:20,3:21);

diamond = imgaussfilt(uint8(diamond),1);
diamond = imbinarize(diamond);
diamond = diamond(3:19,5:18);

heart = imgaussfilt(uint8(heart),1);
heart = imbinarize(heart);
heart = heart(3:21,5:20);

spade = imgaussfilt(uint8(spade),1);
spade = imbinarize(spade);
spade = spade(3:22,5:18);

ace = imgaussfilt(uint8(ace),1);
ace = imbinarize(ace);
ace = ace(2:28,4:19);

two = imgaussfilt(uint8(two),1);
two = imbinarize(two);
two = two(2:end,4:19);

three = imgaussfilt(uint8(three),1);
three = imbinarize(three);
three = three(2:20,3:20);

four = imgaussfilt(uint8(four),1);
four = imbinarize(four);
four = four(3:28,4:19);

five = imgaussfilt(uint8(five),1);
five = imbinarize(five);
five = five(3:28,4:19);

six = imgaussfilt(uint8(six),1);
six = imbinarize(six);
six = six(2:28,3:19);

seven = imgaussfilt(uint8(seven),1);
seven = imbinarize(seven);
seven = seven(2:27,4:19);

eight = imgaussfilt(uint8(eight),1);
eight = imbinarize(eight);
eight = eight(2:28,3:20);

nine = imgaussfilt(uint8(nine),1);
nine = imbinarize(nine);
nine = nine(1:28,4:19);

ten = imgaussfilt(uint8(ten),1);
ten = imbinarize(ten);
ten = ten(2:28,3:19);

jack = imgaussfilt(uint8(jack),1);
jack = imbinarize(jack);
jack = jack(2:28,4:20);

queen = imgaussfilt(uint8(queen),1);
queen = imbinarize(queen);
queen = queen(2:28,4:20);

king = imgaussfilt(uint8(king),1);
king = imbinarize(king);
king = king(2:27,3:19);

