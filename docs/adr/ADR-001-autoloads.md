# ADR-001: Gestión del estado global y de los servicios mediante autoloads

- **Fecha:** 19 de octubre de 2026
- **Estado:** Aceptada

## Contexto

Los corazones, los puntos y los fragmentos deben conservarse al pasar del nivel a las pantallas de victoria o derrota. El audio, el guardado y el cambio de escena se usan desde muchas escenas. Además, las reglas de negocio (RN-01 a RN-10) deben poder probarse con GUT sin cargar el nivel.

## Decisión

Se crean cuatro autoloads registrados en *Project Settings › Globals › Autoload*:

- `EstadoJuego` (`scripts/autoload/estado_juego.gd`): estado de la partida y reglas de negocio.
- `GestorEscenas` (`scripts/autoload/gestor_escenas.gd`): cambio entre pantallas con rutas centralizadas.
- `GestorAudio` (`scripts/autoload/gestor_audio.gd`): música, efectos y volumen de los buses.
- `GestorGuardado` (`scripts/autoload/gestor_guardado.gd`): carga y guardado de `user://config.cfg`.

Los autoloads nunca referencian escenas: comunican los cambios con señales y son las escenas las que los llaman a ellos.

## Consecuencias

- **Positivas:** única fuente de verdad; el estado sobrevive a los cambios de escena; la lógica se prueba de forma aislada; el HUD queda desacoplado mediante señales.
- **Negativas:** el estado global puede crecer sin control y el orden de carga importa (`GestorGuardado` debe cargarse antes que `GestorAudio`). Se mitiga con la regla de dependencias de la arquitectura y el orden definido en Project Settings.

## Alternativas descartadas

1. Guardar el estado en el nodo raíz del nivel y pasarlo a las pantallas siguientes: acopla las escenas y complica el reinicio.
2. Un único autoload `Juego` con todo: viola la responsabilidad única y dificulta las pruebas.
