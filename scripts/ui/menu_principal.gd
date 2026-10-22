class_name MenuPrincipal
extends Control
## Menú principal: iniciar partida, opciones, créditos y salir (RF-18).

@onready var _boton_jugar: Button = %BotonJugar
@onready var _boton_opciones: Button = %BotonOpciones
@onready var _contenedor: VBoxContainer = $Contenedor
@onready var _opciones: Opciones = %Opciones


func _ready() -> void:
	EstadoJuego.cambiar_fase(EstadoJuego.Fase.MENU)
	_boton_jugar.grab_focus()


func _on_boton_jugar_pressed() -> void:
	GestorEscenas.iniciar_partida()


func _on_boton_opciones_pressed() -> void:
	_contenedor.visible = false
	_opciones.abrir()


func _on_opciones_cerrado() -> void:
	_contenedor.visible = true
	_boton_opciones.grab_focus()


func _on_boton_salir_pressed() -> void:
	get_tree().quit()
