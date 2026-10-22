class_name Santuario
extends Area2D
## Santuario del Cristal: con los 5 fragmentos restaura el Cristal y gana el nivel;
## si faltan, muestra cuántos (RF-13, RN-06).

## Cuadro del sprite con el altar vacío.
const CUADRO_VACIO: int = 0
## Cuadro del sprite con el Cristal restaurado.
const CUADRO_RESTAURADO: int = 1

var restaurado: bool = false

@onready var _sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_sprite.frame = CUADRO_VACIO


## Intenta restaurar el Cristal. Devuelve true si el nivel se completó.
func intentar_restaurar() -> bool:
	if restaurado:
		return false
	if not EstadoJuego.puede_ganar():
		var hud: Hud = get_tree().get_first_node_in_group("hud") as Hud
		if hud != null:
			hud.mostrar_mensaje(EstadoJuego.mensaje_faltantes())
		return false
	restaurado = true
	_sprite.frame = CUADRO_RESTAURADO
	EstadoJuego.completar_nivel()
	return true


func _on_body_entered(body: Node2D) -> void:
	if body is Caballero:
		intentar_restaurar()
