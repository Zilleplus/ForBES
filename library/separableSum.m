%SEPARABLESUM Combines separable functions into their sum
%
%   SEPARABLESUM(fs, idx, sizes) where fs is a cell array of function
%   objects, while idx and sizes are integer vectors of the same length.
%   If length(idx) = length(sizes) = k, then SEPARABLESUM returns the
%   function object correspondent to the sum
%       
%       f(x) = sum_i=1...k fs{idx(i)}(x_i)
%
%   i.e., the sum of k functions, the ith being idx(i) and applied to a
%   block of size(i) variables.
%
% Copyright (C) 2015, Lorenzo Stella and Panagiotis Patrinos
%
% This file is part of ForBES.
% 
% ForBES is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% ForBES is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Lesser General Public License
% along with ForBES. If not, see <http://www.gnu.org/licenses/>.

function obj = separableSum(objs, sizes, idx)
    l = length(objs);
    if nargin < 3
        idx = 1:l;
    end
    obj.makeprox = @() make_separableSum_prox(objs, idx, sizes, gam0);
end

function op = make_separableSum_prox(objs, idx, sizes, gam0)
    proxes = {};
    for i=1:length(objs)
        proxes{end+1} = objs{i}.makeprox(gam0);
    end
    op = @(x, gam) call_separableSum_prox(x, gam, proxes, idx, sizes);
end

function [prox, val] = call_separableSum_prox(x, gam, proxes, idx, sizes)
    n = sum(sizes);
    prox = zeros(n, 1);
    val = 0;
    baseidx = 0;
    for i=1:length(idx)
        endcurr = baseidx+sizes(i);
        xcurr = x(baseidx+1:endcurr);
        [prox(baseidx+1:endcurr), val1] = proxes{idx(i)}(xcurr, gam);
        val = val+val1;
        baseidx = endcurr;
    end
end
