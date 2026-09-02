# Especificación del frontend Flutter

## Versiones y paquetes

Usar la versión estable vigente de Flutter 3.x y Dart 3.x, fijada en CI. Dependencias recomendadas:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: any
  go_router: any
  drift: any
  sqlite3_flutter_libs: any
  path_provider: any
  path: any
  dio: any
  connectivity_plus: any
  freezed_annotation: any
  json_annotation: any
  uuid: any
  clock: any

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  build_runner: any
  drift_dev: any
  freezed: any
  json_serializable: any
  mocktail: any
  very_good_analysis: any
```

Al crear el proyecto, Codex debe resolver y fijar versiones compatibles en `pubspec.lock`, no copiar `any` al producto final sin resolver.

## Capas

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── clock/
│   ├── errors/
│   ├── networking/
│   └── widgets/
├── data/
│   ├── local/drift/
│   ├── remote/api/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── services/
└── features/
    ├── teams/
    ├── session_setup/
    ├── live_match/
    ├── player_action/
    ├── goalkeeper_action/
    ├── summary/
    └── sync/
```

Cada feature puede contener `presentation`, `application` y pruebas. Evitar una arquitectura ceremonial: crear una capa únicamente si contiene comportamiento real.

## Providers mínimos

- `databaseProvider`.
- `apiClientProvider`.
- `connectivityProvider`.
- `syncServiceProvider`.
- `activeSessionProvider`.
- `chronometerProvider`.
- `recentActionsProvider(sessionId)`.
- `matchSummaryProvider(sessionId)`.

Los providers de infraestructura se sobrescriben en pruebas. Los widgets no crean conexiones SQLite ni clientes Dio directamente.

## Rutas

| Ruta | Pantalla |
|---|---|
| `/` | Equipos/sesiones recientes |
| `/teams/new` | Crear equipo y plantilla |
| `/sessions/new` | Configurar sesión |
| `/sessions/:id/live` | Partido en vivo |
| `/sessions/:id/summary` | Resumen |

Las capturas de jugador, tiro y arquero son `showModalBottomSheet` o diálogo adaptable, no rutas profundas, para volver inmediatamente al partido.

## Widgets clave

- `AdaptiveMatchScaffold`: cambia entre columnas de tablet y pila móvil.
- `MatchClock`: vista del cronómetro; delega lógica a un controller.
- `PlayerRoster`: lista de jugadores y dorsal.
- `PlayerActionSheet`: cuatro acciones grandes.
- `HockeyRink`: cancha y zonas de origen; usar `CustomPainter` solo para geometría, no para botones táctiles.
- `GoalTargetGrid`: seis `Semantics` + botones reales.
- `GoalkeeperActionSheet`.
- `SyncStatusButton`: texto, icono y cantidad pendiente.
- `RecentActionList` y `UndoLastActionButton`.

## Adaptación de pantalla

- Menos de 600 dp: móvil; roster horizontal o lista compacta, cancha y acciones apiladas.
- Desde 600 dp: tablet; roster, cancha y panel reciente en columnas.
- No bloquear orientación, pero optimizar partido para horizontal.
- Usar `SafeArea` y respetar escalado de texto.

## Accesibilidad

- Cada zona anuncia posición y resultado, no solo color.
- Botones táctiles con mínimo 44×44 dp; preferir 48 dp Material.
- `Semantics` para cronómetro y sincronización.
- No anunciar cada tick del cronómetro; anunciar cambios de estado.
- Contraste compatible con temas claro y oscuro.

## Persistencia Drift

- Versión de esquema explícita.
- Migraciones probadas desde cada versión soportada.
- Métodos de repositorio envuelven entidad + `sync_queue` en una sola `transaction`.
- Streams de Drift alimentan listas y resúmenes sin duplicar estado en Riverpod.

## Pruebas Flutter

- Unitarias: cronómetro, métricas, lote, backoff y mapeos JSON.
- Drift en memoria: repositorios, constraints y rollback.
- Widget tests: configuración, acciones, arco, arquero y estados de red.
- Golden tests opcionales: móvil 390×844 y tablet 1024×768.
- Integration tests: flujo completo offline, cierre/reapertura y posterior sincronización.

## Comandos de validación

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

