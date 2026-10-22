class_name MenuPausa
extends CanvasLayer
## Menú de pausa: detiene el juego con Esc y permite continuar, reiniciar o salir al menú (RF-15).
##
## Usa process_mode = ALWAYS para seguir recibiendo la tecla Esc mientras el árbol está en pausa.

@onready var _boton_continuar: Button = %BotonContinuar
@onready var _boton_opciones: Button = %BotonOpciones
@onready var _contenedor: VBoxContainer = $Contenedor
@onready var _opciones: Opciones = %Opciones


func _ready() -> void:
	visible = false


func _unhandled_input(evento: InputEvent) -> void:
	if not evento.is_action_pressed("pausa"):
		return
	if _opciones.visible:
		_opciones.visible = false
		_on_opciones_cerrado()
	elif visible:
		reanudar()
	elif EstadoJuego.fase == EstadoJuego.Fase.JUGANDO:
		pausar()
	get_viewport().set_input_as_handled()


## Detiene el juego y muestra el menú (fase PAUSA).
func pausar() -> void:
	get_tree().paused = true
	visible = true
	EstadoJuego.cambiar_fase(EstadoJuego.Fase.PAUSA)
	_boton_continuar.grab_focus()


## Oculta el menú y reanuda el juego (fase JUGANDO).
func reanudar() -> void:
	get_tree().paused = false
	visible = false
	EstadoJuego.cambiar_fase(EstadoJuego.Fase.JUGANDO)


func _on_boton_continuar_pressed() -> void:
	reanudar()


func _on_boton_reiniciar_pressed() -> void:
	GestorEscenas.cambiar_escena(GestorEscenas.NIVEL)


func _on_boton_salir_pressed() -> void:
	GestorEscenas.cambiar_escena(GestorEscenas.MENU)


func _on_boton_opciones_pressed() -> void:
	_contenedor.visible = false
	_opciones.abrir()


func _on_opciones_cerrado() -> void:
	_contenedor.visible = true
	_boton_opciones.grab_focus()
