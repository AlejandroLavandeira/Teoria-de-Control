#ifndef PID_CONTROLLER_H
#define PID_CONTROLLER_H

#include <Arduino.h>

// Enumeración para elegir el tipo de algoritmo basado en tu PDF
enum PID_Algorithm {
    ALGO_STANDARD,   // Aproximación por diferencias finitas clásica (Ec 4.6)
    ALGO_IIR,        // Implementación tipo PLC/FPGA (Ec 4.8)
    ALGO_FILTERED    // Derivada con filtro pasa baja (Ec 4.10)
};

class PID_Controller {
private:
    // Parámetros de sintonía
    float Kp, Ki, Kd;
    float dt;
    
    // Parámetros del filtro pasa baja (para ALGO_FILTERED)
    int N;
    float tau, alpha, alpha_1, alpha_2;

    // Constantes precalculadas para ALGO_IIR y ALGO_FILTERED
    float A0, A1, A2;
    float A0d, A1d, A2d;

    // Variables de estado (memoria del sistema discreto Z^-1, Z^-2)
    float error[3];      // error[0] = e(k), error[1] = e(k-1), error[2] = e(k-2)
    float integral;      // Acumulador para ALGO_STANDARD
    float prev_output;   // u(k-1)
    
    // Variables de estado para el filtro derivativo
    float d0, d1;
    float fd0, fd1;

    // Límites de saturación (Anti-Windup)
    float outMin, outMax;
    
    // Algoritmo seleccionado
    PID_Algorithm current_algo;

    // Métodos privados internos
    void precalculateConstants();

public:
    // Constructor
    PID_Controller(float kp, float ki, float kd, float dt, PID_Algorithm algo = ALGO_STANDARD);

    // Inicialización y configuración
    void begin();
    void setTunings(float kp, float ki, float kd);
    void setOutputLimits(float min, float max);
    void setFilterCoefficient(int n); // Configurar 'N' para el filtro pasa baja

    // Bucle de cómputo principal
    float compute(float setpoint, float measured_value);
    
    // Resetear variables de estado (útil si el péndulo se cae y se levanta)
    void reset();
};

#endif // PID_CONTROLLER_H