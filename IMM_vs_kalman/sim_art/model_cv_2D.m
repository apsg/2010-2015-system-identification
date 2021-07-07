%%
%% Model CV dla wektora stanu x = [x, y, Vx, Vy, Ax, Ay]
%% 

function [XnIn_1, Fn, Bn, Wn, dx] = model_cv_2D(Tn, Xn_1In_1, dx)
	
	const_globals;
	global W_cv;
	
	FABT_SVCV_DIM = 6;
	Wn = W_cv;
	
	%% Modelling of aircraft dynamics during uniform motion (CV model)
	p = Xn_1In_1(1:2);
	v = Xn_1In_1(3:4);
	a = Xn_1In_1(5:6);
	
	%% input matrix
	Bn = [ Tn^2/2*I2x2;  Tn*I2x2; O2x2 ];

	%% state propagation
	XnIn_1 = [ p+Tn*v;  v;  0;  0 ];
	
	%% state transition matrix
	Fn = [ I2x2, Tn*I2x2, O2x2;  O2x2, I2x2, O2x2;  O2x4, I2x2 ];
	
endfunction

