# Constitución del producto

## I. Offline primero

La pérdida de red no puede impedir configurar una sesión, iniciar el cronómetro, registrar acciones, deshacer/anular el último evento o terminar el partido. Cada mutación se guarda en SQLite antes de actualizar la interfaz.

## II. Captura en menos de tres interacciones

Una acción frecuente debe registrarse con máximo tres toques desde la pantalla del partido. Los botones deben ser grandes, explícitos y utilizables mientras el entrenador observa la cancha.

## III. Datos auditables

Cada evento conserva UUID, sesión, jugador o arquero, tiempo de cronómetro, fecha de creación UTC, dispositivo, versión y estado de sincronización. Las correcciones se auditan; no se destruyen datos sincronizados.

## IV. Contrato antes que implementación

Los cambios públicos empiezan modificando OpenAPI, modelo de datos, reglas y pruebas de aceptación. El código se adapta después.

## V. Sincronización segura

El servidor procesa cada `client_event_id` una sola vez. Repetir el mismo lote produce el mismo resultado, sin registros duplicados. Los fallos parciales se reportan por elemento.

## VI. Privacidad por diseño

El MVP almacena únicamente nombres deportivos, dorsales e identificadores internos. No requiere fecha de nacimiento, documentos, ubicación ni información médica de menores.

## VII. Simplicidad del MVP

No incluir video, IA, streaming, chat, pagos, torneos multi-club ni analítica predictiva. La arquitectura puede permitirlos, pero el MVP no los implementa.

