function [V, E] = eigen_spectram(A)
% this function computes laplacian of A and then eigen spectram of laplacian

%{
% laplacian using formula L = D - A and then normalization
nf = size(A, 1) ;
D = sum(A) ;
L = -A ;
L(1:nf+1:nf*nf) = D(:) ;
D = diag(1./sqrt(D)) ;
L = D*L*D ;
%}

% laplacian using formula L = I - XAX where X = D^(-1/2)
D = sum(A) ;
D = diag(1./sqrt(D)) ;
L = eye(size(D, 1)) - D*A*D ;

% eigen decomposition of laplacian
[V, E] = eig(L) ;
V = D*V ;

end