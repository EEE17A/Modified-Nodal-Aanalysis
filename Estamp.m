function [B, C] = Estamp(B, C, E, Vcnt)
for i = 1 : size(E, 1)
    nplus = E(i, 1);
    nminus = E(i, 2);
    if (nplus == 0)
        B(nminus, Vcnt +i) = B(nminus, Vcnt +i) - 1;
    elseif (nminus == 0)
        B(nplus, Vcnt +i) = B(nplus,Vcnt + i) + 1;
    else
        B(nminus,Vcnt + i) = B(nminus, Vcnt +i) - 1;
        B(nplus,Vcnt + i) = B(nplus, Vcnt +i) + 1;
    end
end
C = B';
for i = 1 : size(E, 1)
    ncplus = E(i, 3);
    ncminus = E(i, 4);
    E(i, end)
    if (ncplus == 0)
        C(Vcnt + i, ncminus) = C(Vcnt +i, ncminus) + E(i, end)
    elseif (ncminus == 0)
        C(Vcnt +i, ncplus) = C(Vcnt +i, ncplus) - E(i, end)
    else
        C(Vcnt +i, ncminus) = C(Vcnt +i, ncminus) + E(i, end)
        C(Vcnt +i, ncplus) = C(Vcnt +i, ncplus) - E(i, end)
    end
end
end
