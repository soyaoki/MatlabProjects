clear;clc;close all;

%%
mu = optimizableVariable('mu',[-5,5],'Type','integer');
sigma = optimizableVariable('sigma',[0,5],'Type','integer');

fun = @(x)ObjectiveFunction(x.mu, x.sigma);
resbo = bayesopt(fun, [mu,sigma],'Verbose',0,...
    'AcquisitionFunctionName','expected-improvement-plus',...
    'MaxObjectiveEvaluations', 60)

%%
GPR = fitrgp(resbo.XTrace,resbo.ObjectiveTrace);
mu_ = linspace(-6,6)';
sigma_ = linspace(-1,6)';
[ypred,~,yint] = predict(GPR,[mu_, sigma_]);

figure()
hold on; grid on
% Observed data points
scatter3(resbo.XTrace.mu, resbo.XTrace.sigma, resbo.ObjectiveTrace,'r')
% GPR predictions
plot3(mu_, sigma_, ypred,'g')
% Prediction intervals
fill3([mu_;flipud(mu_)], [sigma_;flipud(sigma_)], [yint(:,1);flipud(yint(:,2))],'k','FaceAlpha',0.1);
hold off

%%
beep;