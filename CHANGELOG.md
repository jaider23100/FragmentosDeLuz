# Registro de cambios

Todos los cambios relevantes del proyecto se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el proyecto usa [versionado semántico](https://semver.org/lang/es/).

## [Sin publicar]

## [1.0.0] - 2026-10-23

### Añadido
- Guardado del mejor puntaje y del volumen en `user://config.cfg` con el autoload GestorGuardado; tolera archivos ausentes o dañados (HU-21).
- El menú principal muestra el mejor puntaje y la victoria avisa "¡Nuevo mejor puntaje!" (RN-09).
- Pantalla de créditos con el equipo, los recursos de terceros, sus licencias y el aviso de Godot (HU-22).
- Ejecutable de Windows que funciona sin instalar Godot (HU-23).

### Cambiado
- El volumen inicial se toma de la configuración guardada y se guarda al presionar Volver en Opciones.

## [0.2.0] - 2026-10-22

### Añadido
- Ataque con espada, daño con retroceso, invulnerabilidad con parpadeo y sprites propios del caballero (HU-08, HU-09).
- Murciélago perseguidor con máquina de estados (HU-10) y slime con sprite animado.
- Roca empujable (RigidBody2D), corriente de viento (Area2D) y púas (HU-11, HU-12).
- Fragmentos del Cristal y monedas coleccionables (HU-13, HU-14).
- Introducción, carteles de piedra, santuario y cinemática final (HU-15).
- Música del menú y del nivel, y efectos de sonido de las acciones principales con GestorAudio (HU-16).
- HUD con corazones, fragmentos y puntaje, y menú de pausa (HU-17, HU-19).
- Pantallas de victoria y derrota (HU-18) y panel de opciones con volumen de música y efectos (HU-20).
- Nivel completo del Bosque Marchito con el tileset oscurecido y herramientas que generan el arte propio.

### Cambiado
- La colisión del caballero pasa a 10x20 para el sprite de 24x24.
- "Jugar" abre la introducción antes del nivel.

### Corregido
- La roca no se movía al empujarla: la fuerza de empuje ahora supera la fricción con el suelo (DF-06).
- Esc o Enter en la introducción ya no deja error en el depurador (DF-05).

## [0.1.0] - 2026-10-20

### Añadido
- Estructura inicial del proyecto Godot 4.5 (renderizador Compatibility, resolución base 320×180, filtro Nearest).
- Input Map con las acciones `mover_izquierda`, `mover_derecha`, `saltar`, `dash`, `atacar` y `pausa`.
- Nombres de las 8 capas de colisión 2D y buses de audio `Musica` y `Efectos`.
- Caballero con movimiento, salto, doble salto y dash (HU-01, HU-02, HU-03).
- Slime patrullero (HU-04), checkpoints y caída al vacío en el nivel en greybox (HU-05).
- Menú principal y gestor de escenas (HU-06).
- GUT 9.5.0, autoload EstadoJuego con las reglas de negocio y pruebas automatizadas (HU-07).
