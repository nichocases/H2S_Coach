# Plan V2 - Dashboards Analíticos

## Objetivo General
Brindar al entrenador una vista global y consolidada del rendimiento histórico de sus equipos, categorías y jugadores en base a los datos recolectados durante los partidos (Fase MVP). Esta nueva característica debe seguir funcionando con la premisa *Offline-First*, calculando métricas a partir de la base de datos local (SQLite).

## Módulos del Dashboard

El dashboard se dividirá lógicamente en los siguientes análisis:

### 1. Dashboard de Equipos y Categorías
- **Filtros globales:** Selector de equipo y/o categoría, selector de rango de tiempo (Últimos 5 partidos, Toda la temporada).
- **Métricas:** 
  - Ratio de Victorias/Empates/Derrotas (requiere habilitar captura de puntaje final si no existe).
  - Promedio de Goles a Favor vs. Goles en Contra por partido.
  - Eficiencia general de tiro (% de goles sobre el total de tiros).

### 2. Leaderboards de Jugadores (Skaters)
- **Top Goleadores:** Tabla clasificada por goles.
- **Asistidores:** Tabla clasificada por asistencias.
- **Puntos (G + A):** Sumatoria clásica de hockey.
- **Tiros a Puerta (SOG) y Efectividad (%):** Cantidad de tiros al arco y qué porcentaje terminó en gol.

### 3. Rendimiento de Arqueros (Goalkeepers)
- **Porcentaje de Atajadas (Save Percentage - SV%):** `(Tiros a Puerta - Goles) / Tiros a Puerta`.
- **Goles en Contra Promedio (GAA):** Promedio por sesión iniciada.
- **Heatmap Defensivo:** Representación visual de las zonas (Z1 a Z4) donde el arquero recibe más remates o permite más goles.

## Consideraciones de Arquitectura

1. **Navegación:**
   - La aplicación móvil evolucionará para tener un `BottomNavigationBar` o `NavigationRail`. 
   - Pestaña 1: "Inicio/Partidos" (TeamOverview actual).
   - Pestaña 2: "Dashboard" (Nueva pantalla).
2. **Consultas Complejas (Drift):**
   - No traer toda la tabla a memoria en Dart. Usaremos *Vistas* (`CREATE VIEW`) o consultas SQL con `GROUP BY` nativas en SQLite a través de Drift para realizar los cálculos pesados (agregaciones de conteo de goles, atajadas, porcentajes).
3. **Backend y Sincronización:**
   - El dashboard leerá puramente del repositorio local, manteniendo la autonomía sin conexión. No hay requerimiento inicial de endpoints de métricas en la API (FastAPI) para el cliente móvil.

## Entregables Principales
- Tablas y vistas SQL en Drift para reportes.
- Pantalla principal de Dashboard con control de pestañas internas (Equipos, Jugadores, Arqueros).
- Gráficos interactivos (barras, tortas y heatmaps).
