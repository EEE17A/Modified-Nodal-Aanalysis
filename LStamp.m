function YL = LStamp(YL, L)
for i = 1 : size(L, 1)
    n1 = L(i, 1);
    n2 = L(i, 2);
    g = 1/L(i, 3);
    if(n1 == 0)
        YL(n2, n2) = YL(n2, n2) + g;
    elseif (n2 == 0)
        YL(n1, n1) = YL(n1, n1) + g;
    else
        YL(n1, n2) = YL(n1, n2) - g;
        YL(n2, n1) = YL(n2, n1) - g;
        YL(n2, n2) = YL(n2, n2) + g;
        YL(n1, n1) = YL(n1, n1) + g;
    end
end
end
