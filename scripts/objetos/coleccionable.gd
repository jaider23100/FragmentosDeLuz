class_name Coleccionable
extends Area2D
## Clase base de los objetos que se recogen al tocarlos: flotan, brillan y avisan a EstadoJuego.

## Altura del vaivén vertical, en px.
const AMPLITUD_FLOTE: float = 2.0
## Velocidad del vaivén, en radianes por segundo.
const VELOCIDAD_FLOTE: float = 3.0
## Cambios de cuadro de la animación por segundo.
const CUADROS_POR_SEGUNDO: float = 3.0

var _tiempo: float = 0.0
var _y_inicial: float = 0.0

@onready var _sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_y_inicial = _sprite.position.y
	_tiempo = randf() * TAU


func _process(delta: float) -> void:
	_tiempo += delta
	_sprite.position.y = _y_inicial + sin(_tiempo * VELOCIDAD_FLOTE) * AMPLITUD_FLOTE
	_sprite.frame = int(_tiempo * CUADROS_POR_SEGUNDO) % _sprite.hframes


## Acción al ser recogido; la implementan las clases hijas.
func _al_recoger() -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Caballero:
		_al_recoger()
		queue_free()
