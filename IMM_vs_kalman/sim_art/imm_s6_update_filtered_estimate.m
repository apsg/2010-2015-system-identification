function [XnIn, PnIn] = imm_s6_update_filtered_estimate (r, Uj, dx, varargin)

  nargin = nargin - 3;
  k = 1;

  XnIn = zeros(dx,1);
  XJ0nIn = zeros(dx,r);
  for j=1:r,
    XjnIn = varargin{k++};;
    nargin--;
    XnIn = XnIn + Uj(j)*XjnIn;
    XJnIn(:,j) = XjnIn;
  endfor

  PnIn = zeros(dx);
  for j=1:r,
    PinIn = varargin{k++};
    nargin--;
    PnIn = PnIn + ...
	Uj(j)*(PinIn + (XJnIn(:,j) - XnIn)*(XJnIn(:,j) - XnIn)');
  endfor

endfunction
