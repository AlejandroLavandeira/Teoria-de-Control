#include <Arduino.h>
#include "PID_Controller.h"

// --- Parámetros del Sistema Discreto ---
const float dt_seconds = 0.01;                 // Periodo de muestreo (10 ms)
const unsigned long dt_micros = 10000;         // Mismo periodo en microsegundos
unsigned long last_time = 0;                   // Memoria de tiempo para el bucle

// --- Instanciación del Controlador PID ---
// Usamos ALGO_FILTERED por defecto: es el más seguro contra el ruido del acelerómetro/giroscopio
PID_Controller pid(15.0, 2.5, 0.8, dt_seconds, ALGO_FILTERED);

// --- Funciones Simuladas (Debes reemplazarlas con tu hardware real) ---
float readInclinometer() {
    // Aquí iría el código para leer el MPU6050 y calcular el ángulo (ej. filtro de Kalman o Mahony)
    // Retorna el ángulo en grados. (0.0 significa perfectamente vertical)
    return 0.0; 
}

void driveMotor(float pwm_value) {
    // Aquí iría el código para escribir el PWM hacia los drivers L298N, DRV8825, etc.
    // pwm_value será un número entre -255.0 y 255.0
    /*
    if (pwm_value > 0) {
        digitalWrite(DIR_PIN, HIGH);
        ledcWrite(PWM_CHANNEL, abs(pwm_value));
    } else {
        digitalWrite(DIR_PIN, LOW);
        ledcWrite(PWM_CHANNEL, abs(pwm_value));
    }
    */
}

void setup() {
    Serial.begin(115200);
    
    // Configuración inicial del PID
    pid.setOutputLimits(-255.0, 255.0); // Rango típico de PWM de 8 bits
    pid.setFilterCoefficient(5);        // N=5 para el filtro pasa baja derivativo
    pid.begin();                        // Reinicia estados y precalcula constantes
    
    Serial.println("Sistema ESP32 Inicializado. Esperando estabilización de sensores...");
    delay(2000); // Tiempo para que el MPU6050 se estabilice
    
    last_time = micros(); // Iniciar cronómetro de control
}

void loop() {
    unsigned long current_time = micros();
    
    // Evaluar si ya transcurrió exactamente dt
    if (current_time - last_time >= dt_micros) {
        // Truco de Arquitecto Senior: Sumar el intervalo esperado en lugar de asignar = current_time.
        // Esto evita que los pequeños retrasos de procesamiento se acumulen con el tiempo (drift).
        last_time += dt_micros; 
        
        // 1. LEER ESTADO DE LA PLANTA
        float current_angle = readInclinometer();
        
        // 2. CALCULAR SEÑAL DE CONTROL
        // Setpoint = 0.0 (queremos el péndulo perfectamente recto)
        float setpoint = 0.0; 
        float control_signal = pid.compute(setpoint, current_angle);
        
        // 3. ACTUAR SOBRE LA PLANTA
        driveMotor(control_signal);
        
        // (Opcional) Debug - Descomentar solo para sintonizar, imprimir texto consume mucho tiempo
        // Serial.printf("Ang: %.2f | PWM: %.2f\n", current_angle, control_signal);
    }
    
    // Fuera del `if`, el microcontrolador está libre para hacer otras tareas no bloqueantes
    // (ej. actualizar una pantalla OLED, chequear WiFi, etc.)
}