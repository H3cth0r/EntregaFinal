clear;
clc;

xi=30;
yi=230;
xf=260;
yf=80;
x1 = 100;
y1 = 100;
x2 = 180;
y2 = 270;

xx = [xi; x1; x2; xf];
yy = [yi; y1; y2; yf];

%plot(xx, yy);

x = xi:xf;

m = [xi^3 xi^2 xi 1;
     x1^3 x1^2 x1 1;
     x2^3 x2^2 x2 1;
     xf^3 xf^2 xf 1];
 
cofs = m \ yy;
a = cofs(1);
b = cofs(2);
c = cofs(3);
d = cofs(4);

f = @(x) (a * (x.^3)) + (b * (x.^2)) + (c*x) + d;
y = f(x);

plot(x, y);

fdt =  @(x) (a*(3*x.^2)) + (b*(2*x)) + c;
f2dt = @(x) 6*a*x + 2*b;
lfdt = @(x) sqrt((1+ fdt(x)).^2);

longitud_pista = integral(lfdt, xi, xf);
pendientes = fdt(x);
concavidades = f2dt(x);

radio_curva = abs(   sqrt(   (  1  + (fdt(100)).^2   ).^3   )   /  (f2dt(100)) );
radio_curva_dos = abs(   sqrt(   (  1  + (fdt(180)).^2   ).^3   )   /  (f2dt(180)) );


disp("Longitud de Pista: " + longitud_pista);
disp("Radio de Curvatura 1: " + radio_curva)
disp("Radio de Curvatura 2: " + radio_curva_dos)
disp("Concavidades x= 100: " + concavidades(100));
disp("Concavidades x= 180: " + concavidades(180));

close all;
%set(gcf, 'Position', get(0, 'Screensize')); 
figure(1);
hold on;
grid on;
text(xi-10,yi,'Inicio \rightarrow'); 
text(xf,yf,'\leftarrow Fin');
plot(x,y,'LineWidth',10,'color','k');
plot(x,y,'LineStyle','--', 'color','w');

% codigo del auto


syms x
% Puntos maximo y minimos
primeraD = (a*(3*x.^2)) + (b*(2*x)) + c;
answer = solve( primeraD == 0, x, 'MaxDegree', 3);
resultado = vpa(answer,6);

% Puntos inflexion
segundaD = 6*a*x + 2*b;
answer2 = vpasolve(segundaD == 0, x, [-inf, inf]) ;
%resultado2= ;

disp(resultado(1));
disp(f(resultado(1)));
disp(resultado(2));
disp(f(resultado(2)));

disp(answer2);
disp(f(answer2));

ye = f(resultado(1));
ya = f(resultado(2));
plot(resultado(1), ye, "*");
plot(resultado(2), ya, "*");

yo = f(answer2);
plot(answer2,yo, "*" );
