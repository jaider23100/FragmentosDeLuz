# ADR-004: Uso de GUT 9.5.0 para las pruebas unitarias

- **Fecha:** 19 de octubre de 2026
- **Estado:** Aceptada

## Contexto

El parcial exige al menos 15 pruebas unitarias automatizadas, ejecutables por línea de comandos y con reporte (RNF-07), usando GUT o gdUnit4. El equipo tiene poca experiencia con ambos y solo 5 días (riesgo R-09).

## Decisión

Se usa **GUT 9.5.0**, instalado en `addons/gut/`, con las pruebas en `test/unit/` (archivos `test_*.gd` que extienden `GutTest`). Se ejecuta con `addons/gut/gut_cmdln.gd` y exporta el reporte JUnit XML a `docs/reporte_gut.xml`.

## Consecuencias

- **Positivas:** las pruebas se escriben en GDScript puro, igual que el juego; la ejecución por consola es un solo comando sin variables de entorno; es la versión indicada para Godot 4.5.
- **Negativas:** el reporte es solo XML (gdUnit4 genera además HTML); para el documento se complementa con una captura del panel GUT.

## Alternativas descartadas

gdUnit4 6.0.x: más funciones (reporte HTML, mocks avanzados), pero exige configurar `GODOT_BIN` y el script `runtest`, y su API es más extensa de aprender en el tiempo disponible.
