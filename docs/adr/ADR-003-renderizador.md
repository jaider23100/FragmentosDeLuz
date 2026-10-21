# ADR-003: Uso del renderizador Compatibility

- **Fecha:** 19 de octubre de 2026
- **Estado:** Aceptada

## Contexto

El juego es 2D en pixel art a 320×180, sin iluminación 3D ni efectos avanzados. Debe funcionar en los computadores de los integrantes, de los testers y del docente, que pueden tener gráficos integrados antiguos (RNF-05), con al menos 60 FPS (RNF-01).

## Decisión

Se configura el renderizador **Compatibility** (OpenGL 3.3 / OpenGL ES 3.0) en *Project Settings › Rendering › Renderer › Rendering Method* (`gl_compatibility`), desde la creación del proyecto.

## Consecuencias

- **Positivas:** máxima compatibilidad de hardware, incluidos gráficos sin soporte de Vulkan; arranque más rápido; suficiente para 2D; permitiría exportar a web en el futuro.
- **Negativas:** no tiene las funciones avanzadas de Forward+ (ciertos efectos de iluminación y partículas por GPU), que este juego no necesita.

## Alternativas descartadas

1. Forward+ (Vulkan, valor por defecto): exige hardware compatible con Vulkan y podría no abrir en equipos con gráficos antiguos.
2. Mobile: pensado para dispositivos móviles, sin ventaja para un juego 2D de PC.
