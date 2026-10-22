class_name Checkpoint
extends Area2D
## Estandarte que guarda el punto de reaparición del caballero al tocarlo (RF-06, RN-03).

## Cuadro del sprite con la tela gris (inactivo).
const CUADRO_INACTIVO: int = 0
## Cuadro del sprite con la tela cian (activo).
const CUADRO_ACTIVO: int = 1

var activado: bool = false

@onready var _sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_sprite.frame = CUADRO_INACTIVO


## Registra este checkpoint en EstadoJuego y cambia de color; solo ocurre una vez.
func activar() -> void:
	if activado:
		return
	activado = true
	EstadoJuego.activar_checkpoint(global_position)
	_sprite.frame = CUADRO_ACTIVO
	GestorAudio.reproducir_efecto("checkpoint")


func _on_body_entered(body: Node2D) -> void:
	if body is Caballero:
		activar()
