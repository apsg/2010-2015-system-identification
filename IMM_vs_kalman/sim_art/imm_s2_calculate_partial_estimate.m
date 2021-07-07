function [XjRn_1In_1, PjRn_1In_1] = ...
    imm_s2_calculate_partial_estimate (r, j, Uij, dx, varargin)

narg= nargin();
narg = narg - 4;
k = 1;

XjRn_1In_1 = zeros(dx,1);
XIRn_1In_1 = zeros(dx,r);
for i=1:r
    k=k+1;
    Xin_1In_1 = varargin{k};
    narg=narg-1;
    
    %		printf("XjRn_1In_1 = %f, Uij(%d,%d) = %f, Xin_1In_1 = %f\n",
    %		XjRn_1In_1(1), i, j, Uij(i,j), Xin_1In_1(1));
    
    XjRn_1In_1 = XjRn_1In_1 + Uij(i,j)*Xin_1In_1;
    XIRn_1In_1(:,i) = Xin_1In_1;
end

PjRn_1In_1 = zeros(dx);
for i=1:r
    k=k+1;
    Pin_1In_1 = varargin{k};
    narg=narg-1;
    PjRn_1In_1 = PjRn_1In_1 + ...
        Uij(i,j)*(Pin_1In_1 + ...
        (XIRn_1In_1(:,i) - XjRn_1In_1)*(XIRn_1In_1(:,i) - XjRn_1In_1)');
end
