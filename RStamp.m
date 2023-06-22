function G = RStamp(G, R)
for i = 1 : size(R, 1)
    n1 = R(i, 1);
    n2 = R(i, 2);
    g = 1/R(i, 3);
    if(n1 == 0)
        G(n2, n2) = G(n2, n2) + g;
    elseif (n2 == 0)
        G(n1, n1) = G(n1, n1) + g;
    else
        G(n1, n2) = G(n1, n2) - g;
        G(n2, n1) = G(n2, n1) - g;
        G(n2, n2) = G(n2, n2) + g;
        G(n1, n1) = G(n1, n1) + g;
    end
end
end
