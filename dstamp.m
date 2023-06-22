function [G, i] = dstamp(G, i , d, G_eq, I_eq)
 
for p = 1 : size(d, 1)
 np = d(p, 1);
 nn = d(p, 2);
 g = G_eq(p);
 if(np == 0)
 G(nn, nn) = G(nn, nn) + g;
 elseif (nn == 0)
 G(np, np) = G(np, np) + g;
 else
 G(np, nn) = G(np, nn) - g;
 G(nn, np) = G(nn, np) - g;
 G(nn, nn) = G(nn, nn) + g;
 G(np, np) = G(np, np) + g;
 end
end
for k = 1 : size(i, 1)
 for j = 1 : size(d, 1)
 if d(j, 1) == k
 i(k) = i(k) - I_eq(j);
 elseif d(j, 2) == k
 i(k) = i(k) + I_eq(j);
 end
 end
end
end