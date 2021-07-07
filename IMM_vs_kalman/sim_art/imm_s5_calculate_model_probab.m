function [Uj] = imm_s5_calculate_model_probab (r, Lj, Cj)
	
	Uj = zeros(r,1);

	c = 0;			% normalisation constant
	for j=1:r,
		c = c + Lj(j,1)*Cj(j,1);
	endfor			% i

	c_inv = c^(-1);
% printf("c = %f, c_inv = %f\n", c, c_inv);
	for j=1:r,
		Uj(j,1) = c_inv*Lj(j,1)*Cj(j,1);
% printf("Uj(%d, 1) = %f, Lj(%d, 1) = %f, Cj(%d,1) = %f\n", j, Uj(j,1), j, Lj(j,1),  j, Cj(j,1));
	endfor			% j
	
endfunction

