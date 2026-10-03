% BANCO DE EJERCICIOS - SIMULACION DE PROYECTILES

clc;
clear;
close all;

% Gravedad
g = 9.81;

% Generar datos aleatorios para cada ejercicio
v0 = randi([20, 50]);       % Velocidad entre 20 y 50 m/s
angulo = randi([20, 70]);   % Angulo entre 20 y 70 grados

% Convertir grados a radianes
theta = deg2rad(angulo);

% Calcular tiempo total de vuelo
tiempo_total = (2 * v0 * sin(theta)) / g;

% Crear intervalo de tiempo
t = linspace(0, tiempo_total, 200);

% Calcular posiciones
x = v0 * cos(theta) .* t;
y = v0 * sin(theta) .* t - (g * t.^2) / 2;

% Calcular resultados
alcance = max(x);
altura_maxima = max(y);

% Mostrar datos del ejercicio
fprintf('\n========================================\n');
fprintf('       BANCO DE EJERCICIOS\n');
fprintf('     SIMULACION DE PROYECTILES\n');
fprintf('========================================\n\n');

fprintf('Velocidad inicial: %d m/s\n', v0);
fprintf('Angulo de lanzamiento: %d grados\n', angulo);
fprintf('Tiempo de vuelo: %.2f segundos\n', tiempo_total);
fprintf('Altura maxima: %.2f metros\n', altura_maxima);
fprintf('Alcance aproximado: %.2f metros\n', alcance);

% Graficar trayectoria
figure;

plot(x, y, 'LineWidth', 2);

grid on;

xlabel('Distancia horizontal (m)');
ylabel('Altura (m)');

title(sprintf('Trayectoria del proyectil - %d m/s - %d grados', ...
    v0, angulo));

% Marcar punto de altura máxima
hold on;
plot(x(y == max(y)), max(y), 'o', 'MarkerSize', 8);

hold off;