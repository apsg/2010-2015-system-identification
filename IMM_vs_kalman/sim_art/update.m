function [XnIn, PnIn, Lambda] = update(dx, dy, XnIn_1, PnIn_1, C, Yc, omega, Rn)
	
	Odyx1 = zeros(dy,1);
	
	v = Yc - C*XnIn_1;  % d = y - C*XtIt_1
	Lambda = normal_md_pdf (v, Odyx1, omega);
	
	L = PnIn_1*C' * inv(omega);
	K = eye(dx) - L*C;
	XnIn = XnIn_1 + L*v;
	
	PnIn = K*PnIn_1*K' + L*Rn*L'; % Joseph's stabilised recursion
	%PnIn = K*PnIn_1;
	
endfunction
