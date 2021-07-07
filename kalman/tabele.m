% tabele
s = RandStream('mcg16807','Seed',0);
RandStream.setDefaultStream(s);

tabela = 5;
model = 'B';
pow = 10;
beta = 1;
disp('-------------------------');
disp(sprintf('tab. %d \t M: %s \t beta: %d', tabela, model, beta));
disp(' ')

switch(tabela)
    % ---------------------------------------------------------------
    case 1
        % tabela 1. 3 x Kalman dla modelu 1 rzędu vs wydrążony / wypełniony
        
        wyniki = [];
        for sv = 0.05:0.05:0.3
            for i=1:pow
                [fi, y, th, svx, sn] = generuj(model, sv, beta);
                
                [th1, eo1, ep1] = kalman_2s_v2(fi, y,  sigmaw(90, svx), svx);
                [th2, eo2, ep2] = kalman_2s_v2(fi, y, sigmaw(30, svx), svx);
                [th3, eo3, ep3] = kalman_2s_v2(fi, y, sigmaw(10, svx), svx);
                
                thw = zeros([size(th),3]);
                thw(:,:,1) = th1;
                thw(:,:,2) = th2;
                thw(:,:,3) = th3;
                
                eo = [eo1';eo2';eo3'];
                ep = [ep1';ep2';ep3'];
                
                thc1 = kalmed(thw, eo, beta);
                thc2 = kalmed(thw, ep, beta);
                
                akt =  [sn, blad(th, th1), blad(th, th2), blad(th, th3), blad(th, thc1), blad(th, thc2)];
                if(i==1)
                    
                    wyniki = [wyniki;akt];
                else
                    wyniki(end,:) = wyniki(end,:) + akt;
                end
            end
        end
        wyswietl(wyniki/pow);
        % ---------------------------------------------------------------
    case 2
        % tabela 2.
        
        
        wyniki = [];
        for sv = 0.05:0.05:0.3
            for i=1:pow
                [fi, y, th, svx, sn] = generuj(model, sv, beta);
                
                [th1, eo1, ep1] = kalman_2s_v2(fi, y,  sigmaw(90, svx), svx);
                [th2, eo2, ep2] = kalman_2s_v2(fi, y, sigmaw(30, svx), svx);
                [th3, eo3, ep3] = kalman_2s_v2(fi, y, sigmaw(10, svx), svx);
                
                [th4, eo4, ep4] = kalman_2r2s(fi, y,  sigmaw2(10, svx), svx);
                [th5, eo5, ep5] = kalman_2r2s(fi, y, sigmaw2(30, svx), svx);
                [th6, eo6, ep6] = kalman_2r2s(fi, y, sigmaw2(90, svx), svx);
                
                thw = zeros([size(th),6]);
                thw(:,:,1) = th1;
                thw(:,:,2) = th2;
                thw(:,:,3) = th3;
                thw(:,:,4) = th4;
                thw(:,:,5) = th5;
                thw(:,:,6) = th6;
                
                eo = [eo1';eo2';eo3';eo4';eo5';eo6'];
                ep = [ep1';ep2';ep3';ep4';ep5';ep6'];
                
                thc1 = kalmed(thw, eo, beta);
                thc2 = kalmed(thw, ep, beta);
                
                akt = [sn, blad(th, th1), blad(th, th2), blad(th, th3), ...
                    blad(th, th4), blad(th, th5), blad(th, th6), ...
                    blad(th, thc1), blad(th, thc2)];
                if(i==1)
                    wyniki = [wyniki; akt];
                else
                    wyniki(end,:) = wyniki(end,:) + akt;
                end
                
            end
        end
        wyswietl(wyniki/pow);
        % ---------------------------------------------------------------
    case 3
        wyniki = [];
        for sv = 0.05:0.05:0.3
            for i=1:pow
                [fi, y, th, svx, sn] = generuj(model, sv, beta);
                
                
                [th1, eo1, ep1] = EWLS(fi, y,  lambda(52));
                [th2, eo2, ep2] = EWLS(fi, y, lambda(18));
                [th3, eo3, ep3] = EWLS(fi, y, lambda(6));
                
                thw = zeros([size(th),3]);
                thw(:,:,1) = th1;
                thw(:,:,2) = th2;
                thw(:,:,3) = th3;
                
                eo = [eo1';eo2';eo3'];
                
                thc1 = kalmed(thw, eo, beta);
                
                
                [th1, eo1] = kalman_2s_v2(fi, y,  sigmaw(90, svx), svx);
                [th2, eo2] = kalman_2s_v2(fi, y, sigmaw(30, svx), svx);
                [th3, eo3] = kalman_2s_v2(fi, y, sigmaw(10, svx), svx);
                
                thw = zeros([size(th),3]);
                thw(:,:,1) = th1;
                thw(:,:,2) = th2;
                thw(:,:,3) = th3;
                
                eo = [eo1';eo2';eo3'];
                
                thc2 = kalmed(thw, eo, beta);
                
                [th4, eo4, ep1] = kalman_2r2s(fi, y,  sigmaw2(10, svx), svx);
                [th5, eo5, ep2] = kalman_2r2s(fi, y, sigmaw2(30, svx), svx);
                [th6, eo6, ep3] = kalman_2r2s(fi, y, sigmaw2(90, svx), svx);
                
                thw = zeros([size(th),6]);
                thw(:,:,1) = th1;
                thw(:,:,2) = th2;
                thw(:,:,3) = th3;
                thw(:,:,4) = th4;
                thw(:,:,5) = th5;
                thw(:,:,6) = th6;
                
                eo = [eo1';eo2';eo3';eo4';eo5';eo6'];
%                 
                thc3 = kalmed(thw, eo, beta);
                 akt = [sn, blad(th, thc1)...
                     , blad(th, thc2), blad(th, thc3)
                     ];
                if(i==1)
                    wyniki = [wyniki; akt];
                else
                    wyniki(end,:) = wyniki(end,:) + akt;
                end
            end
        end
        wyswietl(wyniki/pow);
        
        % ---------------------------------------
        case 4
        % tabela 1. 3 x Kalman dla modelu 1 rzędu vs wydrążony / wypełniony
        beta = 1
        wyniki = [];
        for sv = 0.05:0.05:0.3
            for i=1:pow
                [fi, y, th, svx, sn] = generuj(model, sv, beta);
                
                [th1, eo1, ep1] = kalman_2s_v2(fi, y,  sigmaw(90, svx), svx);
                [th2, eo2, ep2] = kalman_2s_v2(fi, y, sigmaw(30, svx), svx);
                [th3, eo3, ep3] = kalman_2s_v2(fi, y, sigmaw(10, svx), svx);
                
                thw = zeros([size(th),3]);
                thw(:,:,1) = th1;
                thw(:,:,2) = th2;
                thw(:,:,3) = th3;
                
                eo = [eo1';eo2';eo3'];
                
                thc1 = kalmed(thw, eo, beta);
                thc3 = kalmed(thw, eo, 2);
                
                akt =  [sn, blad(th, th1), blad(th, th2), blad(th, th3), blad(th, thc1), blad(th, thc3)];
                if(i==1)
                    
                    wyniki = [wyniki;akt];
                else
                    wyniki(end,:) = wyniki(end,:) + akt;
                end
            end
        end
        wyswietl(wyniki/pow);
        
        
         case 5
        % tabela 2.
        
        
        wyniki = [];
        for sv = 0.05:0.05:0.3
            beta = 1;
            for i=1:pow
                [fi, y, th, svx, sn] = generuj(model, sv, beta);
                
                [th1, eo1, ep1] = kalman_2s_v2(fi, y,  sigmaw(90, svx), svx);
                [th2, eo2, ep2] = kalman_2s_v2(fi, y, sigmaw(30, svx), svx);
                [th3, eo3, ep3] = kalman_2s_v2(fi, y, sigmaw(10, svx), svx);
                
                [th4, eo4, ep4] = kalman_2r2s(fi, y,  sigmaw2(10, svx), svx);
                [th5, eo5, ep5] = kalman_2r2s(fi, y, sigmaw2(30, svx), svx);
                [th6, eo6, ep6] = kalman_2r2s(fi, y, sigmaw2(90, svx), svx);
                
                thw = zeros([size(th),6]);
                thw(:,:,1) = th1;
                thw(:,:,2) = th2;
                thw(:,:,3) = th3;
                thw(:,:,4) = th4;
                thw(:,:,5) = th5;
                thw(:,:,6) = th6;
                
                eo = [eo1';eo2';eo3';eo4';eo5';eo6'];
                 
                thc1 = kalmed(thw, eo, beta);
                thc2 = kalmed(thw, eo,2);
                
                akt = [sn, blad(th, th1), blad(th, th2), blad(th, th3), ...
                    blad(th, th4), blad(th, th5), blad(th, th6), ...
                    blad(th, thc1), blad(th, thc2)];
                if(i==1)
                    wyniki = [wyniki; akt];
                else
                    wyniki(end,:) = wyniki(end,:) + akt;
                end
                
            end
        end
        wyswietl(wyniki/pow);
end