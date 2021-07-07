function wyswietl(T)

s = '\t & %2.2f ';

for i=1:size(T,2)
    s = [s, '\t & %2.2f '];
end

s = [s,  ' \\\\ '];

for i=1:size(T,1)
    disp(sprintf(s, 0.05*i, T(i,:)))
end