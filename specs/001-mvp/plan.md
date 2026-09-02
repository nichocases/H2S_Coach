# Plan técnico de implementación

## Arquitectura

Monorepo con aplicación móvil, backend, contratos y documentación.

```text
inline-hockey-coach/
├── apps/
│   ├── mobile/
│   │   ├── lib/
│   │   │   ├── app/
│   │   │   ├── core/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── features/
│   │   ├── test/
│   │   └── integration_test/
│   └── api/
│       ├── app/
│       │   ├── api/v1/
│       │   ├── core/
│       │   ├── db/
│       │   ├── models/
│       │   ├── repositories/
│       │   ├── schemas/
│       │   └── services/
│       ├── migrations/
│       └── tests/
├── contracts/openapi.yaml
├── specs/
├── docker-compose.yml
├── Makefile
└── README.md
```

## Mobile Flutter

- Flutter con Material 3 y Dart null safety.
- GoRouter para navegación declarativa.
- Riverpod para estado e inyección de dependencias; evitar estado global mutable fuera de providers.
- Feature folders: teams, session_setup, live_match, summary y sync.
- Drift encapsula SQLite, migraciones, transacciones y consultas reactivas.
- Dio implementa HTTP, timeouts e interceptores de `request_id`.
- `connectivity_plus` detecta cambios, pero antes de sincronizar se verifica acceso real a la API.
- Modelos inmutables con Freezed y serialización con `json_serializable` cuando reduzca errores.
- `SyncService` es Dart puro y no depende de widgets ni `BuildContext`.
- Cronómetro basado en `Stopwatch`/fuente monotónica y checkpoints persistidos; un `Timer.periodic` solo actualiza la vista, nunca es la fuente de verdad.
- Diseño adaptable mediante `LayoutBuilder`: móvil vertical y tablet horizontal.

## API

- FastAPI con prefijo `/api/v1`.
- Pydantic v2 para contratos.
- SQLAlchemy async y PostgreSQL.
- Capa de servicio maneja idempotencia y transacciones.
- Repositorios contienen consultas; rutas no acceden directamente al ORM.
- Middleware asigna `request_id`.

## Observabilidad

- Logs JSON con `request_id`, endpoint, status, duración y conteos.
- Métricas futuras: tamaño de lote, duplicados, rechazos, latencia y pendientes.
- No registrar nombres de jugadores ni payload completo.

## Seguridad MVP

- API key de desarrollo solo mediante variable de entorno.
- HTTPS obligatorio fuera de local.
- CORS restringido en despliegue.
- Límite de payload: 1 MB.
- Validación estricta de UUID, enums y longitudes.

## Entornos

- `local`: Docker Compose, emulador/simulador y `flutter run`.
- `test`: PostgreSQL aislado por ejecución.
- `production`: contenedor API + PostgreSQL administrado.

## Decisiones ADR

### ADR-001 Flutter en vez de PWA o React Native

Se elige Flutter para una interfaz táctil consistente en iOS y Android, buen rendimiento, control preciso del diagrama de cancha y persistencia SQLite confiable mediante Drift.

### ADR-002 Event queue local

Las mutaciones se modelan como snapshots versionados en una cola persistente. Simplifica reintentos y evita pérdida de eventos.

### ADR-003 Sin colaboración multi-dispositivo en MVP

Evita conflictos complejos. Un partido debe capturarse desde un solo dispositivo; la API detecta datos incompatibles.
