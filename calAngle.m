function deg = calAngle(center,left,right)
    c = pointDistance(left,right);
    a = pointDistance(left,center);
    b = pointDistance(center,right);
    deg = acos( (a^2 + b^2 - c^2)/(2*a*b) ) * 180 * 7 / 22 ;
end

