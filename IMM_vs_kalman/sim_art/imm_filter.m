%% Function
%%
%%      [XY_est] = imm_filter (RAE_msr, XY_real, filtconf, verbose)
%%

function [XY_est, model_probab] = imm_filter (RAE_msr, XY_real, filtconf, verbose)
	
	const_init;
	const_globals;
	imm_elements;
	% filter_constants;
	% radar_constants;
	% imm3_elements;
	eval(filtconf);
	
	%init zmiennych danych wyjsciowych	
	XY_est = zeros(7, size(RAE_msr,2));
	model_probab = zeros(3, size(RAE_msr,2));
	
	%init czasu
	Tn = 0;
	n = 0;
	
	%% Filter initiation (assuming straight-line movement) 
	%% based on 1st & 2nd samples.
	[t1 z1 R1] = getplot_2D (RAE_msr, 1);
	[t2 z2 R2] = getplot_2D (RAE_msr, 2);
	[X1I1 X2I2 P2I2] = model_init(z1, R1, z2, R2, t2 - t1);
	chol(P2I2);
	
%init rzeczywistymi danymi - zeby nie czekac na stabilizacje filtru
% X1I1 = [ XY_real(1:4,1); 0; 0 ];
% X2I2 = [ XY_real(1:4,2); 0; 0 ];
	
	%zapis danych dla n = 1 i 2
	XY_est(:,1) = [ X1I1; t1 ];
	XY_est(:,2) = [ X2I2; t2 ];
	
	%init wartosci dla filtru IMM
	X0nIn = X2I2;
	X1nIn = X2I2;
	X2nIn = X2I2;
	
	P0nIn = P2I2;
	P1nIn = P2I2;
	P2nIn = P2I2;
	
	model_probab(:,1) = [0; Uj0];
	model_probab(:,2) = [0; Uj0];
	
	Uj = Uj0;
	tn_1 = t2;
	
	%% Start of the estimation process - from 3-rd sample.
	n = 2;
	while n<size(RAE_msr,2),
		%% New iteration of the algorithm.
		n=n+1;

		%% IMM reinitialisation
		%% ===================================
		[Uij, Cj] = imm_s1_calculate_mixing_probab (2, Pij, Uj);
		[X0RnIn, P0RnIn] = ...
			imm_s2_calculate_partial_estimate (2, 1, Uij, FABT_SVCV_DIM, X0nIn, X1nIn, P0nIn, P1nIn);
		[X1RnIn, P1RnIn] = ...
			imm_s2_calculate_partial_estimate (2, 2, Uij, FABT_SVCA_DIM, X0nIn, X1nIn, P0nIn, P1nIn);

		%% Model-matched filtering
		%% ===================================
		%% Unpacking of measurements
		[tn, zn, Rn, dy] = getplot_2D(RAE_msr, n);
		[yn, En] = ra2en_msr(zn, Rn);
		Tn = tn - tn_1;

		%% State prediction(KF)
		[X0nIn_1, Fn, Bn, W, dx] = model_cv_2D (Tn, X0RnIn, FABT_SVCV_DIM);
		P0nIn_1 = Fn*P0RnIn*Fn' + Bn*W_cv*Bn';
		[X1nIn_1, Fn, Bn, W, dx] = model_ca_2D (Tn, X1RnIn, FABT_SVCA_DIM);
		P1nIn_1 = Fn*P1RnIn*Fn' + Bn*W_ca*Bn';

		%% Partial filters update (KF)
		w0n = C*P0nIn_1*C' + En;
		[X0nIn, P0nIn, Lj(1)] = update(FABT_SVCV_DIM, dy, X0nIn_1, P0nIn_1, C, yn, w0n, En);
		w1n = C*P1nIn_1*C' + En;
		[X1nIn, P1nIn, Lj(2)] = update(FABT_SVCA_DIM, dy, X1nIn_1, P1nIn_1, C, yn, w1n, En);


		%% IMM overall state estimate update
		%% ===================================
		[Uj] = imm_s5_calculate_model_probab (2, Lj, Cj);

		model_probab(:,n) = [tn; Uj];

		[XnIn, PnIn] = imm_s6_update_filtered_estimate (2, Uj, dx, X0nIn, X1nIn, P0nIn, P1nIn);

		XY_est(:,n) = [ XnIn; tn ];

		tn_1 = tn;
	
    end

end
