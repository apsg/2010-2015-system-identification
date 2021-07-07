function y = pila(x)
id=0
poz = 0;

y = zeros(size(x));

for i=5:length(x)
    if(poz <=0 & (x(i-3) - x(i) > 0))
        y(id+1:i) = linia(id+1, i, poz, 1); 
        poz = 1;
        id = i;
    elseif(poz > 0 & (x(i-3) - x(i) < 0))
        y(id+1:i) = linia(id+1, i, poz, -1);
        poz = -1;
        id = i;
    end
end

y(id+1:length(y)) = linia(id+1, length(y), poz, 0);

function l = linia(pocz, koniec, start, stop)
diff = stop - start;
n = koniec - pocz;
l = start:diff/n:stop;