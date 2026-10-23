# Fragmentos de Luz

Juego de plataformas 2D hecho en **Godot 4.5** para el parcial de *Diseño Multimedia y Videojuegos* (Ingeniería de Software, semestre IX). Docente: Yeison Sanabria Ascanio.

Morvak, el Hechicero de Sombra, robó el Cristal de Luz de Valdoria y lo rompió en cinco fragmentos. Como Sir Aldric, recorre el Bosque Marchito para recuperarlos y restaurar la luz del reino.

## Integrantes

| Integrante | Rol Scrum | Sistema a cargo |
|---|---|---|
| Jaider Villamizar | Product Owner y Developer | Jugador |
| Camilo Vargas | Scrum Master y Developer | Nivel, narrativa y audio |
| Kevin Yaruro | Developer | Enemigos y física |
| Diego Villamizar | Developer | Interfaz y persistencia |

## Versión de Godot

Godot **4.5-stable** (renderizador Compatibility). Las plantillas de exportación deben ser exactamente 4.5-stable.

## Cómo abrir y ejecutar

1. Clonar el repositorio: `git clone https://github.com/jaider23100/FragmentosDeLuz.git`
2. Abrir Godot 4.5 y, en el Project Manager, usar **Import** y seleccionar `project.godot`.
3. Ejecutar con **F5**.

## Cómo ejecutar las pruebas

Las pruebas unitarias usan **GUT 9.5.0** (`addons/gut/`) y están en `test/unit/`.

- **Desde el editor:** panel inferior **GUT** → *Run All*.
- **Por línea de comandos** (desde la carpeta del proyecto, en Windows):

```bash
"D:\Godot\Godot_v4.5-stable_win64_console.exe" --headless --path . -s addons/gut/gut_cmdln.gd -d -gdir=res://test/unit -gexit -gjunit_xml_file=res://docs/reporte_gut.xml
```

El reporte JUnit XML queda en `docs/reporte_gut.xml`.

## Release (jugar sin instalar Godot)

1. Descarga `FragmentosDeLuz-v1.0.0-windows.zip` desde la release v1.0.0: https://github.com/jaider23100/FragmentosDeLuz/releases/tag/v1.0.0
2. Descomprímelo en cualquier carpeta.
3. Abre `FragmentosDeLuz.exe` (deja el `.pck` en la misma carpeta). Requiere Windows 10 u 11 de 64 bits.

El mejor puntaje y el volumen se guardan en `%APPDATA%\Godot\app_userdata\Fragmentos de Luz\config.cfg`.

## Controles

| Acción | Teclas |
|---|---|
| Moverse | A / D o ← / → |
| Saltar / doble salto | Espacio, W o ↑ |
| Dash | Shift o K |
| Atacar | J o clic izquierdo |
| Pausa | Esc |

## Créditos de recursos de terceros

Ver [`assets/LICENCIAS.md`](assets/LICENCIAS.md). Hecho con [Godot Engine](https://godotengine.org) (licencia MIT).
