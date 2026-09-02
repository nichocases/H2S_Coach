# Inline Hockey Coach

Monorepo para construir Inline Hockey Coach mediante Spec-Driven Design: app móvil Flutter offline-first para entrenadores de hockey sobre patines en línea y backend FastAPI con PostgreSQL.

## Objetivo del MVP

Permitir que un entrenador configure un partido, registre acciones de jugadores y arquero en tiempo real, consulte un resumen y sincronice los eventos automáticamente cuando exista conexión.

## Instrucciones de Despliegue y Desarrollo (Arranque en Frío)

1. **Clonar y configurar el entorno local:**
   Asegúrate de copiar `.env.example` a `.env` en la raíz del proyecto.
   ```bash
   cp .env.example .env
   ```

2. **Levantar el Backend (Base de datos y API):**
   Usa Docker Compose para arrancar PostgreSQL y la API en FastAPI.
   ```bash
   docker compose up --build -d
   ```
   La API estará disponible en `http://localhost:8000`. Puedes ver la documentación en `http://localhost:8000/docs`.

3. **Arrancar la App Móvil (o Web):**
   Asegúrate de tener Flutter instalado y configurado.
   
   *Para ejecutar en simulador o dispositivo móvil:*
   ```bash
   cd apps/mobile
   flutter pub get
   flutter run
   ```

   *Para ejecutar la versión Web localmente (Chrome):*
   ```bash
   cd apps/mobile
   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
   ```
   > **Nota sobre la Web:** La versión web soporta funcionamiento "offline-first". La base de datos SQLite se ejecuta directamente en el navegador utilizando WebAssembly (`sql-wasm.wasm`).

4. **Compilar para Producción:**
   Para Android (Genera un APK en `build/app/outputs/flutter-apk/app-release.apk`):
   ```bash
   cd apps/mobile
   flutter build apk
   ```
   Para iOS (Requiere macOS y Xcode):
   ```bash
   cd apps/mobile
   flutter build ios --no-codesign
   ```
   Para Web (Genera archivos estáticos en `build/web/` listos para desplegar):
   ```bash
   cd apps/mobile
   flutter build web --dart-define=API_BASE_URL=https://tu-api.com
   ```

## Estructura

```text
apps/mobile   App Flutter
apps/api      API FastAPI
contracts     Contratos públicos OpenAPI
specs         Fuente de verdad funcional y técnica
tests         Escenarios de aceptación
```

## Pruebas (Automáticas y Manuales)

- **Frontend (Flutter):** 
  ```bash
  cd apps/mobile && flutter test
  ```
- **Backend (Python):** 
  ```bash
  docker compose run --rm --no-deps api pytest
  ```

## Entregables del repositorio final

- Aplicación móvil ejecutable en iOS y Android.
- API documentada en `/docs`.
- Migraciones de base de datos.
- Datos de demostración.
- Pruebas unitarias, integración y aceptación completas.
