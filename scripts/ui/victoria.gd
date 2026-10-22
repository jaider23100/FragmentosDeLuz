class_name Victoria
extends Control
## Pantalla de victoria: puntos, bono por corazones, puntaje final y récord (RF-13, RF-19, RN-08, RN-09).

@onready var _etiqueta_puntos: Label = %EtiquetaPuntos
@onready var _etiqueta_bono: Label = %EtiquetaBono
@onready var _etiqueta_total: Label = %EtiquetaTotal
@onready var _etiqueta_record: Label = %EtiquetaRecord
@onready var _boton_jugar: Button = %BotonJugarDeNuevo


func _ready() -> void:
	var bono: int = EstadoJuego.corazones * EstadoJuego.BONO_CORAZON
	var total: int = EstadoJuego.calcular_puntaje_final()
	_etiqueta_puntos.text = "Puntos: %d" % EstadoJuego.puntos
	_etiqueta_bono.text = "Bono por corazones: +%d" % bono
	_etiqueta_total.text = "Total: %d" % total
	_etiqueta_record.visible = GestorGuardado.registrar_puntaje(total)
	_boton_jugar.grab_focus()


func _on_boton_jugar_de_nuevo_pressed() -> void:
	GestorEscenas.iniciar_partida()


func _on_boton_menu_pressed() -> void:
	GestorEscenas.cambiar_escena(GestorEscenas.MENU)
