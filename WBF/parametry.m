function [a1, a2] = parametry(N, id)
if(nargin<2)
    id = 1;
end
if(nargin<1)
    N=5000;
end
if(ischar(id))
    if(strcmp(id, 'A'))
        id = 2;
    elseif(strcmp(id, 'C'))
        id=3;
    else
        id = 1;
    end
end

if id == 1 % continuous - Doppler
    
    blocks = makesig('LinChirp', 180000);
    blocks = blocks(1:N)';
    a1 = blocks;
    a1 = 0.3*a1 - 0.1;
    a1 = a1';
    % blocks = makesig('LinChirp', 300000);
    %  blocks = blocks(1:N)';
    blocks = [zeros(1,15), blocks'];
    blocks = blocks(1:N)';
    a2 = 0.3*blocks - 0.1;
    %a2 = shift(a2, 10);
    a2 = a2';
elseif id == 2 % discontinuous - Blocks
    a1 = 0.7* block1(N) - 0.2;
    
    a2 =  0.6*block2(N)-0.6;
elseif id==3 % sinus + skoki
    [a1,a2] = sinusy(N);
    
end


function [a1, a2] = sinusy(N)

t = (1:3000)./3000;
a1(1:1000) = sin(2*pi*t(1:1000));
a2(1:1000) = -sin(2*pi*t(101:1100));

t = (1:4000)./4000;
a1(1001:2500)= sin(2*pi*t(2501:end)) + 0.6;
a2(1001:2500)= sin(2*pi*t(2501:end)) + 0.3;

t = (1:2000)./2000;
a1(2501:3500) = 0.8*sin(2*pi*t(1:1000));
a2(2501:3500) = -1.2*sin(2*pi*t(1:1000));

t = (1:1700)./1700;
a1(3501:4250) = 0.7* sin(2*pi*t(626:(625+750)));
a2(3501:4250) = 0.7* sin(2*pi*t(626:(625+750)));

t= (1:4000)./4000;
a1(4251:5000) = sin(2*pi*t(101:850)) - 0.2;
a2(4251:5000) = sin(2*pi*t(101:850)) - 0.2;

a1 = sqrt(0.2441)*a1;
a2= sqrt(0.2019)*a2;

function y = block1(N)
t = (1:N)./N;
pos = [ .05 .13 .15 .23 .25 .40 .44 .65  .76 .78 .95];
hgt = [4 (-5) 3 (-4) 4 (-4.2) 2.1 4.1  (-3.1) 2.1 (-4.2)];
hgt = hgt./5;
y = zeros(size(t));
for j=1:length(pos)
    y = y + (1 + sign(t-pos(j))).*(hgt(j)/2) ;
end

function y = block2(N)
t = (1:N)./N;
pos = [ .05 .13 .15 .23 .25 .40 .44 .65  .76 .78 .95];
hgt = [1 (5) -3 (-4) 3 (4.2) -2.1 3.1  (-4.1) 3.1 (-1.2)];
hgt = hgt./5;
y = zeros(size(t));
for j=1:length(pos)
    y = y + (1 + sign(t-pos(j))).*(hgt(j)/2) ;
end