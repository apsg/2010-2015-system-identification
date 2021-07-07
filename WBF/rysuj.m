function rysuj( varargin )
%RYSUJ Summary of this function goes here
%   Detailed explanation goes here
[K, N] = size(varargin{1});
figure; hold on

s = {'k', 'r', 'b', 'g', 'y', 'm'};

for i=1:nargin
    th = varargin{i};
    for k=1:K
        subplot(K, 1, k), plot(th(k, :), s{i}), hold on
    end
end
    


end

