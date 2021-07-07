% CFG

FABT_SV_COORD = 'ENCV';

global W_cv;
W_cv= 0.25*eye(2);
global W_ca; 
W_ca = 9*eye(2);

FABT_SVCV_DIM = 6;
FABT_SVCA_DIM = 6;

Pij = [0.95 0.05;
       0.1 0.9 ];

Uj0 = [0.9;
       0.1];
