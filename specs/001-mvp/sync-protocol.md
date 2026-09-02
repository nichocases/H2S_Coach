# Protocolo offline y sincronización

## Escritura local atómica

Por cada acción, una transacción SQLite debe:

1. Insertar o actualizar la entidad local.
2. Insertar un snapshot en `sync_queue` con estado `PENDING`.
3. Confirmar la transacción.
4. Actualizar la interfaz.

Si cualquier paso de base falla, se revierte la transacción y se muestra un error. Nunca mostrar éxito antes del commit local.

## Activadores

- Al iniciar la app.
- Al recuperar conexión estable durante 2 segundos.
- Cada 30 segundos mientras exista trabajo pendiente y conexión.
- Al pulsar `Reintentar`.
- Al finalizar una sesión.

## Lotes

- Máximo 200 elementos.
- Orden: entrenador, equipo, jugadores, sesión, plantilla de sesión, acciones de jugador y acciones de arquero.
- Un solo proceso de sincronización activo por dispositivo.
- Timeout HTTP: 15 segundos.

## Idempotencia

Cada evento envía `device_id`, `client_event_id` y `version`. El servidor realiza UPSERT usando `(device_id, client_event_id)`.

- Misma versión y mismo contenido: `DUPLICATE`, sin escritura adicional.
- Versión mayor: actualiza campos permitidos.
- Versión menor: `CONFLICT` con la versión del servidor.
- Mismo ID y contenido incompatible: `REJECTED`.

## Backoff

Retrasos sugeridos: 2 s, 5 s, 15 s, 30 s, 60 s y máximo 5 min con jitter de ±20%. Errores de validación no se reintentan automáticamente hasta que cambie el payload.

## Fallos parciales

La respuesta contiene un resultado por elemento. Solo elementos `ACCEPTED` o `DUPLICATE` pasan a `SYNCED`. Los demás permanecen `FAILED` o `PENDING` según el código.

## Recuperación de cierre inesperado

Al iniciar:

- Cambiar entradas `SYNCING` antiguas a `PENDING`.
- Recalcular la sesión activa desde timestamps persistidos.
- Ejecutar sincronización si hay conexión.
