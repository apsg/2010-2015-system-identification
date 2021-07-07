clear all;
clc;
%clf;

all_in_one = 0;
ile_monte_carlo = 50;

% skladowe rzeczywistego wektora stanu (symulacja)
px = 1;	%pos x
py = 2;	%pos y
vx = 3;	%velocity x
vy = 4;	%velocity y
tt = 5;	%track time

% stale
g = 10;		%przyspieszenie ziemskie
dt = 1;	%okres probkowania
sim_time = 50;	%czas symulacji

range_error = 15;
azim_error = 0.002;
RA_cov = [ range_error^2 0; 0 azim_error^2];	% macierz kowariancji szumu pomiarowego we wsp. biegunowych systemowa dla CV (stala)
A_cv = [ 1  0 dt  0;
         0  1  0 dt;
         0  0  1  0;
         0  0  0  1];

% warunki poczatkowe
x = [29500; 35000; -250; -210];
track = [x; 0];

%parametry dynamiczne
sterowanie = zeros(size(dt:dt:sim_time));
sterowanie(floor(10/dt):floor(22/dt)) = -3*g;
sterowanie(floor(26/dt):floor(38/dt)) =  3*g;

n = 1;

for t = dt:dt:sim_time %startujemy od t=0+dt, bo t=0 to znane warunki poczatkowe
	
	% ewolucja stanu
	
	if(sterowanie(n) == 0) %Constant Velocity
		
		nx = A_cv*x;
		
	else	% Controlled Coordinated Turn
		
		a_dosrodkowe = sterowanie(n);
		
		%modyfikacje wektora stanu (przyspieszenie normalne/dosrodkowe)
		v2 = x(vx)^2+x(vy)^2;
		v = sqrt(v2);
		w = a_dosrodkowe/v;
		
		nx(px) = x(px) + x(vx)*sin(w*dt)/w     + x(vy)*(1-cos(w*dt))/w;
		nx(py) = x(py) + x(vx)*(cos(w*dt)-1)/w + x(vy)*sin(w*dt)/w;
		nx(vx) = x(vx)* cos(w*dt) + x(vy)*sin(w*dt);
		nx(vy) = x(vx)*-sin(w*dt) + x(vy)*cos(w*dt);
		
    end;
	
	% aktualizacja wektora stanu
	x = nx;
	
	% zapisanie wartosci
	track = [track, [x; t]];
	
	n = n + 1;
	
end;

% wykres polozenia X-Y
figure(1); clf;
plot(track(px,:), track(py,:), 'k-');
xlabel('X coordinate [m]');
ylabel('Y coordinate [m]');
grid on;

% wykres polozenia X(t), Y(t)
figure(2); clf;
subplot(2, 2, 1);
hold on;
plot(track(tt,:), track(px,:), 'b-');
plot(track(tt,:), track(py,:), 'r--');
xlabel('Time [s]');
ylabel('Position [m]');
legend('X position', 'Y position');
grid on;

% wykres predkosci X i Y
figure(2); %clf;
subplot(2, 2, 2);
hold on;
plot(0:dt:sim_time, track(vx,:), 'b');
plot(0:dt:sim_time, track(vy,:), 'r--');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
legend('X velocity', 'Y velocity');
grid on;
hold off;

% wyliczanie przyspieszen X, Y i modulu
sim_len = size(track, 2);
ax = zeros(sim_len); ay = zeros(sim_len); am = zeros(sim_len);
for k = 2:sim_len
	ax(k) = (track(vx, k) - track(vx, k-1))/dt;
	ay(k) = (track(vy, k) - track(vy, k-1))/dt;
	am(k) = sqrt(ax(k)^2 + ay(k)^2);
end;

% wykres przyspieszenia X i Y
%figure(3); clf;
subplot(2, 2, 3);
hold on;
plot(0:dt:sim_time, ax, 'b');
plot(0:dt:sim_time, ay, 'r--');
xlabel('Time [s]');
ylabel('Acceleration [m/s/s]');
legend('X acceleration', 'Y acceleration');
grid on
hold off;

% wykres modulu przyspieszenia
%figure(4); clf;
subplot(2, 2, 4);
hold on;
plot(0:dt:sim_time, am, 'b');
xlabel('Time [s]');
ylabel('Magnitude of acceleration [m/s/s]');
grid on
hold off;

% Monte Carlo
randn('seed', 123);
rmse = zeros(10, sim_len);
sprintf('Monte Carlo (%d iteracji): ', ile_monte_carlo);
for mc = 1:ile_monte_carlo
	
	% symulacja pomiarow radarowych (kowersja i zaszumianie)
	for k = 1:size(track, 2)
		
		% konwersja z EN (tak sa generowane dane) do RA oraz zaszumianie
		[r, fi] = en2ra(track(:, k));
		r_msr = r + normrnd(0, range_error);
		fi_msr = fi + normrnd(0, azim_error);
		
		% wypelnienie wektora danych pomiarowych (dla filtracji IMM)
		% pozycje w wektorze takie a nie inne ze wzgl�du na konstrukcj� algorytmu IMM
		RAE_msr(1, k) = track(tt, k); % czas
		RAE_msr(2, k) = r_msr;
		RAE_msr(3, k) = fi_msr;
		RAE_msr(4, k) = range_error;
		RAE_msr(5, k) = azim_error;
		
		if mc == 1,
			% konwersja zaszumionych danych "pomiarowych" z powrotem do EN (do wykresu);
			% tej samej funkcji mozna uzyc przy konwersji pomiaru i macierzy kowariancji
			% przed ich wykorzystaniem w filtracji, np. robiac tak:
			% [EN_msr, EN_cov] = ra2en_msr(RAE_msr(2:3, k), RA_cov);
			% w EN_msr i EN_cov mamy od razu pomiar i macierz kowariancji w ukladzie kartezjanskim
			EN_msr(:, k) = ra2en_msr(RAE_msr(2:3, k), RA_cov);
		end;
		
	end;
	
	%======== FILTRACJA IMM =========
	% [XY_est,  model_probab] = imm3_filter (RAE_msr, XY_real, filtconf, verbose)
	% XY_real - do inicjacji sledzenia prawdziwymi danymi
	[XY_est, model_probab] = imm_filter(RAE_msr, track, 'cfg', 1);
	
	% wyswietlanie wykresow z 1. zestawu danych
	if mc == 1,
		% wykres danych pomiarowych X-Y
		figure(1); %clf;
		%subplot(3, 2, 5);
		hold on;
		% plot(EN_msr(1, :), EN_msr(2,:), 'r-');
		% xlabel('Measurement X [m]');
		% ylabel('Measurement Y [m]');
		grid on
		hold off;
		
		% wykres danych przefiltrowanych X-Y
		figure(1); %clf;
		%subplot(3, 2, 6);
		hold on;
		plot(XY_est(1, :), XY_est(2,:), 'r');
		% xlabel('Estimate X [m]');
		% ylabel('Estimate Y [m]');
		hold off;

		% wykres prawdopodobienstw modeli
		figure(3); clf;
		%subplot(3, 2, 6);
		hold on; grid on;
		plot(model_probab(1, :), model_probab(2,:), 'b-');
		plot(model_probab(1, :), model_probab(3,:), 'r--');
		xlabel('Time [s]');
		ylabel('Model Probability');
		legend('CV', 'CA');
		hold off;
	end;
	
	% RMSE
	est_len = size(XY_est, 2);
	ax_est = zeros(est_len); ay_est = zeros(est_len); am_est = zeros(est_len);
	for k = 2:est_len
		ax_est(k) = (XY_est(3, k) - XY_est(3, k-1))/dt;
		ay_est(k) = (XY_est(4, k) - XY_est(4, k-1))/dt;
		am_est(k) = sqrt(ax_est(k)^2 + ay_est(k)^2);
	end;
	
	%najpierw sumujemy, pozniej sie tylko podzieli
	for k = 1:est_len
		ex  = XY_est(1, k) - track(px, k);
		ey  = XY_est(2, k) - track(py, k);
		evx = XY_est(3, k) - track(vx, k);
		evy = XY_est(4, k) - track(vy, k);
		
		rmse(1, k) = rmse(1, k) +  ex^2;	%polozenie x
		rmse(2, k) = rmse(2, k) +  ey^2;	%polozenie y
		rmse(3, k) = rmse(3, k) +  evx^2;	%predkosc x
		rmse(4, k) = rmse(4, k) +  evy^2;	%predkosc y
		rmse(5, k)  = rmse(5, k) +  (ax_est(k) - ax(k))^2;	%przyspieszenie x
		rmse(6, k)  = rmse(6, k) +  (ay_est(k) - ay(k))^2;	%przyspieszenie y
		rmse(7, k)  = rmse(7, k) +  sqrt(ex^2  + ey^2)^2;	%modul polozenia
		rmse(8, k)  = rmse(8, k) +  sqrt(evx^2 + evy^2)^2;	%modul predkosci
		rmse(9, k)  = rmse(9, k) +  sqrt((ax_est(k) - ax(k))^2 + (ay_est(k) - ay(k))^2)^2;	%modul przyspieszenia
		rmse(10, k) = track(tt, k);		%czas
	end;
	
	printf('%d, ', mc);
end;
printf('\n');

rmse(1:9, :) = rmse(1:9, :)./ile_monte_carlo;
rmse(1:9, :) = rmse(1:9, :).^(0.5);

% RMSE pozycja
figure(4); clf;
hold on; grid on;
plot(rmse(10, :), rmse(1, :), 'b-');
plot(rmse(10, :), rmse(2, :), 'r--');
plot(rmse(10, :), rmse(7, :), 'k-');
xlabel('Time [s]');
ylabel('RMSE in position [m]');
% legend('X', 'Y');
hold off;

% RMSE predkosc
figure(5); clf;
hold on; grid on;
plot(rmse(10, :), rmse(3, :), 'b-');
plot(rmse(10, :), rmse(4, :), 'r--');
plot(rmse(10, :), rmse(8, :), 'k-');
xlabel('Time [s]');
ylabel('RMSE in velocity [m/s]');
% legend('X', 'Y');
hold off;

% RMSE przyspieszenie
figure(6); clf;
hold on; grid on;
plot(rmse(10, :), rmse(5, :), 'b-');
plot(rmse(10, :), rmse(6, :), 'r--');
plot(rmse(10, :), rmse(9, :), 'k-');
xlabel('Time [s]');
ylabel('RMSE in acceleration [m/s/s]');
%legend('X', 'Y');
hold off;
