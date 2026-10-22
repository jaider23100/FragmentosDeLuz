class_name Derrota
extends Control
## Pantalla de derrota: fragmentos y puntos logrados, con reintentar o volver al menú (RF-13, RN-07).

@onready var _etiqueta_fragmentos: Label = %EtiquetaFragmentos
@onready var _etiqueta_puntos: Label = %EtiquetaPuntos
@onready var _boton_reintentar: Button = %BotonReintentar


func _ready() -> void:
	_etiqueta_fragmentos.text = "Fragmentos: %d/%d" % [EstadoJuego.fragmentos, EstadoJuego.TOTAL_FRAGMENTOS]
	_etiqueta_puntos.text = "Puntos: %d" % EstadoJuego.puntos
	_boton_reintentar.grab_focus()


## Reintentar empieza el nivel desde cero (RN-10): el nivel reinicia EstadoJuego en su _ready.
func _on_boton_reintentar_pressed() -> void:
	GestorEscenas.cambiar_escena(GestorEscenas.NIVEL)


func _on_boton_menu_pressed() -> void:
	GestorEscenas.cambiar_escena(GestorEscenas.MENU)
