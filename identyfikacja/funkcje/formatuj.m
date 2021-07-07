function formatuj(W)
if(size(W,2) == 4)
    for i=1:size(W, 1)
        disp(sprintf('\t & \t & %1.2f & %2.2f & %2.2f & %2.2f & %2.2f \\\\', i*0.05, W(i,:)))
    end
else
    for i=1:size(W, 1)
        disp(sprintf('\t & \t & %1.2f & %2.2f & %2.2f & %2.2f & %2.2f & %2.2f \\\\', i*0.05, W(i,:)))
    end
end