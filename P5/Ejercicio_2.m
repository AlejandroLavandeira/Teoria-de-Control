% Definición del vector de condiciones iniciales
x0 = [0; 5; -1];

% --- Cuestión 3: Respuesta con entrada nula y condiciones iniciales ---
% La función 'initial' evalúa la respuesta libre del sistema
[y_init, t_init, x_init] = initial(sys, x0);

figure('Name', 'Cuestión 3: Respuesta Libre (Condiciones Iniciales)');
subplot(2,1,1);
plot(t_init, y_init, 'b', 'LineWidth', 1.5);
title('Respuesta y(t) ante x_0 = [0, 5, -1] y u(t) = 0');
xlabel('Tiempo (s)'); ylabel('Amplitud'); grid on;

subplot(2,1,2);
plot(t_init, x_init(:,1), 'r', t_init, x_init(:,2), 'g', t_init, x_init(:,3), 'k', 'LineWidth', 1.5);
title('Evolución de los estados x(t)');
xlabel('Tiempo (s)'); ylabel('Amplitud');
legend('x_1(t)', 'x_2(t)', 'x_3(t)', 'Location', 'best'); grid on;

% --- Cuestión 4: Respuesta con entrada escalón y condiciones iniciales ---
% Definimos un vector de tiempo adecuado (basado en t_init de la simulación anterior)
t_sim = t_init;
% Definimos la entrada escalón (vector de unos del mismo tamaño que el tiempo)
u_step = ones(size(t_sim));

% Usamos 'lsim' para simular entrada arbitraria + condiciones iniciales
[y_lsim, t_lsim, x_lsim] = lsim(sys, u_step, t_sim, x0);

figure('Name', 'Cuestión 4: Respuesta Completa (Escalón + Cond. Iniciales)');
subplot(2,1,1);
plot(t_lsim, y_lsim, 'b', 'LineWidth', 1.5);
title('Respuesta y(t) ante escalón unitario y x_0 = [0, 5, -1]');
xlabel('Tiempo (s)'); ylabel('Amplitud'); grid on;

subplot(2,1,2);
plot(t_lsim, x_lsim(:,1), 'r', t_lsim, x_lsim(:,2), 'g', t_lsim, x_lsim(:,3), 'w', 'LineWidth', 1.5);
title('Evolución de los estados x(t)');
xlabel('Tiempo (s)'); ylabel('Amplitud');
legend('x_1(t)', 'x_2(t)', 'x_3(t)', 'Location', 'best'); grid on;