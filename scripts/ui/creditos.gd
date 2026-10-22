class_name Creditos
extends Control
## Pantalla de créditos: equipo, recursos de terceros con su licencia y aviso de Godot (RF-18, HU-22).
##
## El texto sube solo; las flechas lo mueven a mano y Volver o Esc regresan al menú (CU-07).

## Velocidad del desplazamiento automático, en píxeles por segundo.
const VELOCIDAD: float = 10.0

const TEXTO: String = """FRAGMENTOS DE LUZ

EQUIPO (GRUPO 2)
Jaider Villamizar
Product Owner, caballero y diagramas
Camilo Vargas
Scrum Master, nivel, narrativa y audio
Kevin Yaruro
Enemigos y física
Diego Villamizar
Interfaz, persistencia y pruebas

ARTE PROPIO DEL EQUIPO
Caballero, slime, murciélago, objetos,
interfaz e ilustraciones de la historia

TILESET
Four Seasons Platformer Tileset
RottingPixels, en Brackeys Platformer Bundle
Licencia CC0. Oscurecido por el equipo

FUENTE
Pixel Operator 8, Jayvee Enaguas
en Brackeys Platformer Bundle. Licencia CC0

MÚSICA
Time for Adventure
Brackeys y Sofia Thirslund. Licencia CC0
[Chiptune] Medieval: The Bard's Tale
RandomMind (OpenGameArt). Licencia CC0

EFECTOS DE SONIDO
Brackeys y Asbjørn Thirslund
en Brackeys Platformer Bundle. Licencia CC0
Efectos sintetizados por el equipo

PRUEBAS
GUT 9.5.0, Butch Wesley. Licencia MIT

MOTOR
Hecho con Godot Engine 4.5
(c) 2014-presente, colaboradores de Godot Engine
(c) 2007-2014, Juan Linietsky y Ariel Manzur
Licencia MIT. godotengine.org/license

Gracias por jugar"""

@onready var _desplazamiento: ScrollContainer = %Desplazamiento
@onready var _etiqueta_texto: Label = %EtiquetaTexto
@onready var _boton_volver: Button = %BotonVolver

var _posicion: float = 0.0


func _ready() -> void:
	EstadoJuego.cambiar_fase(EstadoJuego.Fase.MENU)
	_etiqueta_texto.text = TEXTO
	_boton_volver.grab_focus()


func _process(delta: float) -> void:
	var limite: float = maxf(_etiqueta_texto.size.y - _desplazamiento.size.y, 0.0)
	_posicion = minf(_posicion + VELOCIDAD * delta, limite)
	_desplazamiento.scroll_vertical = roundi(_posicion)


func _input(evento: InputEvent) -> void:
	if evento.is_action_pressed("pausa"):
		_on_boton_volver_pressed()
	elif evento.is_action_pressed("ui_down"):
		_posicion += 16.0
	elif evento.is_action_pressed("ui_up"):
		_posicion = maxf(_posicion - 16.0, 0.0)


func _on_boton_volver_pressed() -> void:
	GestorEscenas.cambiar_escena(GestorEscenas.MENU)
