% --- Cuestión 5: Respuesta ante entrada trapezoidal ---
% 1. Definimos el vector de tiempo (de 0 a 10s con paso fino para buena resolución)
t_trap = 0:0.01:10;

% 2. Inicializamos el vector de entrada con ceros
u_trap = zeros(size(t_trap));

% 3. Construimos la señal por tramos usando indexación lógica
u_trap(t_trap <= 2.5) = 2 * t_trap(t_trap <= 2.5);
u_trap(t_trap > 2.5 & t_trap <= 7.5) = 5;
u_trap(t_trap > 7.5) = -2 * (t_trap(t_trap > 7.5) - 10);

% Condición inicial nula
x0_nula = [0; 0; 0];

% 4. Simulamos usando lsim
[y_trap, t_out_trap, x_trap] = lsim(sys, u_trap, t_trap, x0_nula);

% 5. Representación gráfica
figure('Name', 'Cuestión 5: Respuesta ante Entrada Trapezoidal');

% Subplot para ver la forma de la entrada (siempre es buena práctica verificarla)
subplot(3,1,1);
plot(t_trap, u_trap, 'm', 'LineWidth', 2);
title('Señal de entrada u(t) - Perfil Trapezoidal');
xlabel('Tiempo (s)'); ylabel('Amplitud'); grid on;
ylim([0 6]);

% Subplot para la salida y(t)
subplot(3,1,2);
plot(t_out_trap, y_trap, 'b', 'LineWidth', 1.5);
title('Respuesta de la salida y(t)');
xlabel('Tiempo (s)'); ylabel('Amplitud'); grid on;

% Subplot para la evolución de los estados x(t)
subplot(3,1,3);
plot(t_out_trap, x_trap(:,1), 'r', t_out_trap, x_trap(:,2), 'g', t_out_trap, x_trap(:,3), 'w', 'LineWidth', 1.5);
title('Evolución de los estados x(t)');
xlabel('Tiempo (s)'); ylabel('Amplitud');
legend('x_1(t)', 'x_2(t)', 'x_3(t)', 'Location', 'best'); grid on;