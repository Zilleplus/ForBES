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

function out = GetPrimalOutput(prob, dualprob, dualout)
    out.message = dualout.message;
    out.flag = dualout.flag;
    out.gam = dualout.gam;
    Ax = 0;
    y = dualout.x;
    if isfield(prob, 'f1')
        if isa(prob.A1, 'function_handle')
            out.x1 = dualprob.Q(-prob.A1t(y))+dualprob.q;
            Ax = Ax+prob.A1(out.x1);
        else
            out.x1 = dualprob.Q(-prob.A1'*y)+dualprob.q;
            Ax = Ax+prob.A1*out.x1;
        end
    end
    if isfield(prob, 'f2')
        if isa(prob.A2, 'function_handle')
            [~, out.x2] = dualprob.callf2(-prob.A2t(y));
            Ax = Ax+prob.A2(out.x2);
        else
            [~, out.x2] = dualprob.callf2(-prob.A2'*y);
            Ax = Ax+prob.A2*out.x2;
        end
    end
    mugam = prob.muB*out.gam;
    if isfield(prob, 'b')
        [out.z, ~] = dualprob.callg(-prob.B'*(y+out.gam*(Ax-prob.b))/mugam, 1/mugam);
    else
        [out.z, ~] = dualprob.callg(-prob.B'*(y+out.gam*Ax)/mugam, 1/mugam);
    end
    out.y = y;
    out.iterations = dualout.iterations;
    if isfield(dualout, 'operations'), out.operations = dualout.operations; end
    out.residual = dualout.residual;
    out.ts = dualout.ts;
    out.prob = prob;
    out.preprocess = dualout.preprocess;
end
