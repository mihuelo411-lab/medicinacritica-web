# uci_management

Proyecto Flutter para la gestión y monitoreo de pacientes UCI.

## SDK local y wrapper `flutterw`

En este entorno no es posible escribir en `/home/guillermo/flutter/bin/cache`, por lo que los comandos `flutter run` y `flutter analyze` fallan con “Permiso denegado”. Se añadió un wrapper (`./flutterw`) que ejecuta una copia local del SDK ubicada en `flutter_sdk/` dentro del proyecto. Así los comandos pueden escribir en el caché sin errores.

### Preparación

1. Copia (o sincroniza periódicamente) el SDK global a la carpeta local:
   ```bash
   rsync -a /home/guillermo/flutter/ ./flutter_sdk
   ```
2. Usa `./flutterw` en lugar de `flutter` para cualquier comando, por ejemplo:
   ```bash
   ./flutterw pub get
   ./flutterw analyze
   ./flutterw run -d chrome
   ```

## Dependencias offline adicionales

- `printing` ahora se resuelve desde `third_party/printing` y reutiliza un binario de PDFium almacenado en `third_party/pdfium`. El wrapper `flutterw` exporta `LOCAL_PDFIUM_DIR` automáticamente para que el plugin use ese recurso local en Linux.
- `sqlite3_flutter_libs` también se resuelve desde `third_party/sqlite3_flutter_libs`. En Linux se compila solo un “stub” del plugin, evitando descargar el código fuente de SQLite (se usará la biblioteca del sistema en tiempo de ejecución).

## Despliegue Web (GitHub Pages)

El sitio público se sirve desde la carpeta `docs/` usando GitHub Pages. Para evitar pantallas en blanco:

- Compila siempre con `./flutterw build web --release --base-href /medicinacritica-web/ -o docs` para que `<base href>` apunte al subdirectorio correcto dentro de `mihuelo411-lab.github.io`.
- **No borres `docs/.nojekyll`**. Sin ese archivo, Pages intenta procesar el build con Jekyll y omite assets como `main.dart.js`, dejando el sitio sin contenido aunque el deploy sea exitoso.

## Sesión e inactividad

- Toda la app se controla a través de `AuthGate` ( `lib/features/auth/presentation/auth_gate.dart` ). Aquí se inicia un temporizador global de inactividad (`_sessionTimeout`, por defecto 15 min). El temporizador se reinicia automáticamente con cada interacción de puntero (`Listener` global) y se cancela al cerrar sesión.
- Cuando el temporizador expira, `_handleSessionTimeout()` llama a `signOut()` y setea un `infoMessage`. Ese mensaje se muestra en `LoginScreen` para notificar al usuario que su sesión se cerró por inactividad.
- Si alguna vez cambia el tiempo deseado, basta modificar la constante `_sessionTimeout`.

## OAuth con Google (opcional)

- El botón “Continuar con Google” sólo se muestra si `SupabaseCredentials.enableGoogleOAuth` está en `true`.
- Mantén ese flag en `false` mientras el proveedor no esté activado desde el panel de Supabase; de lo contrario, Supabase responderá con `Unsupported provider`.
- Una vez habilites Google en tu proyecto y copies los IDs/secretos requeridos, cambia el flag a `true` para reactivar el botón.

## Getting Started

Resources para aprender Flutter:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

Para más detalles sobre Flutter, consulta la [documentación oficial](https://docs.flutter.dev/).
