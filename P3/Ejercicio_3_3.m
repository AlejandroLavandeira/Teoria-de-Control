% --- Práctica 3: Validación del Paso 4 ---
% Diseño del Compensador PI y Sistema PID
clear; clc; close all;

% 1. Planta y polos deseados
numF = 15;
denF = [1 10 27 18];
F = tf(numF, denF);
sd = -2 + 3.904i;

% 2. Parámetros del compensador
zc_pd = 6;
zc_pi = 0.1;
K_total = 1.0938;

% 3. Funciones de transferencia de los controladores
C_PD_solo = tf([1 zc_pd], 1); 
C_PI_solo = tf([1 zc_pi], [1 0]);

% Controlador PID Total (K_total * PD * PI)
C_PID = K_total * series(C_PD_solo, C_PI_solo);

% 4. Sistema compensado en lazo abierto y cerrado
L_PID = series(C_PID, F);
T_PID = feedback(L_PID, 1);

% 5. Comprobación del Lugar de las Raíces con el PID
figure('Name', 'Validación PI y PID Completo');
subplot(1,2,1);
rlocus(L_PID); hold on;
plot(real(sd), imag(sd), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Lugar de las Raíces con Compensador PID');
axis([-8 2 -5 5]);

% 6. Comparativa de Respuesta al Escalón (PD vs PID)
% Recalculamos el T_PD del paso anterior para comparar
C_PD_previo = 1.0827 * C_PD_solo;
T_PD = feedback(series(C_PD_previo, F), 1);

subplot(1,2,2);
step(T_PD, 'b--', T_PID, 'g-', 4);
title('Respuesta al Escalón');
legend('Solo con PD (Error en EE)', 'Con PID (Error Nulo)', 'Location', 'SouthEast');
grid on;

% 7. Verificación numérica
disp('Polos en lazo cerrado con PID:');
pole(T_PID)