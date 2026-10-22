class_name Victoria
extends Control
## Pantalla de victoria: puntos, bono por corazones y puntaje final (RF-13, RN-08).

@onready var _etiqueta_puntos: Label = %EtiquetaPuntos
@onready var _etiqueta_bono: Label = %EtiquetaBono
@onready var _etiqueta_total: Label = %EtiquetaTotal
@onready var _boton_jugar: Button = %BotonJugarDeNuevo


func _ready() -> void:
	var bono: int = EstadoJuego.corazones * EstadoJuego.BONO_CORAZON
	_etiqueta_puntos.text = "Puntos: %d" % EstadoJuego.puntos
	_etiqueta_bono.text = "Bono por corazones: +%d" % bono
	_etiqueta_total.text = "Total: %d" % EstadoJuego.calcular_puntaje_final()
	_boton_jugar.grab_focus()


func _on_boton_jugar_de_nuevo_pressed() -> void:
	GestorEscenas.iniciar_partida()


func _on_boton_menu_pressed() -> void:
	GestorEscenas.cambiar_escena(GestorEscenas.MENU)
