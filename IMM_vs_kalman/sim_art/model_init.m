
function [X1I1 X2I2 P2I2] = model_init(z1, R1, z2, R2, T1)
	
	const_globals;
	
	%% n = 1
	[p1 E1] = ra2en_msr (z1, R1);
	%% n = 2
	[p2 E2] = ra2en_msr (z2, R2);
	
	X1I1 = zeros(6, 1);
	X2I2 = zeros(6, 1);
	P2I2 = zeros(6, 6);
	
	X2I2(1:2,1) = p2;
	X2I2(3:4,1) = 1/T1*(p2-p1);

	P2I2(1:2,1:2) = E2;
	P2I2(1:2,3:4) = 1/T1*E2;
	P2I2(3:4,1:2) = 1/T1*E2';
	P2I2(3:4,3:4) = 1/T1^2*(E1+E2);
	
	% do sprawdzenia
	%P2I2(3:4,3:4) = 1/T1^2*(E1+E2);
	P2I2(5,5) = eps;
	P2I2(6,6) = eps;
	
    X1I1 = [p1(:);  X2I2(3:6)];
	

