% --- Cuestión 6: Función de transferencia y comprobación ---
% 1. Obtención de la función de transferencia a partir del espacio de estados
systf = tf(sys);
disp('La función de transferencia obtenida es:');
systf

% 2. Cálculo de la respuesta al escalón del modelo systf
[y_tf, t_tf] = step(systf);

% 3. Representación gráfica comparativa
figure('Name', 'Cuestión 6: Comparación de Modelos');

% Dibujamos la respuesta original de la Cuestión 2 (sys) con una línea gruesa
plot(t, y, 'b-', 'LineWidth', 4); 
hold on;
% Superponemos la respuesta de la función de transferencia (systf) con línea discontinua
plot(t_tf, y_tf, 'r--', 'LineWidth', 2);

title('Comprobación de Respuesta al Escalón: Estados vs. Transferencia');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Modelo de Estados (sys)', 'Función de Transferencia (systf)', 'Location', 'best');
grid on;
hold off;