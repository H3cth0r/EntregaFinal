clear;
clc;

xi=-1;   yi=-7;
xf=3;    yf=13;
x1 = 1;  y1 = -5;
x2 = 2;  y2 = -4;

xx = [xi; x1; x2; xf];
yy = [yi; y1; y2; yf];

%plot(xx, yy);

x = xi:xf;

m = [xi^3 xi^2 xi 1;
     x1^3 x1^2 x1 1;
     x2^3 x2^2 x2 1;
     xf^3 xf^2 xf 1];
 
cofs = m \ yy;
a = cofs(1)
b = cofs(2)
c = cofs(3)
d = cofs(4)

f = @(x) (a*(x.^3)) + (b*(x.^2)) + (c*(x)) + (d);
fplot(f, [xi xf]);
hold on;
%plot(x,f(x));

fdt =  @(x) (a*(3*x.^2)) + (b*(2*x)) + c;
f2dt = @(x) 6*a*x + 2*b;
lfdt = @(x) sqrt((1+ fdt(x)).^2);

syms x
% Min N Max points
primeraD = (a*(3*x.^2)) + (b*(2*x)) + c;
answer = solve( primeraD == 0, x, 'MaxDegree', 3);
resultado = vpa(answer,6);
sprintf("Max: %s , %s", resultado(1), f(resultado(1)))
plot(resultado(1), f(resultado(1)), '.');
text(resultado(1), f(resultado(1)), '\leftarrow Max')
sprintf("Min: %s, %s", resultado(2), f(resultado(2)))
plot(resultado(2), f(resultado(2)), '.')
text(resultado(2), f(resultado(2)), '\leftarrow Min')

% Inflection point
segundaD = 6*a*x + 2*b;
answer2 = vpasolve(segundaD == 0, x, [-inf, inf]);
sprintf("Inflection: %s , %s", answer2(1), f(answer2(1)))
plot(answer2(1), f(answer2(1)), '.');
text(answer2(1), f(answer2(1)), '\leftarrow Inflection')

% Track length
longitud_pista = integral(lfdt, xi, xf);
disp("Longitud de la pista: " + longitud_pista);

% Radius of curvature
valores = radiocurvatura(resultado(1), f(resultado(1)), fdt(resultado(1)), f2dt(resultado(1)));
plotcircle(valores(2), valores(3), valores(1));
plot(valores(2), valores(3), '.');
sprintf("Radio Curvatura Max: %s and %s",valores(2), valores(3))

valores_dos = radiocurvatura(resultado(2), f(resultado(2)), fdt(resultado(2)), f2dt(resultado(2)));
plotcircle(valores_dos(2), valores_dos(3), valores_dos(1));
plot(valores_dos(2), valores_dos(3), '.');
sprintf("Radio Curvatura Min: %s and %s",valores_dos(2), valores_dos(3))
axis equal;
axis([-20 20 -20 20])

% rc_inflection = radiocurvatura(answer2(1), f(answer2(1)),fdt(answer2(1)), f2dt(answer2(1)));
% sprintf("Radio Curvatura Punto Inflexión: %s", rc_inflection(1))
%daspect manual;

%% Functions 
function h = plotcircle(xs,ys,r)
    th = 0:pi/50:2*pi;
    xunit = r*cos(th) + xs;
    yunit = r*sin(th) + ys;
    h = plot (xunit, yunit);
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