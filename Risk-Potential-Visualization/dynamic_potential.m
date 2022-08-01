function p = dynamic_potential(theta_pos,yaw,r,v)
% Calcurate dynamic potential risk
    k = 5.0; % ‘å‚«‚³
    I = besseli(0,k);
    sigma = 0.5; % ¬‚³‚³
    alfa = 2.0;
    beta = 1.0;
    p = exp(k*cos(theta_pos-yaw))/(2*pi*I) * alfa * exp(-r/(2*sigma))/(2*pi*sigma) * beta * abs(v);
end