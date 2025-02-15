%%
% Author: Jacob Perricone
% Description: Implements the Barzilai-Borwein Method on an initial point x0_initial, x_initial
% for classifying two sets of points a and b
% f: function to optimize over
% df: gradient function
%%
function [ x, x0,iter, fvals, gvals] = BB1(f, df, x_initial, x0_intial, a, b, MAX_ITER, TOL, debug, one,mu)


% get initial data
x = x_initial;
x0 = x0_intial;

% concatenate the two
x_cat_prev = [x; x0];

% iteration one
iter = 1;
fvals = [];
gvals = [];
fvals(iter) = f(x,x0, a,b, mu);
gvals(iter) = norm(df(x,x0,a,b,mu));


% Find the first objective values and deltas
x_initial = [0;0;0];
delta_x = x_cat_prev;
delta_g = df(x,x0,a,b,mu) - df(x_initial(1:end-1), x_initial(end), a, b,mu);





%% print 
if debug
    disp(sprintf('-----------------------Iteration: %d--------------------------------', iter));
    disp('     x_1        x_2        x_0     f(x)   change_F  delta_x1  delta_x2   delta_x0   delta_g1  deltag2   deltag3   alpha ')
    disp([  x(1), x(2), x0, fvals(iter), NaN, delta_x(1), delta_x(2), delta_x(3), delta_g(1), delta_g(2), delta_g(3), NaN ])
    
end

% initialize randomly
delta_f = 1000;
norm_grad = 100000;
change_x = 100000;
alpha = 1000000;

while iter < MAX_ITER
    
    if abs(norm_grad) < TOL
        disp(sprintf('----GRADIENT NORM IS BELOW TOLERANCE CONVERGENCE OF FUNCTION AFTER %d ITERATIONS-----', iter))
        disp(sprintf('-----------------------FINAL RESULT Iteration: %d--------------------------------', iter));
        disp('     x_1        x_2        x_0     f(x)   change_F  delta_x1  delta_x2   delta_x0   delta_g1  deltag2   deltag3   alpha  NORMGRAD ')
        disp([ x(1), x(2), x0, fvals(iter), delta_f,  delta_x(1), delta_x(2), delta_x(3), delta_g(1), delta_g(2), delta_g(3), alpha, norm_grad])
        
        
        break;
    end
    
%     if change_x < 1e-8
%         iter = iter + 1;
%         disp(sprintf('=---CHANGE IN X IS TINY, CONVERGENCE OF FUNCTION AFTER %d ITERATIONS-----', iter))
%         disp(sprintf('-----------------------FINAL RESULT Iteration: %d--------------------------------', iter));
%         disp('     x_1        x_2        x_0     f(x)   change_F  delta_x1  delta_x2   delta_x0   delta_g1  deltag2   deltag3   alpha  NORMGRAD ')
%         disp([ x(1), x(2), x0, fvals(iter), delta_f,  delta_x(1), delta_x(2), delta_x(3), delta_g(1), delta_g(2), delta_g(3), alpha, norm_grad])
%         break;
%     end
%     
    
    % increment iteration
    iter = iter + 1;
    
    % two different alphas
    alpha_k_1 = (delta_x'*delta_g)/(delta_g'*delta_g);
    alpha_k_2 = (delta_x'*delta_x)/(delta_x'*delta_g);
    

    % if one, use gradient info
    if one
        alpha = alpha_k_1;
    else
        alpha = alpha_k_2;
    end
    
    % descend
    x_cat_new = x_cat_prev - alpha*df(x,x0, a, b,mu);

    % save new values
    x = x_cat_new(1:end-1);    
    x0 = x_cat_new(end);
    
    % save function and gradient values
    fvals(iter) = f(x,x0, a, b,mu);
    gvals(iter) = norm(df(x,x0,a,b,mu));
    
    % calculate change stuff
    delta_f = fvals(iter) - fvals(iter - 1);
    change_x = norm(x_cat_new - x_cat_prev,2);
    norm_grad = norm(df(x,x0,a,b,mu),2);
    
    
    
    if debug
        disp(sprintf('-----------------------Iteration: %d--------------------------------', iter));
        disp('     x_1        x_2        x_0     f(x)   change_F  delta_x1  delta_x2   delta_x0   delta_g1  deltag2   deltag3   alpha  NORMGRAD ')
        disp([ x(1), x(2), x0, fvals(iter), delta_f,  delta_x(1), delta_x(2), delta_x(3), delta_g(1), delta_g(2), delta_g(3), alpha, norm_grad])
        
    end
    
    delta_x =  x_cat_new - x_cat_prev;
    delta_g = df(x, x0, a, b,mu) - df(x_cat_prev(1:end-1), x_cat_prev(end), a, b,mu);
    x_cat_prev = x_cat_new;
    
    
end

if mu
    s = 'With Regularization';
else
    s = 'No Regularization';
end


fig = figure();
subplot(2,1,1)
plot(1:iter, gvals, 'LineWidth',2); grid on;
title(strcat({' Norm Gradient Function BB Method: '}, s)); 
xlabel('Iteration'); ylabel('G(x)');

subplot(2, 1, 2)
plot(1:iter, fvals, 'LineWidth',2); grid on;
title(strcat({'Objective Function BB Method: '}, s));

xlabel('Iteration'); ylabel('F(x)');

save_string = [pwd strcat('/FIGURES/Problem5/BB2', '_', s,'.png')];
saveas(fig, save_string)



end
