# Tareas de Implementación - V2 Dashboards

Formato: `[ID] [Prioridad] [Historia] Descripción — validación`.

## Fase 7 — Repositorios y Agregaciones (Datos Locales)

- [ ] T701 [P1] [US-08] Crear queries Drift (`GROUP BY`) para métricas de equipo (goles a favor, goles en contra) — pruebas unitarias validan sumatorias.
- [ ] T702 [P1] [US-09] Crear queries Drift para tabla de clasificación de jugadores (Goles, Asistencias, Puntos, Efectividad) — pruebas unitarias validan ordenamiento y divisiones seguras.
- [ ] T703 [P1] [US-10] Crear queries Drift para estadísticas de arqueros (SV%, tiros por zona Z1-Z4) — cálculo de SV% pasa sin `div/0`.
- [ ] T704 [P2] [US-08] (Opcional) Soporte en base de datos para capturar el marcador final oficial del partido si difiere de los eventos registrados.

## Fase 8 — Interfaz de Usuario (Dashboards)

- [ ] T801 [P1] [US-11] Actualizar enrutamiento (`GoRouter`) e implementar `BottomNavigationBar` — navegación entre "Inicio" y "Estadísticas" funciona.
- [ ] T802 [P1] [US-08] Construir pantalla base `DashboardScreen` con pestañas internas (General, Jugadores, Arqueros) — las vistas conmutan correctamente.
- [ ] T803 [P1] [US-08] Construir tarjetas de resumen del equipo (Win Ratio, Goles Favor/Contra) y gráficos básicos (fl_chart) — los estados vacíos se renderizan bien.
- [ ] T804 [P1] [US-09] Construir componente de tabla (DataTable) para el Leaderboard de Jugadores, permitiendo ordenar por columnas (G, A, P) — ordenamiento en memoria responde a los clics.
- [ ] T805 [P1] [US-10] Construir componente visual (Heatmap o tabla de zonas) para las métricas del arquero — zonas Z1-Z4 reflejan densidades de tiros correctas.

## Fase 9 — Filtros y Refinamiento

- [ ] T901 [P2] [US-11] Agregar `Dropdown` de filtro por Equipo y Categoría en la cabecera del Dashboard — al cambiar el filtro, los providers de Riverpod actualizan todos los widgets.
- [ ] T902 [P2] [US-11] Implementar filtro por rango de fechas (Últimos N partidos o histórico total) — las queries de Fase 7 respetan el `sessionId` / `createdAt`.
- [ ] T903 [P1] Ejecutar pruebas E2E creando sesiones de prueba, registrando acciones y verificando que el Dashboard sume correctamente — Smoke test completo aprobado.
