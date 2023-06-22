function B = FStamp(B, F, Vcnt)
for i = 1 : size(F, 1)
    nplus = F(i, 1);
    nminus = F(i, 2);
    gain = F(i, end);
    if (nplus == 0)
        B(nminus, Vcnt) = B(nminus, Vcnt) - gain;
    elseif (nminus == 0)
        B(nplus, Vcnt) = B(nplus, Vcnt) + gain;
    else
        B(nminus, Vcnt) = B(nminus, Vcnt) - gain;
        B(nplus, Vcnt) = B(nplus, Vcnt) + gain;
    end
end
end
