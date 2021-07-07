% Funkcja przeliczajaca pozycjê z ukladu kartezjanskiego do biegunowego (2D)

function [r, az] = en2ra(en)
	
	x = en(1, 1);
	y = en(2, 1);

	r = sqrt(x^2 + y^2);
	
	if x>=0 && y>0,   	% I
		az = atan(x/y);
	elseif y==0 && x>0,  % OX+
		az = pi/2;
	elseif y<0,		% II or III
		az = pi + atan(x/y);
	elseif y==0 && x<0,	% OX-
		az = 3*pi/2;
	elseif x<0 && y>0,	% IV
		az = 2*pi + atan(x/y);
	else
		az = 0;
		printf('Warning: x=%.0f and y=%.0f\n\r', x, y);
    end;
	
	%ra = [r, az];
	
end
