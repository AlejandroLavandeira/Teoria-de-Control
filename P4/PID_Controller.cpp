#include "PID_Controller.h"

// Constructor
PID_Controller::PID_Controller(float kp, float ki, float kd, float dt, PID_Algorithm algo) {
    this->Kp = kp;
    this->Ki = ki;
    this->Kd = kd;
    this->dt = dt;
    this->current_algo = algo;
    
    // Valores por defecto
    this->N = 5; 
    this->outMin = -255.0; // Asumiendo un PWM estándar de 8 bits para Arduino/ESP32
    this->outMax = 255.0;
    
    reset();
    precalculateConstants();
}

// Inicialización
void PID_Controller::begin() {
    reset();
    precalculateConstants();
}

// Resetear memoria del controlador (importante si el péndulo se cae y reinicias el control)
void PID_Controller::reset() {
    error[0] = 0.0;
    error[1] = 0.0;
    error[2] = 0.0;
    integral = 0.0;
    prev_output = 0.0;
    
    d0 = 0.0; d1 = 0.0;
    fd0 = 0.0; fd1 = 0.0;
}

// Actualizar sintonía al vuelo
void PID_Controller::setTunings(float kp, float ki, float kd) {
    this->Kp = kp;
    this->Ki = ki;
    this->Kd = kd;
    precalculateConstants();
}

// Configurar límites del actuador (PWM, Voltaje, etc.)
void PID_Controller::setOutputLimits(float min, float max) {
    if (min >= max) return;
    this->outMin = min;
    this->outMax = max;
}

// Configurar el coeficiente del filtro pasa baja
void PID_Controller::setFilterCoefficient(int n) {
    this->N = n;
    precalculateConstants();
}

// Precálculo de constantes para ahorrar CPU en el ESP32
void PID_Controller::precalculateConstants() {
    if (dt <= 0.0) return; // Protección contra división por cero

    if (current_algo == ALGO_IIR) {
        // Ecuaciones 4.7 y pseudocódigo 4.1.2 del PDF
        A0 = Kp + Ki * dt + Kd / dt;
        A1 = -Kp - 2.0 * Kd / dt;
        A2 = Kd / dt;
    } 
    else if (current_algo == ALGO_FILTERED) {
        // Pseudocódigo 4.1.3 del PDF
        A0 = Kp + Ki * dt;
        A1 = -Kp;
        
        A0d = Kd / dt;
        A1d = -2.0 * Kd / dt;
        A2d = Kd / dt;
        
        tau = Kd / (Kp * N); 
        alpha = dt / (2.0 * tau);
        alpha_1 = alpha / (alpha + 1.0);
        alpha_2 = (alpha - 1.0) / (alpha + 1.0);
    }
}

// Bucle principal de control (Debe ejecutarse exactamente cada 'dt' segundos)
float PID_Controller::compute(float setpoint, float measured_value) {
    // 1. Desplazar errores en el tiempo (z^-1, z^-2)
    error[2] = error[1];
    error[1] = error[0];
    
    // 2. Calcular error actual
    error[0] = setpoint - measured_value;
    
    float output = 0.0;

    // 3. Ejecutar algoritmo seleccionado
    switch (current_algo) {
        case ALGO_STANDARD: {
            // Pseudocódigo 4.1.1
            integral += error[0] * dt;
            
            // Protección Anti-Windup básica en la integral
            // (Evita que la integral crezca hasta el infinito si el motor se atasca)
            float max_integral = outMax / (Ki + 0.0001); // Prevenir div/0
            if (integral > max_integral) integral = max_integral;
            else if (integral < -max_integral) integral = -max_integral;

            float derivative = (error[0] - error[1]) / dt;
            output = Kp * error[0] + Ki * integral + Kd * derivative;
            break;
        }
        
        case ALGO_IIR: {
            // Pseudocódigo 4.1.2
            output = prev_output + A0 * error[0] + A1 * error[1] + A2 * error[2];
            break;
        }
        
        case ALGO_FILTERED: {
            // Pseudocódigo 4.1.3
            // Acción PI
            float pi_output = A0 * error[0] + A1 * error[1];
            
            // Acción D filtrada
            d1 = d0;
            d0 = A0d * error[0] + A1d * error[1] + A2d * error[2];
            
            fd1 = fd0;
            fd0 = alpha_1 * (d0 + d1) - alpha_2 * fd1;
            
            output = prev_output + pi_output + fd0;
            break;
        }
    }

    // 4. Saturación de la salida (Límites físicos del motor)
    if (output > outMax) output = outMax;
    else if (output < outMin) output = outMin;

    // 5. Guardar salida actual para el próximo ciclo (u_k-1)
    // NOTA: Guardamos la salida YA SATURADA. Esto es otra forma de mitigar el windup en algoritmos IIR.
    prev_output = output;

    return output;
}