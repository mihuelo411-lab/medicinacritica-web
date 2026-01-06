# Flujo Conceptual de NutriVigil (Documentación Viva)

Este documento describe la filosofía y el flujo lógico esperado de la aplicación **NutriVigil**. Sirve como referencia para entender "cómo debe funcionar" el sistema.

## Objetivo
NutriVigil es una herramienta de soporte a la decisión clínica para nutrición crítica. Su objetivo es evitar errores de cálculo (sobrealimentación/infraalimentación) y estandarizar el cuidado según guías (ASPEN/ESPEN).

## Flujo Lógico Paso a Paso

### 1. Ingreso y Antropometría (El Cimiento)
*   **Input**: Peso real, Talla, Edema, Amputaciones.
*   **Lógica Crítica**:
    *   Determinar el **IMC**.
    *   Si IMC > 30 (Obesidad): **OBLIGATORIO** calcular y sugerir Peso Ajustado (o Peso Ideal según el caso).
    *   Si IMC < 30 (Normo/Bajo): Usar Peso Real (salvo edema severo -> Peso Seco).
*   **Resultado (Output)**: **`workWeight` (Peso de Trabajo)**.
    *   *Regla de Oro*: Este `workWeight` es el ÚNICO peso que debe usarse en las pantallas siguientes para calcular dosis y calorías.

### 2. Estado Nutricional y Riesgo
*   **Input**: Pérdida de peso reciente, Ingesta, Severidad de enfermedad (APACHE/SOFA).
*   **Lógica Crítica**:
    *   **Automatización**: Si ya sabemos que es un paciente traumático o séptico (por diagnóstico o APACHE), asumimos "Alto Riesgo" o "Inflamación Severa" sin preguntar de nuevo.
    *   **Escalas**:
        *   **NUTRIC Score** (Gold Standard en UCI): Prioritario si mecánica ventilatoria o APACHE > 20.
        *   **NRS-2002**: Tamizaje general.
        *   **GLIM/ASPEN**: Diagnóstico fenotípico.
*   **Resultado**: Categoría de Riesgo (Alto/Bajo).

### 3. Requerimientos (La Meta)
*   **Input**: `workWeight` (del paso 1).
*   **Fórmulas**:
    *   **Penn State**: Preferida si hay ventilación mecánica.
    *   **Mifflin-St Jeor / Harris-Benedict**: Para pacientes espontáneos.
    *   **Regla de Pulgar (Kcal/kg)**: Simple y efectiva (20-25 kcal/kg).
*   **Error a Evitar**: Usar el Peso Real (120kg) en un paciente obeso para fórmulas lineales. Esto genera metas de >3000 kcal (Peligroso). Se debe usar el Peso Ajustado.

### 4. Plan Diario (La Realidad)
*   **Contexto**: ¿Es el Día 1 o el Día 7?
    *   **Día 1-2 (Fase Aguda)**: Meta permisiva (trófica). No dar el 100% de la meta calculada.
    *   **Día 3+**: Progresar hacia la meta.
*   **Ajuste**: Restar calorías no nutricionales (Propofol, Dextrosa).

## Principios de Diseño
1.  **No redundancia**: No pedir datos que ya se tienen (ej. Triglicéridos, Ventilación).
2.  **Seguridad**: Alertas rojas si la dosis de proteína > 2.5g/kg o calorías > 35 kcal/kg.
3.  **Continuidad**: El dato fluye hacia adelante. El Peso de Trabajo decidido en el paso 1 es ley en el paso 3.
