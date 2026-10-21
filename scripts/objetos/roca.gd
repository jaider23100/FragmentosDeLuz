class_name Roca
extends RigidBody2D
## Roca empujable (RigidBody2D): se mueve cuando el caballero la empuja y sirve de escalón (RF-09).

## Fuerza horizontal aplicada mientras el caballero empuja, en N (unidades de Godot).
@export var fuerza_empuje: float = 900.0
## Velocidad horizontal máxima de la roca, en px/s.
@export var velocidad_maxima: float = 45.0

var _caballero_cerca: Caballero = null


func _physics_process(_delta: float) -> void:
	if _caballero_cerca != null and _lo_esta_empujando(_caballero_cerca):
		apply_central_force(Vector2(signf(_caballero_cerca.intencion_x) * fuerza_empuje, 0.0))
	linear_velocity.x = clampf(linear_velocity.x, -velocidad_maxima, velocidad_maxima)


## El caballero empuja si está a un lado de la roca y quiere moverse hacia ella.
func _lo_esta_empujando(caballero: Caballero) -> bool:
	if caballero.intencion_x == 0.0:
		return false
	var lado: float = signf(global_position.x - caballero.global_position.x)
	return signf(caballero.intencion_x) == lado and absf(caballero.global_position.y - global_position.y) < 14.0


func _on_area_empuje_body_entered(body: Node2D) -> void:
	if body is Caballero:
		_caballero_cerca = body as Caballero


func _on_area_empuje_body_exited(body: Node2D) -> void:
	if body == _caballero_cerca:
		_caballero_cerca = null
