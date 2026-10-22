class_name PantallaNarrativa
extends Control
## Pantallas de texto de la historia (introducción y final, RF-16).
##
## Enter avanza (el texto aparece letra por letra; si aún se escribe, lo completa) y Esc salta todo.
## Las dos escenas comparten este script y se configuran desde el Inspector.

## Letras que aparecen por segundo.
const LETRAS_POR_SEGUNDO: float = 40.0

## Textos de cada pantalla, en orden.
@export_multiline var textos: Array[String] = []
## Escena que se abre al terminar (por ejemplo, el nivel o la pantalla de victoria).
@export_file("*.tscn") var escena_siguiente: String = ""

var indice: int = 0

var _animacion: Tween = null

@onready var _etiqueta: Label = %EtiquetaTexto
@onready var _indicador: Label = %Indicador


func _ready() -> void:
	_mostrar(0)


func _unhandled_input(evento: InputEvent) -> void:
	# Se marca antes de avanzar o saltar: al cambiar de escena el nodo sale del árbol y ya no tiene viewport (DF-05).
	if evento.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		avanzar()
	elif evento.is_action_pressed("pausa"):
		get_viewport().set_input_as_handled()
		saltar()


## Completa el texto que se está escribiendo o pasa a la siguiente pantalla.
func avanzar() -> void:
	if _animacion != null and _animacion.is_running():
		_animacion.kill()
		_etiqueta.visible_ratio = 1.0
		return
	if indice + 1 < textos.size():
		_mostrar(indice + 1)
	else:
		saltar()


## Termina la secuencia y abre [member escena_siguiente].
func saltar() -> void:
	set_process_unhandled_input(false)
	GestorEscenas.cambiar_escena(escena_siguiente)


func _mostrar(nuevo_indice: int) -> void:
	indice = nuevo_indice
	_etiqueta.text = textos[indice] if indice < textos.size() else ""
	_etiqueta.visible_ratio = 0.0
	_indicador.text = "%d/%d   Enter: continuar   Esc: saltar" % [indice + 1, textos.size()]
	_animacion = create_tween()
	_animacion.tween_property(_etiqueta, "visible_ratio", 1.0, _etiqueta.text.length() / LETRAS_POR_SEGUNDO)
