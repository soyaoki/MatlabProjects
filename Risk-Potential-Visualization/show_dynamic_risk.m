function show_dynamic_risk(x,y,yaw,v)
% Show dynamic risk
    theta = 0:0.01:2*pi;
    r = 0.1:0.2:1;
    mp = colormap;
    for i=1:length(r)
        [x_p,y_p] = pol2cart(theta,dynamic_potential(theta,yaw,r(i),v));
        plot(x+x_p,y+y_p,'Color',mp(i*10,:));
        hold on;
    end
end
