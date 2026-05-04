% --- Práctica 3: Validación del Paso 5 ---
% Extracción e Implementación del Controlador PID
clear; clc; close all;

% 1. Planta original
numF = 15;
denF = [1 10 27 18];
F = tf(numF, denF);

% 2. Parámetros calculados analíticamente
Kp = 6.6722;
Ki = 0.6563;
Kd = 1.0938;

% 3. Construcción del controlador usando las constantes
C_PID_final = tf([Kd Kp Ki], [1 0]);

% 4. Sistema en lazo cerrado
T_PID_final = feedback(series(C_PID_final, F), 1);

% 5. Validación final mediante Respuesta al Escalón
figure('Name', 'Validación Final PID');
step(T_PID_final, 'm-', 4);
title('Respuesta al Escalón Final (PID Sintonizado Analíticamente)');
grid on;
xlabel('Tiempo (segundos)');
ylabel('Amplitud');

% 6. Información en consola de los polos
disp('Polos finales en lazo cerrado (deben ser idénticos al Paso 4):');
pole(T_PID_final)