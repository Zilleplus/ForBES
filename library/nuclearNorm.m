%NUCLEARNORM Allocates the nuclear norm function
%
%   NUCLEARNORM(m, n, lam) builds the function
%       
%       g(x) = lam*||x||_*
%
%   where ||.||_* is the nuclear norm for m-by-n matrices, and x is assumed
%   to be a vector of length m*n, containing the stacked columns of an
%   m-by-n matrix. If the third argument lam is not provided, lam = 1;
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

function obj = nuclearNorm(m, n, lam)
% proximal mapping of the nuclear norm (times lam) of an m by n matrix
    if nargin < 2
        error('you must provide the number of rows and columns, m and n, as arguments');
    end
    if nargin < 3
        lam = 1;
    end
    obj.makeprox = @() @(x, gam) call_nuclearNorm_prox(x, gam, m, n, lam);
end

function [prox, val] = call_nuclearNorm_prox(x, gam, m, n, lam)
    [U, S, V] = svd(reshape(x, m, n), 'econ');
    diagS1 = max(0, diag(S)-lam*gam);
    S1 = diag(sparse(diagS1));
    prox = reshape(U*(S1*V'), m*n, 1);
    if nargout >= 2
        val = lam*sum(diagS1);
    end
end
