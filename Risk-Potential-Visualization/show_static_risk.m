function show_static_risk(U,x_o,y_o)
% Show static risk
    w_o = 1;
    sigma_ox = 1.5;
    sigma_oy = 1.5;
    s=size(U);
    for x = 1:1:s(2)
        for y = 1:1:s(1)
            U(y,x) = w_o*exp(-(x-x_o)^2/sigma_ox^2-(y-y_o)^2/sigma_oy^2);
        end
    end
    [C,h]=contour(U,5);
    hold on
end