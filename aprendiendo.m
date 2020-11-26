% test_patch.m
clc;
clear;


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


lfdt = @(x) sqrt(1 + fdt(x).^2);
longitudPista = integral(lfdt, xi, xf);

% Graficación
%axes('XLim',[0 300],'YLim',[0 300],'ZLim',[0 300],'XDir','reverse','YDir','reverse');
view(3)
hold on;
line(x,y,z+1,'Color','k','LineWidth',4)
line(x,y,z+1,'Color','y','LineStyle','--')


% clear; close all;

% Define vertices
vertices = [
    0,0,0;
    300,0,0;
    300,300,0;
    0,300,0;]; 

% Define faces
faces = [
    1, 2, 3, 4]; % face #1

% Draw patch
figure(1);
patch('Faces', faces, 'Vertices', vertices, 'FaceColor', 'g');

% Axes settings
xlabel('x'); ylabel('y'); zlabel('z');
axis vis3d equal;
view([142.5, 30]);
camlight;


%% Additional
syms x
% Min N Max points
primeraD = (a*(3*x.^2)) + (b*(2*x)) + c;
answer = solve( primeraD == 0, x, 'MaxDegree', 3);
resultado = vpa(answer,6);
sprintf("Max: %s , %s", resultado(1), f(resultado(1)))
plot3(resultado(1), f(resultado(1)),3, '.');   
text(resultado(1), f(resultado(1)),10, '\leftarrow Max')
sprintf("Min: %s, %s", resultado(2), f(resultado(2)))
plot3(resultado(2), f(resultado(2)), 3, '.')
text(resultado(2), f(resultado(2)),10, '\leftarrow Min')

% Inflection point
segundaD = 6*a*x + 2*b;
answer2 = vpasolve(segundaD == 0, x, [-inf, inf]);
sprintf("Inflection: %s , %s", answer2(1), f(answer2(1)))
plot3(answer2(1), f(answer2(1)),3, '.');
text(answer2(1), f(answer2(1)),10, '\leftarrow Inflection')

% Track length
longitud_pista = integral(lfdt, xi, xf);
disp("Longitud de la pista: " + longitud_pista);

% Radius of curvature
valores = radiocurvatura(resultado(1), f(resultado(1)), fdt(resultado(1)), f2dt(resultado(1)));
plotcircle(valores(2), valores(3), valores(1));
plot3(valores(2), valores(3), 3, '.');
sprintf("Radio Curvatura Max: %s and %s",valores(2), valores(3))

valores_dos = radiocurvatura(resultado(2), f(resultado(2)), fdt(resultado(2)), f2dt(resultado(2)));
plotcircle(valores_dos(2), valores_dos(3), valores_dos(1));
plot3(valores_dos(2), valores_dos(3),3, '.');
sprintf("Radio Curvatura Min: %s and %s",valores_dos(2), valores_dos(3))
axis equal;
%axis([-20 20 -20 20])

% rc_inflection = radiocurvatura(answer2(1), f(answer2(1)),fdt(answer2(1)), f2dt(answer2(1)));
% sprintf("Radio Curvatura Punto Inflexión: %s", rc_inflection(1))
%daspect manual;

plot_3d_cube(80, 10, 10, [0.75 0.75 0.75], 50, 70, 0);

%% Functions 
function h = plotcircle(xs,ys,r)
    th = 0:pi/50:2*pi;
    xunit = r*cos(th) + xs;
    yunit = r*sin(th) + ys;
    h = plot(xunit, yunit, 'LineWidth',4);
end

% Input (x,f(x), f'(x), f''(x) )     f(x) = y
% [Radio de curvatura, x, y] de circulo
function t = radiocurvatura(xs, ys,fdtx, f2dtx)
    %r_c = (1 + (fdtx)^2)^(3/2)/ abs(f2dtx);
    r_c = abs(   sqrt(   (  1  + (fdtx).^2   ).^3   )   /  abs(f2dtx));
    alfa = xs - ((fdtx*(1+ fdtx^2))/f2dtx);
    beta = ys + ((1 + fdtx^2)/f2dtx);
    t = [r_c, alfa, beta];
end

% This function should plot a square depending of x,y,z lengths and
% point where you want it to plot. Z will be set to 0
% (lenth_x, length_y, length_z, x_point, y_point)
function plot_3d_cube(x_length, y_length, z_length, cube_color, x_point, y_point, z_point) %%theta in radian
% Parameters
%x_length = 80; y_length = 20; z_length = 20; cube_color = [0.75 0.75 0.75]; x_point = 50; y_point = 70;z_point = 0;

H=[0+x_point ,1*x_length+x_point ,0+x_point ,1*x_length+x_point ,0+x_point ,1*x_length+x_point,0+x_point,1*x_length+x_point; 0+y_point,0+y_point,1*y_length+y_point,1*y_length+y_point,0+y_point,0+y_point,1*y_length+y_point,1*y_length+y_point; 0+z_point,0+z_point,0+z_point,0+z_point,1*z_length+z_point ,1*z_length+z_point,1*z_length+z_point, 1*z_length+z_point];
%H=[0 ,80 ,0 ,80 ,0 ,80 ,0 ,80; 0 ,0 ,20 ,20 ,0 ,0 ,20 ,20; 0 ,0 ,0 ,0 ,20 ,20 ,20 , 20]; %Vertices of the cube
S=[1 2 4 3; 1 2 6 5; 1 3 7 5; 3 4 8 7; 2 4 8 6; 5 6 8 7]; %Surfaces of the cube
figure(1)
hold on
H1 = zeros(size(S,1),4) ;
H2 = zeros(size(S,1),4) ;
H3 = zeros(size(S,1),4) ;
    for i=1:size(S,1)    
        Si=S(i,:); 
        fill3(H(1,Si),H(2,Si),H(3,Si),cube_color,'facealpha',1)
    end
%axis equal, hold off, view(20,10)
end