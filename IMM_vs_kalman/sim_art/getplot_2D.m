function [tn zn Rn dz] = getplot_2D (RAE_msr, n)

  tn = RAE_msr(1,n);
  zn = RAE_msr(2:3,n);
  Rn = diag(RAE_msr(4:5,n).^2);
  dz = 2;
  
