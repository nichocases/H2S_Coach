# Instrucciones para Codex

## Fuente de verdad

La prioridad documental es:

1. `specs/constitution.md`
2. `specs/001-mvp/spec.md`
3. `specs/001-mvp/contracts/openapi.yaml`
4. `specs/001-mvp/data-model.md`
5. `specs/001-mvp/flutter-frontend.md`
6. `specs/001-mvp/plan.md` y `specs/002-dashboards/plan.md`
7. `specs/001-mvp/tasks.md` y `specs/002-dashboards/tasks.md`

Si dos documentos se contradicen, detente, describe el conflicto y propone la corrección mínima. No inventes comportamiento de producto.

## Método de trabajo obligatorio

- Implementa una fase de `tasks.md` a la vez.
- Antes de cambiar código, identifica criterios de aceptación afectados.
- Escribe o actualiza pruebas junto con cada comportamiento.
- No marques una tarea como terminada sin ejecutar su validación.
- No agregues funcionalidades fuera del MVP o V2 Dashboards.
- Mantén los cambios pequeños y revisables.
- Nunca almacenes secretos en el repositorio.
- Todas las escrituras de sincronización deben ser idempotentes.
- El flujo de captura debe funcionar sin conexión.

## Reglas de arquitectura

- La interfaz nunca escribe directamente en la API: primero persiste localmente y luego encola sincronización.
- El backend es la autoridad después de sincronizar; el dispositivo es la autoridad temporal mientras está offline.
- Los eventos registrados no se eliminan físicamente: se anulan mediante `voided_at` y `void_reason`.
- Los timestamps absolutos usan UTC. El cronómetro usa milisegundos transcurridos.
- Los IDs se generan en el cliente como UUID v4 para soportar modo offline.
- No mezclar entidades ORM con schemas públicos de API.

## Calidad mínima

- Dart con null safety, `analysis_options.yaml` estricto y `flutter analyze` sin errores.
- Python con typing y `ruff`.
- Cobertura objetivo: 80% en servicios de dominio y sincronización.
- OpenAPI validado.
- Pruebas para reintentos, duplicados y reconexión.
- Controles táctiles esenciales de al menos 44×44 puntos.

## Definición de terminado

Una historia está terminada cuando:

- Cumple todos sus escenarios Given/When/Then.
- Funciona en modo avión.
- No duplica eventos al reintentar.
- Tiene estados de carga, vacío y error.
- Pasa lint, typecheck y pruebas.
- La documentación refleja el comportamiento implementado.
