classdef wektor 
    
    properties
       A
       rozmiar
    end
    methods 
        function obj = wektor(varargin)
            obj.rozmiar = [];
            for i=1:nargin
                obj.rozmiar = [obj.rozmiar, varargin{i}];
            end
           obj.A = zeros(obj.rozmiar); 
           
        end
        
        function x = subsref(obj, t)
            disp(t)
            t = [t.subs{:}];
            
            if(length(obj.rozmiar) == 2)
                x = obj.A(:,t);
            elseif(length(obj.rozmiar)==3)
                x = obj.A(:,:,t);
            else
                x = obj.A(t);
            end
        end
        
        function obj = subsasgn(obj, t, val)
            t = [t.subs{:}];
            if(length(obj.rozmiar) == 2)
                obj.A(:,t) = val;
            elseif(length(obj.rozmiar)==3)
                obj.A(:,:,t) = val;
            else
                obj.A(t) = val;
            end
            
        end
        
        function s = size(obj)
            s = size(obj.A);
        end
        
        function x = p(obj, n)
            x = obj.A(n, :);
        end
    end
end