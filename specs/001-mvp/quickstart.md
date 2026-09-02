# Quickstart para Codex

## Paso 1 — Crear el repositorio

Usa el contenido de este kit como `specs/` y copia `AGENTS.md` en la raíz del nuevo repositorio.

## Paso 2 — Ejecutar por fases

No pidas “crea toda la app” en una sola ejecución. Usa los prompts siguientes.

### Prompt Fase 0

> Lee AGENTS.md, constitution.md, spec.md, plan.md y tasks.md. Implementa T001–T005. No implementes dominio todavía. Ejecuta lint, typecheck, pruebas base y healthcheck. Actualiza tasks.md únicamente con tareas realmente verificadas.

### Prompt Fase 1

> Implementa T101–T106 respetando data-model.md y openapi.yaml. Crea primero las pruebas de repositorios, restricciones y transacciones atómicas. Ejecuta migraciones desde una base vacía y reporta el esquema final.

### Prompt Fases 2 y 3

> Implementa T201–T307. Prioriza el flujo offline y máximo tres toques. No conectes todavía la sincronización remota. Ejecuta pruebas de cronómetro, persistencia local y reglas de tiros/arquero.

### Prompt Fase 4

> Implementa T401–T406 según sync-protocol.md y openapi.yaml. Añade pruebas de duplicados, fallos parciales, backoff, cierre inesperado y reconexión. Demuestra que reenviar un lote no duplica registros.

### Prompt Fases 5 y 6

> Implementa T501–T606. Verifica estadísticas contra las reglas de spec.md, modo avión, 5.000 eventos y accesibilidad táctil. No agregues funciones fuera de alcance.

## Paso 3 — Bucle de revisión

Después de cada fase, pedir:

> Revisa la implementación de esta fase contra todos sus criterios Given/When/Then. Enumera incumplimientos con evidencia de archivo y prueba. Corrige solo incumplimientos confirmados y vuelve a ejecutar la validación completa.

## Variables de entorno esperadas

```text
DATABASE_URL=postgresql+asyncpg://app:app@localhost:5432/inline_hockey
API_ENV=local
API_KEY=development-only
API_BASE_URL=http://localhost:8000
```

En Flutter, pasar la URL local mediante `--dart-define=API_BASE_URL=http://...`. No confirmar secretos reales en Git ni asumir que `dart-define` es almacenamiento seguro para secretos.
