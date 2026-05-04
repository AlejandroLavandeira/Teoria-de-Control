% --- 5.2.1 Cuestión 1: Matriz de Controlabilidad y Observabilidad ---

% a) Usando las funciones integradas de MATLAB
Co_func = ctrb(A, B);
Ob_func = obsv(A, C);

disp('--- Matrices usando funciones de MATLAB ---');
disp('Matriz de Controlabilidad (ctrb):');
disp(Co_func);
disp('Matriz de Observabilidad (obsv):');
disp(Ob_func);

% b) Calculando con operaciones básicas de matrices (n = 3)
Co_manual = [B, A*B, (A^2)*B];
Ob_manual = [C; C*A; C*(A^2)];

disp('--- Matrices calculadas manualmente ---');
disp('Matriz de Controlabilidad manual:');
disp(Co_manual);
disp('Matriz de Observabilidad manual:');
disp(Ob_manual);

% Comprobación de que son exactamente iguales
error_Co = norm(Co_func - Co_manual);
error_Ob = norm(Ob_func - Ob_manual);
fprintf('Error entre cálculo de controlabilidad: %e\n', error_Co);
fprintf('Error entre cálculo de observabilidad: %e\n', error_Ob);


% --- 5.2.1 Cuestión 2: Evaluación del sistema ---
% El sistema es controlable/observable si el rango de la matriz es igual a n (3)
n_estados = size(A, 1);
rango_Co = rank(Co_func);
rango_Ob = rank(Ob_func);

fprintf('\n--- Evaluación del Sistema ---\n');
fprintf('Orden del sistema (n): %d\n', n_estados);
fprintf('Rango de la matriz de Controlabilidad: %d\n', rango_Co);

if rango_Co == n_estados
    disp('-> El sistema es COMPLETAMENTE CONTROLABLE.');
else
    disp('-> El sistema NO es completamente controlable.');
end

fprintf('Rango de la matriz de Observabilidad: %d\n', rango_Ob);

if rango_Ob == n_estados
    disp('-> El sistema es COMPLETAMENTE OBSERVABLE.');
else
    disp('-> El sistema NO es completamente observable.');
end