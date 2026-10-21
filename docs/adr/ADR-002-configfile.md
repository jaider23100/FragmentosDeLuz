# ADR-002: Formato de persistencia `ConfigFile` en `user://config.cfg`

- **Fecha:** 19 de octubre de 2026
- **Estado:** Aceptada

## Contexto

Hay que guardar entre sesiones el mejor puntaje y dos volúmenes (RF-19), con control de versión del formato y manejo de archivos ausentes o dañados (RNF-08). Los datos son pocos y planos.

## Decisión

Se usa la clase `ConfigFile` de Godot con las secciones `meta`, `progreso` y `audio` en `user://config.cfg`, y la clave `meta/version` para el control de versión. `GestorGuardado` valida cada valor al leerlo y usa valores por defecto si el archivo no existe, está dañado o un valor es inválido.

## Consecuencias

- **Positivas:** API nativa de pocas líneas; conserva los tipos (`int`, `float`) sin conversión; archivo legible y editable para depurar; los errores de carga se detectan por el código de retorno de `load()`.
- **Negativas:** no sirve para estructuras anidadas complejas; si en el futuro se guarda la partida a mitad del nivel, habrá que revisar esta decisión.

## Alternativas descartadas

1. JSON con `FileAccess` y `JSON.parse_string`: pierde el tipo (todos los números quedan como `float`) y exige más código de validación.
2. Un `Resource` guardado con `ResourceSaver`: un archivo `.tres` modificado puede ejecutar código al cargarse, un riesgo innecesario para datos de usuario.
