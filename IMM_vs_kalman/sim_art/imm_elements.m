%% Decsription of measurement process
C = [I2x2, O2x4];
R = O2x2;			% measurement noise covariance matrix
				% in radar RA coordinates (diagonal)
En = O2x2;			% measurement noise covariance matrix
				% in Cartesian EN coordinates (full)
%% IMM weights and probabilities
Uj = zeros(3,1);
Uij = zeros(3,3);
Lj = zeros(3,1);

%% Ovearall estimate
XnIn = zeros(7,1);		% filtered estimate
PnIn = zeros(7,7);		% filtering error covariance matrix

%% Elements of filter M0 (CV)
X0nIn = zeros(7,1);		% filtered estimate
X0nIn_1 = zeros(7,1);		% predicted estimate
X0Rn_1In_1 = zeros(7,1);	% mixed estimate
P0nIn = zeros(7,7);		% filtering error covariance matrix
P0nIn_1 = zeros(7,7);		% prediction error covariance matrix
P0Rn_1In_1 = zeros(7,7);	% mixed estimate covariance matrix

%% Elements of filter M1 (CA)
X1nIn = zeros(7,1);		% filtered estimate
X1nIn_1 = zeros(7,1);		% predicted estimate
X1Rn_1In_1 = zeros(7,1);	% mixed estimate
P1nIn = zeros(7,7);		% filtering error covariance matrix
P1nIn_1 = zeros(7,7);		% prediction error covariance matrix
P1Rn_1In_1 = zeros(7,7);	% mixed estimate covariance matrix

