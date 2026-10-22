class_name Opciones
extends PanelContainer
## Panel de opciones con el volumen de la música y de los efectos (RF-18, HU-20).
##
## Se instancia oculto en el menú principal y en la pausa; avisa con [signal cerrado] al volver.

## Se emite al presionar Volver, para que el menú que lo abrió recupere el foco.
signal cerrado

@onready var _slider_musica: HSlider = %SliderMusica
@onready var _slider_efectos: HSlider = %SliderEfectos
@onready var _etiqueta_musica: Label = %EtiquetaMusica
@onready var _etiqueta_efectos: Label = %EtiquetaEfectos


## Muestra el panel con los sliders en el volumen actual de cada bus.
func abrir() -> void:
	_slider_musica.set_value_no_signal(GestorAudio.obtener_volumen("Musica"))
	_slider_efectos.set_value_no_signal(GestorAudio.obtener_volumen("Efectos"))
	_actualizar_etiquetas()
	visible = true
	_slider_musica.grab_focus()


func _actualizar_etiquetas() -> void:
	_etiqueta_musica.text = "Música  %d %%" % roundi(_slider_musica.value * 100.0)
	_etiqueta_efectos.text = "Efectos  %d %%" % roundi(_slider_efectos.value * 100.0)


func _on_slider_musica_value_changed(valor: float) -> void:
	GestorAudio.aplicar_volumen("Musica", valor)
	_actualizar_etiquetas()


func _on_slider_efectos_value_changed(valor: float) -> void:
	GestorAudio.aplicar_volumen("Efectos", valor)
	GestorAudio.reproducir_efecto("boton")
	_actualizar_etiquetas()


func _on_boton_volver_pressed() -> void:
	visible = false
	cerrado.emit()
