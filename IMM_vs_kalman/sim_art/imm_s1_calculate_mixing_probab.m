function [Uij, Cj] = imm_s1_calculate_mixing_probab (r, Pij, Uj)
%printf("r = %f\n", r);
%Uj
Uij = zeros(r);
Cj = zeros(r,1);

for j=1:r,
    for i=1:r,
        % printf("Cj(%d,1) = %f, Pij(%d,%d) = %f, Uj(%d,1) = %f\n", j, Cj(j,1), i,j, Pij(i,j),i,Uj(i,1));
        Cj(j,1) = Cj(j,1) + Pij(i,j)*Uj(i,1);
    end			%# i
    
    cj_inv = Cj(j,1)^(-1);
    for i=1:r,
        Uij(i,j) = cj_inv*Pij(i,j)*Uj(i,1);
    end %			# i
end	%		# j

