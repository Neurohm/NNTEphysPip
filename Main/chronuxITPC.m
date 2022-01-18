function [theta,thetaitpc,beta,betaitpc,gamma,gammaitpc] = chronuxITPC(thetaphi,betaphi,gammaphi)

C = permute(thetaphi,[1 3 2]);
C = reshape(C,[],size(thetaphi,2),1);
C1 = permute(betaphi,[1 3 2]);
C1 = reshape(C1,[],size(betaphi,2),1);
C2 = permute(gammaphi,[1 3 2]);
C2 = reshape(C2,[],size(gammaphi,2),1);
for j = 1:size(thetaphi,2) %ITPC for each frequency
    theta{j} = C(:,j);
    thetaitpc(j,1) = abs(mean(exp(1i*theta{j})));
end
for j = 1:size(betaphi,2) %ITPC for each frequency
    beta{j} = C1(:,j);
    betaitpc(j,1) = abs(mean(exp(1i*beta{j})));
end
for j = 1:size(gammaphi,2)
    gamma{j} = C2(:,j);
    gammaitpc(j,1) = abs(mean(exp(1i*gamma{j})));
end
