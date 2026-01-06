# NutriVigil (beta)

Aplicación Flutter para apoyo en el tratamiento y seguimiento nutricional de pacientes críticos. Esta versión inicial funciona offline en un único dispositivo Android.

## Módulos previstos
- Gestión de pacientes: alta, edición, historial.
- Calculadoras antropométricas y de requerimientos energéticos (Harris-Benedict, Penn State, Mifflin St Jeor).
- Registro diario de parámetros clínicos y analíticos.
- Alertas locales por datos faltantes y desviaciones nutricionales.
- Reportes exportables con gráficas de tendencia.

## Estado actual
- Base de datos local con Drift (pacientes, objetivos, monitoreo, alertas) y repositorios concretos.
- Gestión de pacientes con formularios reactivos, listado, y navegación a seguimiento diario.
- Registro diario con pestañas de tabla y gráficas de tendencia, formulario para nuevos registros.
- Calculadoras de peso ideal/ajustado y requerimiento energético con opción de guardar objetivos calórico-proteicos.
- Motor de alertas clínicas y notificaciones locales para recordatorios según reglas básicas.
- Generación de reportes PDF con resumen antropométrico y registros diarios, accesibles desde la app.

## Próximos pasos sugeridos
1. Ejecutar `flutter pub get` y luego `flutter pub run build_runner build --delete-conflicting-outputs` para generar los archivos `*.g.dart` de Drift/Freezed.
2. Crear casos de uso adicionales (p. ej. cierre de alertas, sincronización futura) y cubrir los BLoCs con pruebas.
3. Afinar diseño visual, validaciones clínicas y fórmulas según protocolos del centro.
4. Añadir autenticación y cifrado de base de datos antes de desplegar fuera del entorno beta.
