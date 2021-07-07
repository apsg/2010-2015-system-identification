% Funkcja przeliczajaca pomiar (pozycja + macierz kowariancji) z ukladu biegunowego do kartezjanskiego (2D)

function [msr_EN, cov_EN] = ra2en_msr(msr_RA, cov_RA)
	
	r = msr_RA(1);
	a = msr_RA(2);
	
	msr_EN = [r*sin(a); r*cos(a)];
	
	G = [
		sin(a)	r*cos(a)	;
		cos(a)	-r*sin(a) ];
	
	cov_EN = G * cov_RA * G';
	
end
