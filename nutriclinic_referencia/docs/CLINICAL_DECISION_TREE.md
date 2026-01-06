# Árbol de Decisiones Clínicas de NutriVigil

Este diagrama representa la lógica "inteligente" que hemos implementado en la aplicación, convirtiéndola en un verdadero Sistema de Soporte a la Decisión Clínica (CDSS).

```mermaid
graph TD
    Start[Inicio: Datos del Paciente] --> A{¿Hemodinámia?}
    
    %% Rama de Inestabilidad
    A -- Inestable/ECMO/Vasopresores Altos --> B[Ruta: Trófica o NPT]
    B --> B1{¿Fallo Intestinal?}
    B1 -- Sí (Vómitos/Distensión) --> NPT[ALERTA: Sugerir NPT]
    B1 -- No --> Trophic[Nutrición Trófica 10-20ml/h]
    
    A -- Estable --> C{¿Riesgo Realimentación?}
    
    %% Rama de Realimentación
    C -- Sí (IMC < 16) --> ReFeed[Protocolo: Iniciar al 25%]
    C -- No --> D{¿Propofol?}
    
    %% Rama de Propofol
    D -- Sí --> PropCalc[Restar Calorías de Propofol (1.1 kcal/ml)]
    PropCalc --> E
    D -- No --> E{¿Falla Renal?}
    
    %% Rama Renal
    E -- Sí --> Renal[Filtrar Fórmulas Renales + Restringir Proteína]
    Renal --> F
    E -- No --> F{¿Tolerancia Gástrica?}
    
    %% Rama de Tolerancia
    F -- Residuo Medio/Intolerancia Leve --> Hypo[Hipocalórica Progresiva 50%]
    F -- Buena Tolerancia --> Full[Meta Completa 100%]
    
    %% Convergencia
    NPT --> Report[Reporte: Aviso NPT]
    Trophic --> Report[Reporte: Meta Trófica]
    ReFeed --> Report[Reporte: Alerta Realimentación]
    Hypo --> Selector[Selector de Fórmulas]
    Full --> Selector
    
    Selector --> Prescription[Cálculo de Botellas/Latas]
    Prescription --> FinalPDF[PDF Final + Sugerencia Exámenes]
```

## Nodos de Inteligencia
1.  **Guardián de Seguridad**: Detecta inestabilidad y bloquea la alimentación agresiva.
2.  **Calculadora Metabólica**: Ajusta automáticamente por Propofol y Peso.
3.  **Selector Vademécum**: Filtra productos según patología (Renal/Diabetes).
4.  **Asistente de Laboratorio**: Sugiere exámenes faltantes basados en la condición actual.
