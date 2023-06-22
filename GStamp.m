function G = GStamp(G,VCCS)
% Stamping for VCCS
for i = 1 : size(VCCS, 1)
    nplus = VCCS(i, 1);
    nminus = VCCS(i, 2);
    ncplus = VCCS(i, 3);
    ncminus = VCCS(i, 4);
    gain = VCCS(i, 5);
    if(nplus == 0)
        if ncplus == 0
            G(nminus, ncminus) = G(nminus, ncminus) + gain;
        elseif ncminus == 0
            G(nminus, ncplus) = G(nminus, ncplus) - gain;
        else
            G(nminus, ncminus) = G(nminus, ncminus) + gain;
            G(nminus, ncplus) = G(nminus, ncplus) - gain;
        end
    elseif (nminus == 0)
        if ncplus == 0
            G(nplus, ncminus) = G(nminus, ncminus) - gain;
        elseif ncminus == 0
            G(nplus, ncplus) = G(nminus, ncplus) + gain;
        else
            G(nplus, ncminus) = G(nminus, ncminus) - gain;
            G(nplus, ncplus) = G(nminus, ncplus) + gain;
        end
    else
        if ncplus == 0
            G(nplus, ncminus) = G(nminus, ncminus) - gain;
            G(nminus, ncminus) = G(nminus, ncminus) + gain;
        elseif ncminus == 0
            G(nplus, ncplus) = G(nminus, ncplus) + gain;
            G(nminus, ncplus) = G(nminus, ncplus) - gain;
        else
            G(nplus, ncplus) = G(nminus, ncplus) + gain;
            G(nplus, ncminus) = G(nminus, ncminus) - gain;
            G(nminus, ncplus) = G(nminus, ncplus) - gain;
            G(nminus, ncminus) = G(nminus, ncminus) + gain;
        end
    end
end
end
