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

end


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