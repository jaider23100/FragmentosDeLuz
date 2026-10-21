class_name Checkpoint
extends Area2D
## Estandarte que guarda el punto de reaparición del caballero al tocarlo (RF-06, RN-03).

const COLOR_INACTIVO: Color = Color(0.45, 0.45, 0.5)
const COLOR_ACTIVO: Color = Color(0.373, 0.953, 1.0)

var activado: bool = false

@onready var _bandera: ColorRect = $Bandera


func _ready() -> void:
	_bandera.color = COLOR_INACTIVO


## Registra este checkpoint en EstadoJuego y cambia de color; solo ocurre una vez.
func activar() -> void:
	if activado:
		return
	activado = true
	EstadoJuego.activar_checkpoint(global_position)
	_bandera.color = COLOR_ACTIVO


func _on_body_entered(body: Node2D) -> void:
	if body is Caballero:
		activar()
