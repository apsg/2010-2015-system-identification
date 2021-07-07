clear all;
clc;

%sta�e
px = 1;	%pos x
py = 2;	%pos y
vx = 3;	%velocity x
vy = 4;	%velocity y

g = 10;		%przyspieszenie ziemskie
dt = 0.1;	%okres probkowania
sim_time = 50;	%czas symulacji

%macierz systemowa dla CV (stala)
A_cv = [ 1  0 dt  0;
	  0  1  0 dt;
	  0  0  1  0;
	  0  0  0  1];

%warunki pocz�tkowe
x = [29500; 35000; -250; -210];
history = x;

%parametry dynamiczne
a_dosrodkowe = 30; %[m/s/s]
sterowanie = zeros(size(dt:dt:sim_time));
sterowanie(10/dt:22/dt) = -3*g;
sterowanie(26/dt:38/dt) =  3*g;

n = 1;

for t = dt:dt:sim_time %startujemy od t=0+dt, bo t=0 to znane warunki pocz�tkowe
	
	%ewolucja stanu
	
	if(sterowanie(n) == 0) %Constant Velocity
		
		nx = A_cv*x;
		
	else	%Controlled Coordinated Turn
		
		a_dosrodkowe = sterowanie(n);
		
		%modyfikacje wektora stanu (przyspieszenie normalne/do�rodkowe)
		v2 = x(vx)^2+x(vy)^2;
		v = sqrt(v2);
		w = a_dosrodkowe/v;
		
		nx(px) = x(px) + x(vx)*sin(w*dt)/w     + x(vy)*(1-cos(w*dt))/w;
		nx(py) = x(py) + x(vx)*(cos(w*dt)-1)/w + x(vy)*sin(w*dt)/w;
		nx(vx) = x(vx)* cos(w*dt) + x(vy)*sin(w*dt);
		nx(vy) = x(vx)*-sin(w*dt) + x(vy)*cos(w*dt);
		
    end
	
	%aktualizacja wektora stanu
	x = nx;
	
	%archiwizacja wartosci
	history = [history, x];
	n=n+1;
	
end;

%wykres polozenia X-Y
figure(1); clf;
plot(history(px,:), history(py,:));
xlabel('X coordinate [m]');
ylabel('Y coordinate [m]');
grid on;

%wykres predkosci X i Y
figure(2); clf;
hold on;
plot(0:dt:sim_time, history(vx,:), 'b');
plot(0:dt:sim_time, history(vy,:), 'r--');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
legend('X velocity', 'Y velocity');
grid on;
hold off;

ax = []; ay = []; am = [];
for k = 1:size(history, 2)-1
	ax(k) = (history(vx, k+1) - history(vx, k))/dt;
	ay(k) = (history(vy, k+1) - history(vy, k))/dt;
	am(k) = sqrt(ax(k)^2 + ay(k)^2);
end;

%wykres przyspieszenia X i Y
figure(3); clf;
hold on;
plot(dt:dt:sim_time, ax, 'b');
plot(dt:dt:sim_time, ay, 'r--');
xlabel('Time [s]');
ylabel('Acceleration [m/s/s]');
legend('X acceleration', 'Y acceleration');
grid on
hold off;

%wykres modulu przyspieszenia
figure(4); clf;
hold on;
plot(dt:dt:sim_time, am);
xlabel('Time [s]');
ylabel('Magnitude of acceleration [m/s/s]');
grid on
hold off;
