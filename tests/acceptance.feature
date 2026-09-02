Feature: Inline Hockey Coach MVP

  Scenario: Crear una sesión sin conexión
    Given el dispositivo está sin conexión
    And existe un equipo con jugadores y un arquero
    When el entrenador configura e inicia una sesión
    Then la sesión queda guardada localmente como IN_PROGRESS
    And existe un elemento PENDING en la cola de sincronización

  Scenario: Registrar un pase en dos toques
    Given hay una sesión IN_PROGRESS
    When el entrenador selecciona un jugador
    And selecciona PASS
    Then se guarda una MatchAction local con el tiempo del cronómetro
    And se vuelve a la pantalla del partido

  Scenario: Registrar un tiro completo
    Given hay una sesión IN_PROGRESS
    When el entrenador selecciona SHOOT para un jugador
    And selecciona TOP_LEFT
    And selecciona GOAL
    Then se guarda una MatchAction SHOOT
    And se guarda ShootDetails con TOP_LEFT y GOAL
    And ambas escrituras y la cola se confirman atómicamente

  Scenario: Registrar una atajada
    Given hay un arquero activo
    When el entrenador selecciona al arquero
    And selecciona ZONE_2
    And selecciona SAVE
    Then se guarda GoalkeeperAction para el arquero activo

  Scenario: Anular la última acción
    Given existe una última acción sin anular
    When el entrenador pulsa Deshacer último
    Then la acción recibe voided_at y void_reason
    And deja de participar en las estadísticas
    And no se elimina físicamente

  Scenario: Sincronización idempotente
    Given existe un lote pendiente con cinco eventos
    When el mismo lote se envía dos veces
    Then cada evento existe una sola vez en el servidor
    And la segunda respuesta reporta DUPLICATE o ACCEPTED idempotente

  Scenario: Sincronizar dependencias antes de una acción
    Given un equipo, entrenador y jugadores existen solamente en el dispositivo
    And existe una sesión con acciones pendientes
    When la app construye el lote
    Then ordena entrenador, equipo, jugadores, sesión, plantilla y acciones
    And el servidor procesa las claves foráneas sin referencias inexistentes

  Scenario: Fallo parcial
    Given un lote contiene un evento válido y uno inválido
    When el servidor procesa el lote
    Then el válido se marca SYNCED
    And el inválido queda FAILED con un error visible

  Scenario: Recuperar después de cerrar la app
    Given una acción fue confirmada localmente
    And la app se cerró antes de sincronizar
    When la app vuelve a abrir
    Then la acción sigue disponible
    And vuelve a intentarse al detectar conexión

  Scenario: Calcular porcentaje de atajadas
    Given el arquero tiene ocho atajadas y dos goles recibidos
    When se abre el resumen
    Then los disparos enfrentados son diez
    And el porcentaje de atajadas es 80%
