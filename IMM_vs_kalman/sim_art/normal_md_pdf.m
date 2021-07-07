function [pdf] = normal_md_pdf (x, mx, Cx)
% x
% mx
% Cx
% det_Cx = det(Cx)
% inv_Cx = Cx^(-1)

	if isvector(x) && isvector(mx) && issquare(Cx) &&  ...
	(size(x,1)==size(Cx,1) || size(x,2)==size(Cx,1)) && ...
	(size(mx,1)==size(Cx,1) || size(mx,2)==size(Cx,1)),
	
		dx = size(Cx,1);
		x = reshape (x,dx,1);
		mx = reshape (mx,dx,1);
% printf("reshape...\n");
% x
% mx
% t1 = (2*pi)^(-dx/2)*det(Cx)^(-1/2)
% t2 = exp(-0.5*[(x-mx)'*Cx^(-1)*(x-mx)])
% t3 = (x-mx)'*Cx^(-1)*(x-mx)

		pdf = (2*pi)^(-dx/2)*det(Cx)^(-1/2)*exp(-0.5*[(x-mx)'*Cx^(-1)*(x-mx)]);
		
if pdf == 0,
	printf("WARNING: pdf = 0 (assigning 'eps')\n");
	pdf = eps;
endif
		
	else
		disp("Error: Sizes of arguments do not match!");
	endif

endfunction
