clear all
clc

A = [
    2 3 1 0
    2 1 0 1
    ]

X = [0 0 6 4].'

Q = [
    -1 0 0 0
     0 0 0 0
     0 0 0 0
     0 0 0 0
    ]

c = [-2 1 0 0].'

%Lmbd = [1 -1]
% END OF INPUTTING %

b  = X(X~=0)
Xb = X(X~=0)
Xn = X(X==0)

%Zeta = max(0, Lmbd)
%Xi  = -min(0, Lmbd)

nX = length(X);
nE = length(b);

Qb = Q(:, X~=0)
Qn = Q(:, X==0)

Dlt = zeros(nX);
for i = 1:nX
    if c(i)+Qb(i, :)*Xb <= 0
        Dlt(i, i) = 1;
    else
        Dlt(i, i) = -1;
    end
end
Dlt

negI = - eye(nX);


smplx = zeros(nX+nE, 4*nX+3*nE);

smplx(1:nE,1:nX) = A;

smplx((nE+1):(nX+nE),1:nX) = 2*Q;
smplx((nE+1):(nX+nE), (nX+1):(nX+nE)) = A.';
smplx((nE+1):(nX+nE), (nX+nE+1):(nX+2*nE)) = -A.';
smplx((nE+1):(nX+nE), (nX+2*nE+1):(2*nX+2*nE)) = negI;
smplx((nE+1):(nX+nE), (2*nX+2*nE+1):(3*nX+2*nE)) = Dlt;

values = zeros(nX+nE, 1);
values(1:nE) = b;
values((nE+1):(nX+nE)) = -c;

mltpl = 1-2*(values < 0);
smplx = smplx.*mltpl;
values = values.*mltpl;

Artfcl = eye(nX+nE);
smplx(1:(nX+nE), (3*nX+2*nE+1):(4*nX+3*nE)) = Artfcl;


coeffs = zeros(1, 4*nX+3*nE);
coeffs(1:(3*nX+2*nE)) = sum(smplx(:, 1:(3*nX+2*nE)), 1);

%coeffs(1:lX) = X;
%coeffs((lX+1):(lX+nE)) = Zeta;
%coeffs((lX+nE+1):(lX+2*nE)) = Xi;
%coeffs((lX+2*nE+1):(2*lX+2*nE)) = Mu;
%coeffs((2*lX+2*nE+1):(3*lX+2*nE)) = U;

fVal = sum(values);


disp(' ')
disp(' ')
disp(' ')
disp(smplx)
disp(values)
disp(coeffs)
disp(fVal)

%
fprintf('\tSimplex prev(%i, %i);\n\t{\n', size(smplx, 1), size(smplx, 2))
for y = 1:size(smplx, 1)
    fprintf('\t\t')
    for x = 1:size(smplx, 2)
        fprintf('prev.elem(%i, %i, %f); 	', y, x, smplx(y, x))
    end
    fprintf('prev.val(%i, %f);\n', y, values(y))
end
fprintf('\t\t')
for x = 1:size(smplx, 2)
    fprintf('prev.coeff(%i, %f); 	', x, coeffs(x))
end
fprintf('prev.fVal(%f);\n\t}\n', fVal)
%}