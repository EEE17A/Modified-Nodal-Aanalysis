function [B, C, D] = HStamp(B, D, H, Vcnt)
for i = 1 : size(H, 1)
    nplus = H(i, 1);
    nminus = H(i, 2);
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
for i = 1 : size(H, 1)
    D(Vcnt + i, H(i, 3)) = D(Vcnt + i, H(i, 3)) - H(i, end);
end
end
