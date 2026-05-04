% --- Práctica 3: Validación del Paso 3 ---
% Diseño del Compensador PD
clear; clc; close all;

% 1. Definición de la Planta y Polos deseados
numF = 15;
denF = [1 10 27 18];
F = tf(numF, denF);
sd = -2 + 3.904i;

% 2. Parámetros del PD calculados analíticamente
zc = 6;
K_pd = 1.0827;
C_PD = tf(K_pd * [1 zc], 1);

% 3. Sistema compensado en lazo abierto y cerrado
L_PD = C_PD * F;
T_PD = feedback(L_PD, 1);
T_uncomp = feedback(F, 1); % Para comparar

% 4. Comprobación del Lugar de las Raíces con el PD
figure('Name', 'Validación PD');
subplot(1,2,1);
rlocus(L_PD); hold on;
plot(real(sd), imag(sd), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Lugar de las Raíces con Compensador PD');
axis([-8 2 -5 5]);

% 5. Comparativa de Respuesta al Escalón
subplot(1,2,2);
step(T_uncomp, 'r--', T_PD, 'b-', 4);
title('Respuesta al Escalón');
legend('Sin Compensar (K=1)', 'Compensado (PD)', 'Location', 'SouthEast');
grid on;

% 6. Verificación numérica de polos
disp('Polos en lazo cerrado con PD (deberían coincidir con -2 +/- 3.904i):');
pole(T_PD)