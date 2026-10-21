class_name Slime
extends Enemigo
## Slime de Sombra: patrulla de lado a lado y gira al encontrar una pared o un borde (RF-07).

enum Estado { PATRULLANDO, HERIDO, MUERTO }

## Velocidad de patrulla, en px/s.
@export var velocidad: float = 40.0
## Gravedad aplicada al slime, en px/s².
@export var gravedad: float = 800.0

var estado: Estado = Estado.PATRULLANDO
## 1 si avanza a la derecha, -1 si avanza a la izquierda.
var direccion: int = -1

@onready var _raycast_pared: RayCast2D = $RayCastPared
@onready var _raycast_borde: RayCast2D = $RayCastBorde


func _ready() -> void:
	super()
	_orientar_raycasts()


## Muere y deja de patrullar (RN-05).
func morir() -> void:
	estado = Estado.MUERTO
	super()


func _mover(delta: float) -> void:
	if estado == Estado.PATRULLANDO:
		_patrullar(delta)


func _patrullar(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravedad * delta
	if _debe_girar():
		direccion *= -1
		_orientar_raycasts()
	velocity.x = direccion * velocidad
	move_and_slide()


## Devuelve true si delante hay una pared o se acaba el suelo.
func _debe_girar() -> bool:
	if not is_on_floor():
		return false
	return _raycast_pared.is_colliding() or not _raycast_borde.is_colliding()


func _orientar_raycasts() -> void:
	_raycast_pared.target_position = Vector2(direccion * 8.0, 0.0)
	_raycast_borde.position = Vector2(direccion * 7.0, 0.0)
	_raycast_pared.force_raycast_update()
	_raycast_borde.force_raycast_update()
