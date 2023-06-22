function [B, C, e] = VStamp(B, C, e, V)
for i = 1 : size(V, 1)
    nplus = V(i, 1);
    nminus = V(i, 2);
    if (nplus == 0)
        B(nminus, i) = B(nminus, i) - 1;
    elseif (nminus == 0)
        B(nplus, i) = B(nplus, i) + 1;
    else
        B(nminus, i) = B(nminus, i) - 1;
        B(nplus, i) = B(nplus, i) + 1;
    end
end
C = B';
for j = 1 : size(V, 1)
    e(j) = V(j, 3);
end
end
