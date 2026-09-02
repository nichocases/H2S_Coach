# Tareas de implementación

Formato: `[ID] [Prioridad] [Historia] Descripción — validación`.

## Fase 0 — Bootstrap

- [x] T001 [P1] Crear monorepo, `.gitignore`, `.editorconfig`, README y comandos comunes — estructura coincide con `plan.md`.
- [x] T002 [P1] Crear app Flutter con Dart null safety, Material 3 y GoRouter — `flutter analyze` pasa.
- [x] T003 [P1] Crear FastAPI con healthcheck y configuración por entorno — `GET /health` retorna 200.
- [x] T004 [P1] Crear Docker Compose con PostgreSQL 16 — migraciones pueden conectarse.
- [x] T005 [P1] Configurar Ruff, Pytest, lints Dart, `flutter_test` e `integration_test` — todos los comandos base pasan.

## Fase 1 — Dominio y persistencia

- [x] T101 [P1] [US-01] Implementar modelos API y migración inicial — esquema coincide con `data-model.md`.
- [x] T102 [P1] [US-01] Implementar migraciones SQLite — prueba crea DB desde cero.
- [x] T103 [P1] [US-01] Implementar repositorios locales de coach, team y player — CRUD probado.
- [x] T104 [P1] [US-01] Implementar repositorio local de sesiones y plantilla — restricciones probadas.
- [x] T105 [P1] Implementar `SyncQueueRepository` y transacciones atómicas — rollback probado.
- [x] T106 [P1] Crear seed de un equipo, cinco jugadores y un arquero — app abre con datos demo.

## Fase 2 — Configuración y cronómetro

- [x] T201 [P1] [US-01] Construir lista/creación de equipos — estados vacío y demo cubiertos.
- [x] T202 [P1] [US-01] Construir pantalla de configuración — validaciones de aceptación pasan.
- [x] T203 [P1] [US-02] Implementar servicio monotónico de cronómetro — pruebas de pausa, reanudación y restauración pasan.
- [x] T204 [P1] [US-02] Construir encabezado del partido — reloj y estados accesibles.

## Fase 3 — Captura del partido

- [x] T301 [P1] [US-03] Construir roster táctil y menú de acciones — pase se registra en dos toques.
- [x] T302 [P1] [US-03] Implementar servicio local de MatchAction — escritura y cola son atómicas.
- [x] T303 [P1] [US-04] Construir selector 2×3 del arco — zona y resultado obligatorios.
- [x] T304 [P1] [US-04] Implementar ShootDetails y métricas básicas — reglas de tiros pasan.
- [x] T305 [P1] [US-05] Construir selector de zonas de origen del arquero — Z1–Z4 accesibles.
- [x] T306 [P1] [US-05] Implementar GoalkeeperAction — SAVE y GOAL_ALLOWED probados.
- [x] T307 [P1] [US-06] Implementar historial reciente y anulación — evento permanece auditable.

## Fase 4 — API y sincronización

- [x] T401 [P1] [US-07] Implementar `POST /api/v1/sync` según OpenAPI — contract tests pasan.
- [x] T402 [P1] [US-07] Implementar UPSERT idempotente y resultados por elemento — reenvío no duplica.
- [x] T403 [P1] [US-07] Implementar `SyncService` móvil — lotes y estados probados.
- [x] T404 [P1] [US-07] Integrar `connectivity_plus`, verificación real de API, debounce y backoff — reconexión probada.
- [x] T405 [P1] [US-07] Construir indicador y panel de errores — reintento manual funciona.
- [x] T406 [P1] [US-07] Probar cierre inesperado durante sincronización — cola se recupera.

### Fase 5: Resumen y Finalización (DONE)

- [x] T501: Repositorio para `MatchSummary` (agregación en SQLite sin `div/0`).
- [x] T502: Interfaz de totales por equipo y tabla de jugadores en `/sessions/:id/summary`.
- [x] T503: Módulo de estadísticas de arquero y mapa de tiros en la misma pantalla.
- [x] T504: Lógica de cierre (`finishSession`) y validación de `inProgress` para bloquear nuevos eventos.

## Fase 6 — Endurecimiento y entrega

- [x] T601 [P1] Ejecutar pruebas en ancho 320 px y tablet horizontal — sin controles cortados.
- [x] T602 [P1] Ejecutar prueba completa en modo avión — todas las US P1 pasan.
- [x] T603 [P1] Probar 5.000 eventos locales y lotes de 200 — NFR-03/04 pasan.
- [x] T604 [P1] Revisar logs, secretos, CORS y límites — checklist de seguridad pasa.
- [x] T605 [P1] Completar README de desarrollo y despliegue — una máquina limpia puede iniciar el sistema.
- [x] T606 [P1] Generar `flutter build apk` y build iOS cuando exista macOS/Xcode — smoke test aprobado.
