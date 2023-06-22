function YC = CStamp(YC, C)
for i = 1 : size(C, 1)
    n1 = C(i, 1);
    n2 = C(i, 2);
    g = C(i, 3);
    if(n1 == 0)
        YC(n2, n2) = YC(n2, n2) + g;
    elseif (n2 == 0)
        YC(n1, n1) = YC(n1, n1) + g;
    else
        YC(n1, n2) = YC(n1, n2) - g;
        YC(n2, n1) = YC(n2, n1) - g;
        YC(n2, n2) = YC(n2, n2) + g;
        YC(n1, n1) = YC(n1, n1) + g;
    end
end
end
