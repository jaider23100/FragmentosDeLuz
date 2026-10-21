# Registro de cambios

Todos los cambios relevantes del proyecto se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el proyecto usa [versionado semántico](https://semver.org/lang/es/).

## [Sin publicar]

## [0.1.0] - 2026-10-20

### Añadido
- Estructura inicial del proyecto Godot 4.5 (renderizador Compatibility, resolución base 320×180, filtro Nearest).
- Input Map con las acciones `mover_izquierda`, `mover_derecha`, `saltar`, `dash`, `atacar` y `pausa`.
- Nombres de las 8 capas de colisión 2D y buses de audio `Musica` y `Efectos`.
- Caballero con movimiento, salto, doble salto y dash (HU-01, HU-02, HU-03).
- Slime patrullero (HU-04), checkpoints y caída al vacío en el nivel en greybox (HU-05).
- Menú principal y gestor de escenas (HU-06).
- GUT 9.5.0, autoload EstadoJuego con las reglas de negocio y pruebas automatizadas (HU-07).
