clear;
clc;

xi = 30;
yi = 230;   % (30, 230)
xf = 260;
yf = 80;    % (260, 80)
x1 = 100;
y1 = 100;   % (70, 140)
x2 = 180;
y2 = 270;   % (180, 270)


yy = [yi; y1; y2; yf];
xx = [xi^3 xi^2 xi 1;
      x1^3 x1^2 x1 1;
      x2^3 x2^2 x2 1;
      xf^3 xf^2 xf 1];

cofs = xx\ yy;

a = cofs(1);
b = cofs(2);
c = cofs(3);
d = cofs(4);

f  = @(x) (a*(x.^3) + (b*(x.^2)) + (c*x) + d);
fdt = @(x) (a*(3*x.^2) + (b*(2*x)) + c);
f2dt = @(x) (6*a*x + b*2);

x = xi:xf;
y = f(x);
z = f(x)*0;

% Puntos críticos
cr1 = abs((2*b - sqrt((2*b)^2-12*a*c))/(6*a));
cr2 = abs((2*b + sqrt((2*b)^2-12*a*c))/(6*a));

% Radio de la curvatura
r1 = abs(((1+fdt(x1)^2)^(3/2))/f2dt(x1));
r2 = abs(((1+fdt(x2)^2)^(3/2))/f2dt(x2));


lfdt = @(x) sqrt((1 + fdt(x)).^2);
longitudPista = integral(lfdt, xi, xf);

% Graficación
close all;
axes('XLim',[0 300],'YLim',[0 300],'ZLim',[0 300],'XDir','reverse','YDir','reverse');
view(3)
hold on;
plot3(x,y,z, '-', 'color', 'k', 'LineWidth', 20)
plot3(x,y,z,'--', 'color', 'y')


v = [3 0 3;3 0 0;0 0 0;0 0 3;3 3 3;3 3 0;0 3 3;0 3 0];
f = [1 5 7 4;4 7 8 3;3 8 6 2;2 6 5 1];

coche = patch('Faces',f,'Vertices',v,'FaceAlpha',0.5, 'FaceColor','red');

OrigVerts = p1.Vertices;

for i = 1:3:length(x)
    delete(coche);
    coche.Vertices = OrigVerts + i*repmat(vel,[size(OrigVerts,1),1]);
    pause(0.1);
end


% Graficación
% close all;
% hold on;
% grid on;
% axis([0 280 50 300])
% plot3(x, y,x.*0, 'LineWidth', 20, "Color", 'k');
% plot3(x, y,x.*0, 'LineWidth', 2, 'LineStyle', '--', "Color", 'y');

%plotcircle(cr1, f(cr1)+r1, r1);
%plotcircle(cr2, f(cr2)-r2, r2);

% coche = rectangle('Position',[0 0 20 15], 'FaceColor', 'r');
% for i = 1:3:length(x)
%     delete(coche);
%     coche = rectangle('Position',[(x(i)-10) (y(i)-7.5) 20 15], 'FaceColor', 'r');
%     pause(0.1);
% end