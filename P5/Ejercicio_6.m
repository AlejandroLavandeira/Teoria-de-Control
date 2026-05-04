% --- 5.4 Cuestión 2: Modelo del motor electromecánico (Código Final) ---
disp('--- Creando y simulando modelo electromecánico del Turtlebot ---');

% 1. Parámetros del motor (Sistema Internacional)
Ra = 1.5506;              % Resistencia (Ohmios)
La = 0.00151;             % Inductancia (Henrios)
Kt = 0.010913;            % Constante de par (Nm/A)
Ke = 60 / (830 * 2 * pi); % Constante electromotriz (V/(rad/s))
b  = 2.197e-6;            % Coeficiente de fricción viscosa (Nms/rad)
J  = 1e-5;                % Inercia del rotor (kg*m^2) - Valor típico estimado

% 2. Matrices del Espacio de Estados
A_mot = [-Ra/La, -Ke/La; 
          Kt/J,   -b/J];
B_mot = [1/La; 
          0];
C_mot = [0, 1];           % Queremos observar la velocidad omega (estado 2)
D_mot = 0;

% 3. Creación del modelo LTI
sys_motor = ss(A_mot, B_mot, C_mot, D_mot);

% 4. Simulación ante voltaje nominal (12 V) 
% Seleccionamos t = 1.5s para asegurar que superamos el transitorio mecánico
t_mot = 0:0.001:1.5;     
u_volt = 12 * ones(size(t_mot)); 

[omega_out, t_out, x_mot] = lsim(sys_motor, u_volt, t_mot);

% Conversión de rad/s a RPM para validar con la hoja de características
omega_rpm = omega_out * (60 / (2 * pi));

% 5. Representación Gráfica
figure('Name', 'Dinámica del Motor Turtlebot (12V) - Final');

subplot(2,1,1);
plot(t_out, x_mot(:,1), 'r', 'LineWidth', 1.5);
title('Evolución de la Corriente del Inducido i(t) - Transitorio y Permanente');
xlabel('Tiempo (s)'); ylabel('Corriente (A)'); grid on;

subplot(2,1,2);
plot(t_out, omega_rpm, 'b', 'LineWidth', 1.5);
title('Evolución de la Velocidad Angular \omega(t) - Transitorio y Permanente');
xlabel('Tiempo (s)'); ylabel('Velocidad (RPM)'); grid on;

% 6. Validación por consola del verdadero régimen permanente
fprintf('\n--- Resultados Finales ---\n');
fprintf('Velocidad simulada en régimen permanente: %.2f RPM\n', omega_rpm(end));
fprintf('Velocidad teórica en vacío (datasheet): 9960 RPM\n');
fprintf('Corriente final simulada: %.4f A\n', x_mot(end, 1));
fprintf('Corriente en vacío teórica (datasheet): 0.2100 A\n');