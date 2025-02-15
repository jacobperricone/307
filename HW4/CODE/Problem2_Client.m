clear all
close all

Hw3_path = '/Users/jacobperricone/Desktop/STANFORD/w16/git_cme307/HW3'
addpath(genpath(Hw3_path))

%% Problem 5
a = [0, 1, 0; 0 0, 1];
b = [0,-1, 0; 0, 0,-1];
mu = [0, 10^-5];

x_initial = [.5;1.25];
x0_initial= .124;
ALPHA = .05;
MAX_ITER = 25090;
TOL = .000001;

f = @(x,x0,  a, b) sum(log(1 + exp(-a'*x - x0))) + sum(log(1 + exp(b'*x + x0)));
f2  = @(x,x0,  a, b, mu) sum(log(1 + exp(-a'*x - x0))) + sum(log(1 + exp(b'*x + x0)));
df = @(x,x0, a, b) ...
    [sum((-a(1,:)'.*exp(-a'*x - x0)) ./ (1 + exp(-a'*x - x0))) ...
    + sum((b(1,:)'.*exp(b'*x + x0)) ./ (1 + exp(b'*x + x0))); ... 
    sum((-a(2,:)'.*exp(-a'*x - x0)) ./ (1 + exp(-a'*x - x0))) ...
    + sum((b(2,:)'.*exp(b'*x + x0)) ./ (1 + exp(b'*x + x0))); ... 
    sum((-exp(-a'*x - x0)) ./ (1 + exp(-a'*x - x0))) ...
    + sum((exp(b'*x + x0)) ./ (1 + exp(b'*x + x0)))];

df2 = @(x,x0, a, b,mu) ...
    [sum((-a(1,:)'.*exp(-a'*x - x0)) ./ (1 + exp(-a'*x - x0))) ...
    + sum((b(1,:)'.*exp(b'*x + x0)) ./ (1 + exp(b'*x + x0))); ... 
    sum((-a(2,:)'.*exp(-a'*x - x0)) ./ (1 + exp(-a'*x - x0))) ...
    + sum((b(2,:)'.*exp(b'*x + x0)) ./ (1 + exp(b'*x + x0))); ... 
    sum((-exp(-a'*x - x0)) ./ (1 + exp(-a'*x - x0))) ...
    + sum((exp(b'*x + x0)) ./ (1 + exp(b'*x + x0)))];

%%
newa = vertcat(a,ones(1,size(a,2)));
tmpa = zeros(size(a,2), size(a,1)*(size(a,2) + 1));
tmpa(1,1:3) = newa(:,1)';
tmpa(2,4:6) = newa(:,2)';
tmpa(3,7:9) = newa(:,3)';
tmpa = reshape(newa*tmpa,3,3,size(a,2));

newb = vertcat(b,ones(1,size(b,2)));
tmpb = zeros(size(b,2), size(b,1)*(size(b,2) + 1));
tmpb(1,1:3) = newb(:,1)';
tmpb(2,4:6) = newb(:,2)';
tmpb(3,7:9) = newb(:,3)';
tmpb = reshape(newb*tmpb,3,3,size(b,2));


z = @(x,x0,a) (repmat(reshape(exp(-a'*x - x0)./( 1 + exp(-a'*x - x0)).^2,1,1,size(newa,2)),size(newa,1),size(newa,1),1));
zbar  = @(x,x0,b)(repmat(reshape(exp(b'*x + x0)./(1 + exp(b'*x + x0)).^2,1,1,size(newb,2)),size(newb,1),size(newb,1),1));


hessian = @(x,x0,a,b)(sum(z(x,x0,a).*tmpa,3) + sum(zbar(x,x0,b).*tmpb,3));
%%



[X_Newton, X0_Newton, iter_N,fvals_N, gvals_N, hvals_N] = Newton(f, df, hessian,x_initial, x0_initial, a, b,ALPHA, MAX_ITER, TOL,0);
[X_DFP, X0_DFP, iter_DFP,fvals_DFP, gvals_DFP,hvals_DFP] = DFP(f, df, hessian,x_initial, x0_initial, a, b,.1, MAX_ITER, TOL,0);
[x_SDM, x0_SDM, iter_SDM,fvals_SDM, gvals_SDM] = SDM(f2, df2, x_initial, x0_initial, a, b,ALPHA, MAX_ITER, TOL,0,0);

[x_ASDM, x0_ASMD, iter_ASDM,fvals_ASDM, gvals_ASDM] = ASDM(f2, df2, x_initial, x0_initial, a, b,1/ALPHA, MAX_ITER, TOL,0,0);

[x_CGD, x0_CGD, iter_CGD,fvals_CGD, gvals_CGD] = CGD(f2, df2, x_initial, x0_initial, a, b, MAX_ITER, TOL,0,0);

[x_BB, x0_BB, iter_BB,fvals_BB, gvals_BB] = BB1(f2, df2, x_initial, x0_initial, a, b, MAX_ITER, TOL,1,1,0);
%% Generate random data

figure()
subplot(2,1,1)
loglog(1:iter_N, fvals_N)
hold on
loglog(1:iter_DFP, fvals_DFP)
hold on
loglog(1:iter_SDM, fvals_SDM)
hold on
loglog(1:iter_ASDM, fvals_ASDM)
hold on
loglog(1:iter_CGD, fvals_CGD)
hold on
loglog(1:iter_BB, fvals_BB)
legend('Newton', 'DFP', 'SDM', 'ASDM', 'CGD','BB')
title('Function Value vs. Iteration (LogSpace)')
xlabel('$\log[\mbox{Iteration}]$','Interpreter', 'LaTex')
ylabel('$\log[f(x)]$', 'Interpreter', 'LaTex')

subplot(2,1,2)
loglog(1:iter_N, gvals_N)
hold on
loglog(1:iter_DFP, gvals_DFP)
hold on
loglog(1:iter_SDM, gvals_SDM)
hold on
loglog(1:iter_ASDM, gvals_ASDM)
hold on
loglog(1:iter_CGD, gvals_CGD)
hold on
loglog(1:iter_BB, gvals_BB)
legend('Newton', 'DFP', 'SDM', 'ASDM', 'CGD','BB')
title('Norm Gradient Value vs. Iteration (LogSpace)')
xlabel('$\log[\mbox{Iteration}]$','Interpreter', 'LaTex')
ylabel('$\log[g(x)]$', 'Interpreter', 'LaTex')

%%
figure()
subplot(3,1,1)
loglog(1:iter_N, fvals_N)
hold on
loglog(1:iter_DFP, fvals_DFP)
hold on
legend('Newton', 'DFP')
title('Function Value vs. Iteration (LogSpace)')
xlabel('$\log[\mbox{Iteration}]$','Interpreter', 'LaTex')
ylabel('$\log[f(x)]$', 'Interpreter', 'LaTex')

subplot(3,1,2)
loglog(1:iter_N, gvals_N)
hold on
loglog(1:iter_DFP, gvals_DFP)
hold on
legend('Newton', 'DFP')
title('Norm Gradient Value vs. Iteration (LogSpace)')
xlabel('$\log[\mbox{Iteration}]$','Interpreter', 'LaTex')
ylabel('$\log[g(x)]$', 'Interpreter', 'LaTex')


subplot(3,1,3)
loglog(1:iter_N, hvals_N)
hold on
loglog(1:iter_DFP, hvals_DFP)
hold on
legend('Newton', 'DFP')
title('Norm Hessian Value vs. Iteration (LogSpace)')
xlabel('$\log[\mbox{Iteration}]$','Interpreter', 'LaTex')
ylabel('$\log[F(x)]$', 'Interpreter', 'LaTex')





