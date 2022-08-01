clear;clc;close all

%%
% Points
x_1 = 1; y_1 = -2;
x_2 = 2; y_2 = -4;
x_3 = 13; y_3 = -4;
x_4 = 14; y_4 = -2;

% Lagrange interpolation
x = x_2:1:x_3;
y = ((x - x_2).*(x - x_3))./((x_1 - x_2).*(x_1 - x_3))*y_1...
    +((x - x_1).*(x - x_3))./((x_2 - x_1).*(x_2 - x_3))*y_2...
    +((x - x_1).*(x - x_2))./((x_3 - x_1).*(x_3 - x_2))*y_3;

% figure
figure
scatter([x_1, x_2, x_3, x_4],[y_1, y_2, y_3, y_4])
hold on
scatter(x,y)

%%
figure
p_next = [];
legend_tag = {};
for i=1:1:20
    % 
    x_1 = x(1); y_1 = y(1);
    x_2 = x(2); y_2 = y(2);
    x_3 = x(1)+12; y_3 = y(2);
    x_4 = x(2)+12; y_4 = y(1);
    
    % Lagrange interpolation
    x = x_2:1:x_3;
    y = ((x - x_2).*(x - x_3))./((x_1 - x_2).*(x_1 - x_3))*y_1...
        +((x - x_1).*(x - x_3))./((x_2 - x_1).*(x_2 - x_3))*y_2...
        +((x - x_1).*(x - x_2))./((x_3 - x_1).*(x_3 - x_2))*y_3;
    
    % figure
    scatter(x,y)
    hold on
    
    legend_tag{i} = num2str(i);
    p_next = [p_next;x(2), y(2)];
end

plot(p_next(:,1),p_next(:,2))
legend(legend_tag,"Line")