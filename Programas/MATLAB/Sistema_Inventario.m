clc;
clear;
close all;

disp('==========================================');
disp('       SIMULACION DE INVENTARIO');
disp('==========================================');

% Datos iniciales
inventario = 100;
dias = 30;
minimo = 20;
pedido = 80;

% Arreglos para guardar resultados
existencias = zeros(1, dias);
ventas = zeros(1, dias);

% Simulación
for dia = 1:dias

    % Generar ventas aleatorias
    venta = randi([5 25]);

    % Evitar que el inventario sea negativo
    if venta > inventario
        venta = inventario;
    end

    inventario = inventario - venta;

    % Reabastecimiento
    if inventario <= minimo
        inventario = inventario + pedido;
        fprintf('Dia %d: Se realizo un nuevo pedido.\n', dia);
    end

    % Guardar datos
    ventas(dia) = venta;
    existencias(dia) = inventario;
end

% Mostrar resultados
fprintf('\n========== RESULTADOS ==========\n');

for dia = 1:dias
    fprintf('Dia %2d | Ventas: %2d | Existencias: %3d\n', ...
        dia, ventas(dia), existencias(dia));
end

% Grafica
figure;

plot(1:dias, existencias, '-o', 'LineWidth', 2);

grid on;

title('Simulacion del inventario durante 30 dias');
xlabel('Dias');
ylabel('Cantidad de productos');

hold on;

yline(minimo, '--', 'Nivel minimo');

legend('Existencias', 'Nivel minimo');

hold off;